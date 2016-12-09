

tic;

%filepath='Y:\Documents\Spine\Common\Log_Common\SmallPortion\';
%filepath= 'C:\Users\pankaj singh\Desktop\Read\MatlabExp\TaraKeck\Stack1\Common\Log_Common\';

%filepath='C:\Users\pankaj\Desktop\Presentation\';

filepath='Y:\Documents\Spine\Common\Log_Common\SmallPortion\';

fOrig='Test_Log_Common_1_Partial_OrgVol';

fSeg='Test_Log_Common_1_Partial';

fEnd='Test_Log_Common_1_Partial_EndPoints';

fSwc='Test_Log_Common_1_Partial_CL_Branch.swc';

%fCenLine='Test_Log_Common_1_CL_f4_whole';
fCenLine='Test_Log_Common_1_Partial_CenterLine';


% fOrig='Log_Common_1';

% fSeg='Second_Sub_Volume_Partial';
% 
% fEnd='Second_Sub_Volume_Partial_Endpoints';
% 
% fSwc='Second_Sub_Volume_Partial_CL_Branch.swc';
% 
% %fCenLine='Test_Log_Common_1_CL_f4_whole';
% fCenLine='Second_Sub_Volume_Partial_CenterLine1';





% fOrig='Log_Common_1';
% 
% fSeg='Log_Common_1_Edited';
% 
% fEnd='Log_Common_1_detectedEndPoints';
% 
% fSwc='Log_Common_1_Edited_CL_Branch.swc';
% 
% %fCenLine='Test_Log_Common_1_CL_f4_whole';
% fCenLine='Log_Common_1_Edited_CenterLine';

S = RAWfromMHD(fSeg,[],filepath); % the segmented Volume

% O = RAWfromMHD(fOrig,[],filepath); % the Original Volume

E = RAWfromMHD(fEnd,[],filepath); % the End points

C = RAWfromMHD(fCenLine,[],filepath); % The centerline

CL=importdata(fSwc);% the SWC file containing the information related to the centerline

%C=CL(:,3:5);

%C=C-uint8(Test);

r=12; % the radius in which we look for the spines around the detected end points


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
        
        %a=zeros(1,part);
        
        for i=1:part
            ids= D<=i*r/part;
            a(i)= numel(find(C(idx(ids))==1));
        end
        
        id=find(a>0); % first time the centerline is intersected
        
        %jd=find(a>=2); % first time two or more voxels of the centerline are intersected
        
        i=id(1)*r/part; % radius toching the centerline
        
        if i >1
            ids1=find(D<=i);
            
            b= C(idx(ids1))==1;
            
            abc=idx(ids1(b));
                        
            [c1, d1, e1]=ind2sub(size(C),abc(1));
            
%             Cpts=[c1 d1 e1];
%             
%             if size(Cpts,1)>1
%                 
%                 DistBetPts=zeros(1,size(Cpts,1));
%                 
%                 TestVol=zeros(size(S));
%                 
%                 TestVol(idx(ids1))=1;
%                 
%                 TT=bwconncomp(TestVol);
%                 
%                 NUMOBJ(t)=TT.NumObjects;
%                 
%                 if TT.NumObjects==1
%                 c2=Cpts(1,1);
%                 d2=Cpts(1,2);
%                 e2=Cpts(1,3);
%                 else
%                 
% %             for m=1:size(Cpts,1)
% %                 DistBetPts(m)=norm(pt-Cpts(m,:));
% %             end
% %             NearID=find(DistBetPts==min(DistBetPts));
% %             
% %                 
% %                 
% %                 if TT.NumObjects==1
% %                     c2=Cpts(NearID,1);
% %                     d2=Cpts(NearID,2);
% %                     e2=Cpts(NearID,3);
% %                 else
%                     for m1=1:TT.NumObjects
%                     Count(m1)=numel(find(TT.PixelIdxList{m1}==indE(t)));
%                     end
%                     Count=find(Count==1);
%                     NewVol=Zeros(size(S));
%                     NewVol(idx(TT.PixelIdxList{Count}))=1;
%                     for m=1:size(Cpts,1)
%                         
%                     if NewVol(abc(m))==1;
%                         NewID=m;
%                     end
%                     
%                     end
%                     c2=Cpts(NewID,1);
%                     d2=Cpts(NewID,2);
%                     e2=Cpts(NewID,3);
%                     
%                 end
%             
%             end
            
            logic=logical([CL(:,3)==c1, CL(:,4)==d1, CL(:,5)==e1])';
            
            f=find(sum(logic)==3);
            
            %rad=CL(f,6);
            
            %rad=round(CL(f,6)*10)/10;
            
           % rad= floor(CL(f,6));
            
            %rad=CL(f,6)*0.75;
            
            radius1(t)=CL(f,6)*0.75;
            
            ids2=find(D<=(i-radius1(t)));
            
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
    
    if(BranchPts(i,1)~=size(S,1)) &&(BranchPts(i,2)~=size(S,2)) && (BranchPts(i,3)~=size(S,3))
        
    
    BrNbd(BranchPts(i,1)-limitLoop:BranchPts(i,1)+limitLoop,BranchPts(i,2)...
        -limitLoop:BranchPts(i,2)+limitLoop,BranchPts(i,3)-limitLoop:BranchPts(i,3)+limitLoop)=1;
    end
    
    
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
[x2, y2, z2]=ind2sub(size(S),Eind);
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
    
    if (0< Distance(minIdx)<6) && (S(Eind(minIdx))==1) && (V(Eind(minIdx))==0)
        
        for k=1:numel(idx)
            Dis(k)=norm(A(k,:)-E1(minIdx,:));
        end
        
        ids3=find(D<=6);
        Component(idx(ids3))=1;
        
    end
    
    
    
    
end

Final=V+Component;

toc;



