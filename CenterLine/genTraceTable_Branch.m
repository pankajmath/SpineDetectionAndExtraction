% Copyright © 2012 Computational Biomedicine Lab (CBL), 
% University of Houston. All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, is prohibited without the prior written consent of CBL.
%

function T = genTraceTable_Branch(T)
% This function takes a struct T containing the path and respective
% parents, and returns the same struct, with the respective Amira Spatial
% Graph table, plus a bit more information.
% 
% Input: 
%  - T: A struct that contains the following fields.
%    * path: The indices of the path of the centerline.
%    * parents: The set of parents for each point in the centerline.
%    * siz: The size of the volume that is being processed.
%    * dist: set of distance values for the path places.
% 
% Output:
%  - T: A struct that contains the following new fields.
%    * degree: The degree of each vertex
%    * roots: The set of roots in the paths.
%    * termPoints: The set of the terminal point.
%    * branchPnts: The branching point.
%    * amiraTable: The annotated Amira table of the Spatial Graph.
% 

% Initialize the Data of T.
T = initializeData(T);
T = cleanTable(T); 

% Generate amira table
N = numel(T.path);
I = (1:N)';
J=zeros(N,1);
[~, P] = ismember(T.parents,T.path);
P(P==0) = -1; % annotate the root vertices
Q=ismember(T.path,T.branchPnts);%branching points

R=ismember(T.path,T.termPoints); % terminal points

J(Q)=5; %annotate the branching points
J(R)=6; % annotating the terminal points

[X Y Z] = ind2sub(T.siz, T.path);
D = T.dist;


T.amiraTable = cat(2,I,J,X,Y,Z,D,P);

end


function T = cleanTable(T)
% This function takes the initialized struct T, and searches for false
% brances, defined as branches that are shorter than the distance function
% at the branching point. Once identified, these branches are removed. 
% 
% 
% Input: 
%  - T: A struct that contains the following fields.
%    * path: The indices of the path of the centerline.
%    * parents: The set of parents for each point in the centerline.
%    * siz: The size of the volume that is being processed.
%    * dist: set of distance values for the path places.
%    * degree: The degree of each vertex
%    * roots: The set of roots in the paths.
%    * termPoints: The set of the terminal point.
%    * branchPnts: The branching point.
% 
% Output:
%  - T: A struct containing the same fields, but modified.
% 

SP = cell(size(T.termPoints));
PL = zeros(size(T.termPoints));

for k = 1:numel(T.termPoints)
    P = [];
    node = T.termPoints(k);
    FLAG = true;
    while FLAG
        if ismember(node,T.branchPnts)
            FLAG = false;
        else
            P = cat(1,P,node);
            idx = T.path == node;
            node = T.parents(idx);
            if node < 1
                FLAG = false;
            end
        end
    end
    SP{k} = P;
    PL(k) = numel(P);
end

I = (PL < max(T.dist));
E = cat(1,SP{I});
[~,I] = ismember(E,T.path);
T.path(I) = [];
T.parents(I) = [];
T.dist(I) = [];
T = initializeData(T);

end


function T = initializeData(T)
% This function takes the output of joinSeeds, and identifies the degrees
% of each node, the roots, the terminal points and the branching points of
% the structure.
% 
% Input: 
%  - T: A struct that contains the following fields.
%    * path: The indices of the path of the centerline.
%    * parents: The set of parents for each point in the centerline.
%    * siz: The size of the volume that is being processed.
%    * dist: set of distance values for the path places.
% 
% Output:
%  - T: A struct that contains the following new fields.
%    * degree: The degree of each vertex
%    * roots: The set of roots in the paths.
%    * termPoints: The set of the terminal point.
%    * branchPnts: The branching point.
% 
N = numel(T.path); % The number of points in the path
[~,pridx] = ismember(T.parents,T.path); % Parent index.
T.roots = find(pridx==0);
pridx(T.roots) = N + 1;
T.degree = accumarray(pridx,ones(size(N+1,1)));
T.degree(T.roots) = T.degree(T.roots) - 1;
T.degree(end) = [];
T.termPoints = T.path(T.degree < 1);
T.branchPnts = T.path(T.degree > 1);

end


% CREATED: 
% - Date: 09/04/2012
% - By: David Jimenez.
%EDITED:
%- Date: 03/02/2014
% - By: Pankaj Singh.
%
