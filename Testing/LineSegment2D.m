% given two points(pixels) in a 3D segmented volume(2D binary image),
% this script finds the line segment joining these points(pixels) and
% calculates the sum of the intensities along this line segment



n=10; % size of the image(square in this case, could be rectangular)
m=10;
b=zeros(n,m); % binary image of size m by n 
% x-coordinates of the points
x1=2;
x2=7;
% y-coordinates of the points
y1=2;
y2=9;

p1=[x1,y1]; % the first point
p2=[x2,y2]; % the second point
length=norm(p1-p2); % distance between the points

%li=line(X,Y);

n_samples=round(10*length); % number of sample points 

x_sample=x1+(x2-x1)*linspace(0,1,n_samples); % sample points in the x-direction

y_sample=y1+(y2-y1)*linspace(0,1,n_samples);  % sample points in the y-direction

x_round=round(x_sample); % round them off to get the integer grid in x-direction
y_round=round(y_sample); % round them off to get the integer grid in y-direction

combine=cat(1,x_round,y_round);

% removing the repeating sample points from the grid
[M,ind] = unique(combine', 'rows', 'first');
[~,ind] = sort(ind);
M = M(ind,:);
M=M';

[r,c ]=size(M);

for i=1:c
    b(M(1,i),M(2,i))=1;
end
rows=M(1,:);
cols=M(2,:);

idx = sub2ind(size(b), rows, cols);

line_seg_len=sum(b(idx));

figure,imshow(b)
b

% b1=b;
