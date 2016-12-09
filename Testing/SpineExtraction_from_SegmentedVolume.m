

tic;

%filepath='Y:\Documents\Spine\Common\Log_Common\SmallPortion\';
filepath= 'C:\Users\pankaj singh\Desktop\Read\MatlabExp\TaraKeck\Stack1\Common\Log_Common\SmallPortion\Time2\';

fOrig='Time_2_Partial_OrgVol';

fSeg='Time_2_Partial';

fEnd='Time_2_Partial_detectedEndPoints';

fSwc='Time_2_Partial_CL.swc';

%fCenLine='Test_Log_Common_1_CL_f4_whole';
fCenLine='Time_2_Partial_CenterLine1';

S = RAWfromMHD(fSeg,[],filepath); % the segmented Volume

O = RAWfromMHD(fOrig,[],filepath); % the Original Volume

E = RAWfromMHD(fEnd,[],filepath); % the End points

C = RAWfromMHD(fCenLine,[],filepath); % The centerline

CL=importdata(fSwc);% the SWC file containing the information related to the centerline




r=10; % the radius in which we look for the spines around the detected end points


idx= find(S==1);% the indices in the segmented file having value 1

[x, y, z]= ind2sub(size(S),idx);% convert them to (x,y,z)-coordinates

A=[x y z];

D=zeros(1,numel(idx));

indE=find(E==1);


part=200;

V=zeros(size(S));
radius1 = zeros(1,numel(indE));

for t=1:numel(indE)

[c, d, e]=ind2sub(size(E),indE(t));
pt=[c d e];


for i=1:numel(idx)
    D(i)=norm(pt-A(i,:));
end



for i=1:part
    

ids= D<=i*r/part;

a(i)= numel(find(C(idx(ids))==1));

end

id=find(a>0); % first time the centerline is intersected

%jd=find(a>=2); % first time two or more voxels of the centerline are intersected

if numel(id)>0
    
i=id(1)*r/part; % radius toching the centerline


else
    
    i=0;
    
end

    
if i >2

% j=jd(1)*r/part;
% 
% k=i-3*(j-i); % radius to capture neck of the spine
% 
%  ids= D<=k;
% 
% V=zeros(size(S));
% V(idx(ids))=1;
% 
% %WriteRAWandMHD(uint8(V),'Component_Neck_11',pwd)
% nnz(V)

ids1=find(D<=i);

b= C(idx(ids1))==1;

abc=idx(ids1(b));

[c, d, e]=ind2sub(size(C),abc(1));

logic=logical([CL(:,3)==c, CL(:,4)==d CL(:,5)==e])';

f=find(sum(logic)==3); 

%rad=CL(f,6);

%rad=round(CL(f,6)*10)/10;

rad= floor(CL(f,6));

%rad=CL(f,6)*0.75;

radius1(t)=CL(f,6)*0.75;

ids=find(D<=(i-rad));

%V=zeros(size(S));
V(idx(ids))=1;
end

end

%WriteRAWandMHD(uint8(V),'Component_Neck_New',pwd)
nnz(V)




% V=zeros(size(S));
% V(idx(ids))=1;
% 
% WriteRAWandMHD(uint8(V),'Component_11',pwd)
% 
% 
% ids=find(D<=r/3);
% 
% V=zeros(size(S));
% V(idx(ids))=1;
% 
% WriteRAWandMHD(uint8(V),'Component_rby3_11',pwd)
%[I,J] = IND2SUB(SIZE(D),FIND(A>5)) 

% to find the branching points from the swc file...


cl=CL(:,7);

[a,b]=hist(cl,unique(cl));


c=find(a>=2);



b(c); % the values in the 7th column which repaeat themselves


a(c); % number of times values repeated


d= cell(1,numel(c));

for i=1:numel(c)

d{i}=find(cl==b(c(i)));

end






toc;



