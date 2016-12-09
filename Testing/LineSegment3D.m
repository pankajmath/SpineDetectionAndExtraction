% given two points(voxels) in a 3D segmented volume(3D binary image),
% this script finds the line segment joining these points(voxels) and
% calculates the sum of the intensities along this line segment


n=50; % the dimension of the cubic

b=zeros(n,n,n); % creating n X n X n 3D solid

% providing the coordinates of the points
x1=1; % x value of the first point
x2=50; %y value of the first point
y1=1;
y2=50;
z1=1;
z2=50; %z value of the second point

p1=[x1,y1,z1]; % first point
p2=[x2,y2,z2]; % second point

% Euclidean length of the line segment
length=norm(p1-p2);

n_samples=round(10*length); % number of sample points

x_sample=x1+(x2-x1)*linspace(0,1,n_samples); %sample points in x-direction

y_sample=y1+(y2-y1)*linspace(0,1,n_samples); %sample points in y-direction

z_sample=z1+(z2-z1)*linspace(0,1,n_samples); %sample points in z-direction

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
[r,c ]=size(M);

% % putting 1's at each of the grid points
for i=1:c
    b(M(1,i),M(2,i),M(3,i))=1;
end

% subscripts in all the three directions
xdir=M(1,:);
ydir=M(2,:);
zdir=M(3,:);

% converting subscripts to indices
idx = sub2ind(size(b), xdir,ydir,zdir);

% finding the sum of the intensities along the line segment
% joining the given two voxels
sum_intensity_seg=sum(b(idx));

%figure,imshow(b(:,:,35))

% b1=b;
