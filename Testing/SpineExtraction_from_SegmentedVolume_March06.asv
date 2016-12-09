

tic;

%filepath='Y:\Documents\Spine\Common\Log_Common\SmallPortion\';
filepath= 'C:\Users\pankaj singh\Desktop\Read\MatlabExp\TaraKeck\Stack1\Common\Log_Common\SmallPortion\Time2\';

fOrig='Time_2_Partial_OrgVol';

fSeg='Time_2_Partial';

fEnd='Time_2_Partial_detectedEndPoints';

fSwc='Time_2_Partial_CL_Branch.swc';

%fCenLine='Test_Log_Common_1_CL_f4_whole';
fCenLine='Time_2_Partial_CenterLine1';

% fOrig='Log_Common_1';
%
% fSeg='Log_Common_1_E2_sigma_2_Segmentation_SPINES_s_2_t_0_8_b_500';
%
% fEnd='Log_Common_1_detectedEndPoints';
%
% fSwc='Log_Common_1_E2_sigma_2_Segmentation_SPINES_s_2_t_0_8_b_500_CL.swc';
%
% %fCenLine='Test_Log_Common_1_CL_f4_whole';
% fCenLine='Log_Common_1_E2_sigma_2_Segmentation_SPINES_s_2_t_0_8_b_500_CenterLine';

S = RAWfromMHD(fSeg,[],filepath); % the segmented Volume

O = RAWfromMHD(fOrig,[],filepath); % the Original Volume

E = RAWfromMHD(fEnd,[],filepath); % the End points

C = RAWfromMHD(fCenLine,[],filepath); % The centerline

CL=importdata(fSwc);% the SWC file containing the information related to the centerline

%C=CL(:,3:5);


r=11; % the radius in which we look for the spines around the detected end points


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
    
    intersection= D<=r;
    
    if numel(find(C(idx(intersection))==1))>0
        
        a=zeros(1,part);
        
        for i=1:part
            ids= D<=i*r/part;
            a(i)= numel(find(C(idx(ids))==1));
        end
        
        id=find(a>0); % first time the centerline is intersected
        
        %jd=find(a>=2); % first time two or more voxels of the centerline are intersected
        
        i=id(1)*r/part; % radius toching the centerline
        
        if i >2
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
            
            ids2=find(D<=(i-rad));
            
            %V=zeros(size(S));
            V(idx(ids2))=1;
        end
        
    end
end
%WriteRAWandMHD(uint8(V),'Component_Neck_New',pwd)
nnz(uint8(V))



PathPts=CL(:,3:5); %Centerline points (x y z coordinates)
BranchPts=CL(CL(:,2)==5,3:5); %Branching points (x y z coordinates)
TermPts=CL(CL(:,2)==6,3:5); %Terminal points (x y z coordinates)

% generating branching points and their immediate neighbours
limitLoop=1;
BrNbd=zeros(size(S));
for i =1:size(BranchPts,1)
    
    BrNbd(BranchPts(i,1)-limitLoop:BranchPts(i,1)+limitLoop,BranchPts(i,2)...
        -limitLoop:BranchPts(i,2)+limitLoop,BranchPts(i,3)-limitLoop:BranchPts(i,3)+limitLoop)=1;
    
end

PathNbd=C-uint8(BrNbd);
%PathNbd(PathNbd<0)=0;

DD = bwconncomp(PathNbd);

TermIdx=sub2ind(size(S),TermPts(:,1),TermPts(:,2),TermPts(:,3));

BranchLen=zeros(1,numel(TermIdx));
for i=1:numel(TermIdx)
    
    for j=1:DD.NumObjects
        
        if numel(find(DD.PixelIdxList{j}==TermIdx(i)))>0;
            BranchLen(i)=numel(DD.PixelIdxList{j});
        end
        
        
    end
    
    
    
end


small=find(0 < BranchLen &  BranchLen<12);

Eind=find(E==1);
[x2 y2 z2]=ind2sub(size(B),Eind);
E1=[x2 y2 z2];

%A the coordinates of the segemented volume

Dis=zeros(1,numel(idx));
Distance=zeros(1,numel(Eind));
Component=zeros(size(S));

for i=1:numel(small)
    
    for j=1:numel(Eind)
        Distance(j)=norm(TermPts(small(i),:)-E1(j,:));
    end
    minIdx=find(Distance==min(Distance));
    
    if Distance(minIdx)<4 && (S(Eind(minIdx))==1) && (V(Eind(minIdx))==0)
        
        for k=1:numel(idx)
            Dis(k)=norm(A(k,:)-E1(minIdx,:));
        end
        
        Component(idx(Dis<6))=1;
        
    end
    
    
    
    
end

Final=V+Component;

toc;



