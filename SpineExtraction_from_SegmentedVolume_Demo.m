
function SpineExtraction_from_SegmentedVolume_Demo(filepath,fSeg,fEnd,fSwc,fCenLine,branchLen,radius)





S = RAWfromMHD(fSeg,[],filepath); % the segmented Volume

% O = RAWfromMHD(fOrig,[],filepath); % the Original Volume

E = RAWfromMHD(fEnd,[],filepath); % the End points

C = RAWfromMHD(fCenLine,[],filepath); % The centerline

CL=importdata([filepath,filesep, fSwc]);% the SWC file containing the information related to the centerline

%C=CL(:,3:5);
% PathPts=CL(:,3:5); %Centerline points (x y z coordinates)
BranchPts=CL(CL(:,2)==5,3:5); %Branching points (x y z coordinates)
TermPts=CL(CL(:,2)==6,3:5); %Terminal points (x y z coordinates)

% generating branching points and their immediate neighbours
limitLoop=1;
BrNbd=zeros(size(S));
for bpts =1:size(BranchPts,1)
    
    if(min(BranchPts(bpts,:))>1 && BranchPts(bpts,1)~=size(S,1))...
            &&(BranchPts(bpts,2)~=size(S,2)) && (BranchPts(bpts,3)~=size(S,3))
        
        
        BrNbd(BranchPts(bpts,1)-limitLoop:BranchPts(bpts,1)+limitLoop,BranchPts(bpts,2)...
            -limitLoop:BranchPts(bpts,2)+limitLoop,BranchPts(bpts,3)-limitLoop:BranchPts(bpts,3)+limitLoop)=1;
    end
    
    
end

PathNbd=C-uint8(BrNbd);
%PathNbd(PathNbd<0)=0;

DD = bwconncomp(PathNbd);

TermIdx=sub2ind(size(S),TermPts(:,1),TermPts(:,2),TermPts(:,3));


Test=zeros(size(S));



for k=1:DD.NumObjects
    
    test= ismember(TermIdx,DD.PixelIdxList{k});
    %p(k)=sum(test);
    %q(k)=numel(DD.PixelIdxList{k});
    
    if sum(test)==1 && numel(DD.PixelIdxList{k}) <=branchLen
        
        Test(DD.PixelIdxList{k})=1;
        
    end
    
end


C=C-uint8(Test); % centerline without small branches

r=radius; % the radius in which we look for the spines around the detected end points


idx= find(S==1);% the indices in the segmented file having value 1

[x, y, z]= ind2sub(size(S),idx);% convert them to (x,y,z)-coordinates

A=[x y z];

D=zeros(1,numel(idx));

indE=find(E==1);


part=200;

V=zeros(size(S));
V1=zeros(size(S));
W=zeros(size(S));
radius1 = zeros(1,numel(indE));
a=zeros(1,part);

for t=1:numel(indE)
    
    [c, d, e]=ind2sub(size(E),indE(t));
    pt=[c d e];
    
    
    for i=1:numel(idx)
        D(i)=norm(pt-A(i,:));
    end
    
    intersection= D<=r;
    
    if numel(find(C(idx(intersection))==1))>0
        
        
        
        for k=1:part
            ids= D<=k*r/part;
            a(k)= numel(find(C(idx(ids))==1));
        end
        
        id=find(a>0); % first time the centerline is intersected
        
        %jd=find(a>=2); % first time two or more voxels of the centerline are intersected
        
        
        if numel(id)>0
            
            ra=id(1)*r/part; % radius toching the centerline
            
            if ra >1
                ids1=find(D<=ra);
                
                b= C(idx(ids1))==1;
                
                abc=idx(ids1(b));
                
                [c1, d1, e1]=ind2sub(size(C),abc(1));
                
                
                logic=logical([CL(:,3)==c1, CL(:,4)==d1, CL(:,5)==e1])';
                
                f=find(sum(logic,1)==3);
                
                %rad=CL(f,6);
                
                %rad=round(CL(f,6)*10)/10;
                
                % rad= floor(CL(f,6));
                
                %rad=CL(f,6)*0.75;
                
                radius1(t)=CL(f,6);
                
                ids2=find(D<=(ra-radius1(t)));
                
                V=zeros(size(S));
                V1(idx(ids2))=1;
                V(idx(ids2))=1;
                V=uint8(V);
                
                EE=bwconncomp(V);
                
                for m=1:EE.NumObjects
                 test= ismember(indE(t), EE.PixelIdxList{m});
                        p(k)=sum(test);
                         q(k)=numel(EE.PixelIdxList{m});
    
                         if sum(test)==1 %&& numel(DD.PixelIdxList{m}) <=20
        
                         W(EE.PixelIdxList{m})=1;
        
                          end
    
                end
                
                
                
                
                
            end
        end
        
    end
end
%WriteRAWandMHD(uint8(V),'Component_Neck_New',pwd)

V=uint8(V);
W=uint8(W);
nnz(V)
nnz(W)
nnz(V1)
WriteRAWandMHD(uint8(W),strcat(fSeg,'_ExtractedSpines'),filepath)


% 
% 
% BranchLen=zeros(1,numel(TermIdx));
% for i=1:numel(TermIdx)
%     
%     for j=1:DD.NumObjects
%         
%         if numel(find(DD.PixelIdxList{j}==TermIdx(i)))>0;
%             BranchLen(i)=numel(DD.PixelIdxList{j});
%         end
%         
%         
%     end
%     
%     
%     
% end
% 
% 
% small=find(0 < BranchLen &  BranchLen<12);
% 
% Eind=find(E==1);
% [x2, y2, z2]=ind2sub(size(S),Eind);
% E1=[x2 y2 z2];
% 
% %A the coordinates of the segemented volume
% 
% Dis=zeros(1,numel(idx));
% Distance=zeros(1,numel(Eind));
% Component=zeros(size(S));
% 
% for i=1:numel(small)
%     
%     for j=1:numel(Eind)
%         Distance(j)=norm(TermPts(small(i),:)-E1(j,:));
%     end
%     
%     minIdx=find(Distance==min(Distance));
%     
%     if (0< Distance(minIdx)<6) && (S(Eind(minIdx))==1) && (V(Eind(minIdx))==0)
%         
%         for k=1:numel(idx)
%             Dis(k)=norm(A(k,:)-E1(minIdx,:));
%         end
%         
%         ids3=find(D<=6);
%         Component(idx(ids3))=1;
%         
%     end
%     
%     
%     
%     
% end

% Final=V+Component;

end



