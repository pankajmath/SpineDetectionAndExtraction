% Copyright © 2012 Computational Biomedicine Lab (CBL), 
% University of Houston. All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, is prohibited without the prior written consent of CBL.
%

function [S D I] = genSeeds(B,LB,ZS)
% This function generates the seeds for tracing.
% 
% INPUT:
%  - B: Binary solid.
%  - LB: Lower bound on seed creating.
%  - ZS: Z-smear factor.
% 
% OUTPUT:
%  - S: List of indices of seeds (Set of seeds).
%  - D: Distance transform solid.
%  - I: Set of indices on the solid inside the volume.
% 

minComp = 100;
cutOff = sqrt(3)-sqrt(2);
maxCubeSize = 5;

% This part takes the noise out, deleting any connected component with less
% than minComp voxels
C = connComp(B);
I = C.compCard > minComp;
I = cat(1,C.compIdx{I});
B(:) = 0;
B(I) = 1;

% Some Constants
dim = ndims(B);
siz = size(B);

% Computation of the Distance Solid.
B = uint8(B);  
D = bwdist(1-B);


D(D<1) = 1;
k = 2*min(floor(max(D(D>.5))),maxCubeSize);

% More Constants
c = 3; d = 3;
s = c*ones(1,d);
box = circshift(siz,[0,1]);
box(1) = 1;
box = cumprod(box);
box = arrayfun(@(x)[-x,0,x],box,'UniformOutput', false);
[box{:}] = ndgrid(box{:});
box = sum(cat(dim+1,box{:}),dim+1);
box = box(:);
F = ((-1)/(c^d-1))*ones(s);
F((c^d+1)/2) = 1;

M = true(siz);
M(3:end-2,3:end-2,3:end-2) = false;
C = convn(D,F,'same');
C(M) = 0;
C = C/max(abs(C(:)));
E = C>LB;

F = find(E);
V = false(size(F));
N = numel(F);

parfor n = 1:N
    idx = F(n);
    neig = idx+box;
    x = max(D(neig));
    y = D(idx);
    if ((x-y)<cutOff)
        V(n) = true;
    end
end

F = F(V);
V = true(size(F));
N = numel(F);

parfor n = 1:N
    idx = F(n);
    neig = idx+box;
    neig = intersect(neig,F);
    x = max(D(neig));
    y = D(idx);
    if x < y
        V(n) = false;
    end
end

F = F(V);
Fd = D(F);
S = [];
box = circshift(siz,[0,1]);
box(1) = 1;
box = cumprod(box);
box = arrayfun(@(x)-k*x:x:k*x,box,'UniformOutput', false);
[box{:}] = ndgrid(box{:});
box = sum(cat(dim+1,box{:}),dim+1);
box = double(box(:));

while ~isempty(F)
    [~,i] = max(Fd);
    idx = F(i);
    S = cat(1,S,idx);
    neig = double(idx) + double(box);
    F = setdiff(F,neig);
    Fd = D(F);
end

r = ceil(max(D(:))*ZS)+2;

V = getPCA(S,siz,2*ZS*r);

box = circshift(siz,[0,1]);
box(1) = 1;
box = cumprod(box);
box = arrayfun(@(x)-r*x:x:r*x,box,'UniformOutput', false);
[box{:}] = ndgrid(box{:});
box = sum(cat(dim+1,box{:}),dim+1);
box = double(box(:));
box(abs(box) < .5) = []; % Eliminating the place of the seed itself

N = numel(S);
J = true(size(S));

parfor n = 1:N
    idx = S(n);
    reg = idx + box;
    reg = intersect(reg,S);
    if ~isempty(reg)
        v = V(n,:).';
        [X,Y,Z] = ind2sub(siz,reg);
        [x,y,z] = ind2sub(siz,idx);
        X = X - x;
        Y = Y - y;
        Z = Z - z;
        W = cat(2,X,Y,Z);
        W = W./repmat(sqrt(diag(W*W')),1,dim);
        W = abs(W*v);
        K = (W < 0.5);
        if D(idx) < max(D(reg(K)))
            J(n) = false;
        elseif D(idx) == max(D(reg(K)))
            DROP = dropSeedByProjections(B,idx,reg(K),2*r);
            if DROP
                J(n) = false;
            end
        end
    end
end

S = S(J);
DI = D(I);
D(:) = 0;
D(I) = DI; 

SS = secondRoundSeeding(D,S,ZS);

S = cat(1,S,SS);

end


function SS = secondRoundSeeding(D,S,ZS)
% secondRoundSeeding takes the distance solid and the current seeds, and
% completes the seeding by adding additional seeds on undersampled regions.
% Its speed could be improved.
% 
% INPUT:
%  - D: Distance Solid.
%  - S: Set of seeds, as indices of D.
% 
% OUTPUT:
%  - SS: Second set of seeds. It may be empty.
% 

DS = ceil(2*ZS*D(S));
sz = size(D);
K = numel(S);
SS = [];

for k = 1:K
    [x y z] = ind2sub(sz,S(k));
    II = -DS(k):DS(k);
    xI = x + II; xI(xI < 1) = []; xI(xI > sz(1)) = [];
    yI = y + II; yI(yI < 1) = []; yI(yI > sz(2)) = [];
    zI = z + II; zI(zI < 1) = []; zI(zI > sz(3)) = [];
    D(xI,yI,zI) = 0; 
end

while any(D(:) > 1.1)
    m = max(D(D>0));
    idx = find(D == m,1);
    m = ceil(2*ZS*m);
    [x,y,z] = ind2sub(sz,idx);
    II = -m:m;
    
    xI = x + II; xI(xI < 1) = []; xI(xI > sz(1)) = [];
    yI = y + II; yI(yI < 1) = []; yI(yI > sz(2)) = [];
    zI = z + II; zI(zI < 1) = []; zI(zI > sz(3)) = [];
    SS = cat(1,idx,SS);
    D(xI,yI,zI) = 0; 
end

end


function DROP = dropSeedByProjections(B,idx,seeds,r)
% This function compare the seeds by projections.
% 
% INPUT:
%  - B: Binary Solid.
%  - idx: Central Index.
%  - seeds: List of other seeds to compare.
%  - r: The "radius" of the region to be considered.
% 
% OUTPUT:
%  - DROP: The resulting decision value.
% 

siz = size(B);
S = zeros(siz,'uint8');
S(seeds) = 1;
S(idx) = 2;

[x,y,z] = ind2sub(siz,idx);

if x - r < 1; xMin = 1; else xMin = x - r; end
if y - r < 1; yMin = 1; else yMin = y - r; end
if z - r < 1; zMin = 1; else zMin = z - r; end

if siz(1) < x + r; xMax = siz(1); else xMax = x + r; end
if siz(2) < y + r; yMax = siz(2); else yMax = y + r; end
if siz(3) < z + r; zMax = siz(3); else zMax = z + r; end

BB = B(xMin:xMax,yMin:yMax,zMin:zMax);
SS = S(xMin:xMax,yMin:yMax,zMin:zMax);

BBx = max(BB,[],1);
BBy = max(BB,[],2);
BBz = max(BB,[],3);
SSx = max(SS,[],1);
SSy = max(SS,[],2);
SSz = max(SS,[],3);
DDx = bwdist(1-BBx);
DDy = bwdist(1-BBy);
DDz = bwdist(1-BBz);

xFLAG = (DDx(SSx == 2) + 1 < max(DDx(SSx == 1)));
yFLAG = (DDy(SSy == 2) + 1 < max(DDy(SSy == 1)));
zFLAG = (DDz(SSz == 2) + 1 < max(DDz(SSz == 1)));

if isempty(xFLAG); xFLAG = false; end
if isempty(yFLAG); yFLAG = false; end
if isempty(zFLAG); zFLAG = false; end

DROP = xFLAG || yFLAG || zFLAG;

end


function V = getPCA(S,siz,r)
% This function computes the estimated direction the centerline by
% principal component analysis on the seed candidates. 
% 
% INPUT:
%  - S: Set of seeds, as indices of the solid.
%  - siz: The size indices of the solid.
%  - r: The radius for edge computation (getEdge).
% 
% OUTPUT:
%  - V: Matrix of principal directions of the elements in the set of seeds.
% 

dim = length(siz);
box = circshift(siz,[0,1]);
box(1) = 1;
box = cumprod(box);
box = arrayfun(@(x)-r*x:x:r*x,box,'UniformOutput', false);
[box{:}] = ndgrid(box{:});
box = sum(cat(dim+1,box{:}),dim+1);
box = box(:);

N = numel(S);
V = zeros(N,dim);

%parfor n = 1:N
 for n = 1:N
    I = intersect(S(n)+box,S);
    J = cell(1,dim);
    [J{:}] = ind2sub(siz,I);
    X = cat(2,J{:});
    CF = princomp(X);
    V(n,:) = CF(:,1)';
end

end

% CREATED: 
% - Date: 09/06/2012
% - By: David Jimenez.
% 
