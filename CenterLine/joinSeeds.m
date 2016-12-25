% Copyright © 2012 Computational Biomedicine Lab (CBL), 
% University of Houston. All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, is prohibited without the prior written consent of CBL.
%

function T = joinSeeds(D,S,I)
% This function joins the seeds in a solid.
% 
% INPUT:
%  - D: Distance Transform Solid.
%  - S: Indices corresponding to each seed.
%  - I: Set of indices that are foreground.
% 
% OUTPUT:
%  - T: Struct element, containing the following fields:
%      * path: The indices of each node of the propose path for the
%              centerline
%      * parents: Parents of each node in the path. The root node has -1 as
%                 parent.
%      * dist: Distance of the path.
%      * siz: The size of the solid being analized
%

siz = size(D);
r = getEdge(D);

B = zeros(size(D));
B(I) = 1;
C = connComp(B);
P1 = cell(C.compNum,1);
P2 = cell(C.compNum,1);

 for k = 1:C.compNum
%parfor k = 1:C.compNum
    SS = intersect(S, C.compIdx{k});
    DD = D(C.compIdx{k});
    VV = getPCA(S,siz,r);
    if ~isempty(SS)
       [P1{k} P2{k}] = traceComponent(C.compIdx{k},SS,DD,siz,VV);
    else
        P1{k} = [];
        P2{k} = [];
    end
end

T.path = cat(1,P1{:});
T.parents = cat(1,P2{:});
T.dist = D(T.path);
T.siz = siz;

end


function [path, prnt] = traceComponent(II,SS,DD,sz,VV)
% This function joints all the seed in one given component.
% 
% INPUT:
%  - II: Set of indices of the components
%  - SS: List of seeds for this particular component.
%  - DD: Set of distances for the components in II;
%  - sz: The size of the volume.
% 
% OUTPUT:
%  - path: The path
%  - prnt: The parents of the elements in the path.
% 

% Generate the additive indices for potential neigbors. 
box = circshift(sz,[0,1]);
box(1) = 1;
box = cumprod(box);
box = arrayfun(@(x)[-x,0,x],box,'UniformOutput', false);
[box{:}] = ndgrid(box{:});
box = sum(cat(4,box{:}),4);
box = double(box(:));
box(box==0) = [];

% The distance and weight solid.
D = zeros(sz);
D(II) = DD;
W = D.^(-1);

% Startpoint
[~,start] = max(D(SS));
path = SS(start);
prnt = -1;
FLAG = true;

while FLAG
    uS = setdiff(SS,path); % Unvisited seeds
    vS = setdiff(SS,uS); % Visited seeds
    if isempty(uS)
        FLAG = false;
    elseif numel(uS) == 1
        k = find(SS == uS,1);
        v = VV(k,:);
        R = joinSeed2Path(uS,path,II,v,box,W(II),sz);
        path = cat(1,path,R(2:end));
        prnt = cat(1,prnt,R(1:(end-1)));
    else
        nS = nextSeed(uS,vS,sz); % next seed.
        k = find(SS == nS,1);
        v = VV(k,:);
        R = joinSeed2Path(nS,path,II,v,box,W(II),sz);
        path = cat(1,path,R(2:end));
        prnt = cat(1,prnt,R(1:(end-1)));
    end
end

end


function subpath = joinSeed2Path(seed,path,idxs,dir,edgn,wgts,sz)
% This function returns the region that connects the seed and the path,
% with the elements in edgn as the edge generator.
% 
% INPUT:
%  - seed: The point to connect to the path.
%  - path: Set of continuous points we want to connect seed to.
%  - idxs: Set of indices one can traverse.
%  - edgn: Edge generator.
%  - wgts: The weights of all the indices.
% 
% OUTPUT:
%  - subpath: The subpath that joins the seed to the main path.
% 

% Generation of set of discrete distances.
x = -1:1;
[X,Y,Z] = ndgrid(x,x,x);
D = sqrt(X.^2+Y.^2+Z.^2);
X(D==0)=[]; Y(D==0)=[]; Z(D==0)=[]; D(D==0)=[];
X = X(:); Y = Y(:); Z = Z(:); D = D(:);
X = X./D; Y = Y./D; Z = Z./D;
A = [X(:),Y(:),Z(:)];

% obtain the right 
X = dir*A';
[~,dir] = max(X);

% Initialization.
region = seed; % Initialize the region
prevnb = seed; % First previous neighbors
FLAG = true; % Flag to detect when to stop.

while FLAG
    [nbhd cntr] = ndgrid(edgn,prevnb);
    neig = unique(nbhd+cntr);
    neig = intersect(neig,idxs);
    prevnb = setdiff(neig,region);
    region = cat(1,region,neig);
    if any(ismember(neig,path))
        FLAG = false;
    elseif isempty(neig)
        FLAG = false;
    end
end

% The Dijkstra part of the algorithm
region = unique(region);
[nbhd cntr] = ndgrid(edgn,region);
adjm = nbhd + cntr;

[edgs locs] = ismember(adjm,region); % Edges and location
[~,reg] = ismember(region, idxs);
wgar = wgts(reg);

vstd = false(size(region)); % visited vertices.
valu1 = inf(size(region)); % Value to reach the respective vertex
valu2 = inf(size(region)); % Second Value
prnt = zeros(size(region)); % Parent
drtn = zeros(size(region)); % Directions
nxeg = vstd; % Next edges to visit.
nxrd = nxeg; % Next round.
path = intersect(path,region);
[~, path] = ismember(path,region);
seed = find(region == seed);
nxeg(seed) = true;

valu1(seed) = 0;
valu2(seed) = 0;
drtn(seed) = dir; % Direction

FLAG = true;

while FLAG
    while any(nxeg) && ~all(vstd(path))
        
        idx = find(nxeg,1); % Index that is being processed
        nxeg(idx) = false; % Indicating that the index has been visited
        neig = locs(edgs(:,idx),idx);
        neig = setdiff(neig,find(vstd));
        [~,I] = ismember(neig,locs(:,idx));
        nxrd(neig) = true;
        
        if numel(I) > 0
            neigIdx = region(neig);
            [neigX neigY neigZ] = ind2sub(sz,neigIdx);
            neigCoord = [neigX neigY neigZ];
            
            [x y z] = ind2sub(sz,region(path));
            pathDir = [x y z];
            if size(pathDir) > 1
                pathDir = mean(pathDir);
            end
            
            pathDir = repmat(pathDir,size(neigCoord,1),1);
            pathDir = pathDir - neigCoord;
            pathDir = pathDir./repmat(sqrt(diag(pathDir*pathDir')),1,...
                size(pathDir,2));
            frstDir = A(I,:);
            
            prvw1 = valu1(neig);
            prvw2 = valu2(neig); % Second passed weight
            curw1 = wgar(neig) + valu1(idx);
            curw2 = 1 - sum(pathDir.*frstDir,2);
            adjv = find((curw1<prvw1) | ((curw1-prvw1 < 0.5)&(curw2<prvw2)));
            adin = neig(adjv);
            valu1(adin) = curw1(adjv);
            valu2(adin) = curw2(adjv);
            drtn(adin) = adjv;
            prnt(adin) = idx;
        end
        vstd(idx) = true;
    end
    neig = setdiff(find(nxrd),find(vstd));
    nxeg(neig) = true;
    if isempty(nxeg)
        FLAG = false;
    elseif all(vstd(path))
        FLAG = false;
    end
end

[~,i] = min(valu1(path));
idx = path(i);
subpath = idx;

while idx ~= seed
    idx = prnt(idx);
    subpath = cat(1,subpath,idx);
end

subpath = region(subpath);

end


function idx = nextSeed(U,V,S)
% This function decides, among the unvisited seeds, what is the closest to
% the set of seeds already considered, and chooses that to be the next to
% try to join.
% 
% INPUT:
%  - U: Set of indices for the unvisited seeds.
%  - V: Set of indices for the visited seeds.
%  - S: The size of solid.
% 
% OUTPUT:
%  idx: The index, in the solid index system, of the next 
% 

nV = numel(V);
nU = numel(U);
[UX UY UZ] = ind2sub(S,U);
[VX VY VZ] = ind2sub(S,V);
UC = cat(2,UX,UY,UZ).';
VC = cat(2,VX,VY,VZ).';
U2 = repmat(sum(UC.^2),[nV,1]);
V2 = repmat(sum(VC.^2).',[1,nU]);
UV = VC'*UC;
D = U2+V2-2*UV;
if nV > 1
    D = min(D);
    [~,idx] = min(D);
else
    [~,idx] = min(D);
end

idx = U(idx);

end


function r = getEdge(D)
% This function computes the edge of the window to use for the computation
% of the principal components.
% 
% INPUT:
%  - D: Distance solid.
% 
% OUTPUT:
%  - r: Radius used to obtain the edge of the window for PCA.
% 

A = uint8(D>.5);
N = ndims(A);
dV = zeros(N,1);

parfor n = 1:N
    B = max(A,[],n);
    B = bwdist(1-B);
    dV(n) = max(B(:));
end

r = ceil(max(dV)+2);

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
