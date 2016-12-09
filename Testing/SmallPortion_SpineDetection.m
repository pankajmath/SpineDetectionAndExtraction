

tic;

filepath='C:\Users\pankaj singh\Desktop\Read\MatlabExp\TaraKeck\Stack1\Common\Log_Common\SmallPortion\';

fOrig='Test_Log_Common_1_Partial_OrgVol';

fSeg='Test_Log_Common_1_Partial';

fEnd='Test_Log_Common_1_Partial_EndPoints';

fSwc='Test_Log_Common_1_Partial_CL.swc';

%fCenLine='Test_Log_Common_1_CL_f4_whole';
fCenLine='Test_Log_Common_1_Partial_CenterLine';

S = RAWfromMHD(fSeg,[],filepath); % the segmented Volume

O = RAWfromMHD(fOrig,[],filepath); % the Original Volume

E = RAWfromMHD(fEnd,[],filepath); % the End points

C = RAWfromMHD(fCenLine,[],filepath); % The centerline

CL=importdata(fSwc);


p=[21 34 25];

q=[32 36 18];

s=[19,60,18];

r=10;

idx= find(S==1);

[x y z]= ind2sub(size(S),idx);

A=[x y z];

D=zeros(1,numel(idx));

for i=1:numel(idx)
    D(i)=norm(s-A(i,:));
end


part=100;

for i=1:part
    

ids= D<=i*r/part;

a(i)= numel(find(C(idx(ids))==1));

end

id=find(a>0); % first time the centerline is intersected

jd=find(a>=2); % first time two or more voxels of the centerline are intersected

i=id(1)*r/part; % radius toching the centerline

j=jd(1)*r/part;

k=i-3*(j-i); % radius to capture neck of the spine

 ids=find(D<=k);

V=zeros(size(S));
V(idx(ids))=1;

%WriteRAWandMHD(uint8(V),'Component_Neck_11',pwd)
nnz(V)

ids1=find(D<=i);

b=find(C(idx(ids1))==1);

[c d e]=ind2sub(size(C),idx(ids1(b)));

logic=logical([CL(:,3)==c, CL(:,4)==d CL(:,5)==e])';

f=find(sum(logic)==3); 

%rad=CL(f,6);

%rad=round(CL(f,6)*10)/10;

rad= floor(CL(f,6));

ids=find(D<=(i-rad));

V=zeros(size(S));
V(idx(ids))=1;

WriteRAWandMHD(uint8(V),'Component_Neck_RadiusByTwo_8',pwd)
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




toc;



