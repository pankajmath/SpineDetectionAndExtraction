


Test=zeros(size(S));



for k=1:DD.NumObjects
    
    test= ismember(TermIdx,DD.PixelIdxList{k});
    p(k)=sum(test);
    q(k)=numel(DD.PixelIdxList{k});
    
    if sum(test)==1 && numel(DD.PixelIdxList{k}) <=20
        
        Test(DD.PixelIdxList{k})=1;
        
    end
    
end


%BranchIdx=sub2ind(size(S),BranchPts(:,1),BranchPts(:,2),BranchPts(:,3));
nnz(Test)

%BranchRadii=CL(CL(:,2)==5,6); % radii at the branching points

% for i=1:numel(idx)
%         F(i)=norm(BranchPts(1,:)-A(i,:));
% end
% 
%             V1=zeros(size(S));
%             ids3=find(F<= BranchRadii(1));
%             
%             %V=zeros(size(S));
%             V1(idx(ids3))=1;
% 

