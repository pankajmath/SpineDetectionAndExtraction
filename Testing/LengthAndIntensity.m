% given two points(voxels) in a 3D segmented volume(3D binary image),
% this script finds the line segment joining these points(voxels) and
% calculates the sum of the intensities along this line segment

%Input:
% newdata: the binary solid in .mat format
% p1: the first point(voxel)
% p2: the second point(voxel)

%Output:
% length_line: the length of the line segemt joining these voxels, i.e, the
% number of volxels in the line segment
% sum_alongLine: the sum of the intensities along the line segment joining
% these voxels

function [length_line, sum_alongLine]= LengthAndIntensity(newdata,p1,p2)




% Euclidean length of the line segment
length=norm(p1-p2);

n_samples=round(2*length); % number of sample points

x_sample=p1(1)+(p2(1)-p1(1))*linspace(0,1,n_samples); %sample points in x-direction

y_sample=p1(2)+(p2(2)-p1(2))*linspace(0,1,n_samples); %sample points in y-direction

z_sample=p1(3)+(p2(3)-p1(3))*linspace(0,1,n_samples); %sample points in z-direction

x_round=round(x_sample); % x-grid
y_round=round(y_sample); % y-grid
z_round=round(z_sample); % z-grid

combine=cat(1,x_round,y_round,z_round); % points on the 3D grid

% removing the multiple entries in the above grid
[M,ind] = unique(combine', 'rows', 'first');
[~,ind] = sort(ind);
M = M(ind,:);
M=M';

%extracting the number of rows and columns
[~,c ]=size(M);



% subscripts in all the three directions
xdir=M(1,:);
ydir=M(2,:);
zdir=M(3,:);

% converting subscripts to indices
idx = sub2ind(size(newdata), xdir,ydir,zdir);

% finding the sum of the intensities along the line segment
% joining the given two voxels
sum_alongLine=sum(newdata(idx));
length_line = c;

%figure,imshow(b(:,:,35))

% b1=b;
