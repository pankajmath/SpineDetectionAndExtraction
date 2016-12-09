

per1=[perms([1 0 0]); perms([1 1 0]); perms([-1 0 0]); perms([-1 -1 0])];
per2=[perms([-1 1 0]); perms([-1 1 1]); perms([-1 -1 1])];
per=[per1; per2; [1 1 1]; [0 0 0]; [-1 -1 -1]];
f=unique(per,'rows');

index= find(C==1);

sz=size(C);

count=zeros(1,numel(index));

for ii=1:numel(index)
    
   [x,y,z]=ind2sub(sz, index(ii));
   
   pts=[x, y, z];
   
   rpts=repmat(pts,27,1);
   
   nbd=rpts + f;
   
   if (max(nbd(:,1))>51 ||max(nbd(:,2))>151 ||max(nbd(:,3))>38 )
       
       count(ii)=0;
   else
   
   nb_idx=sub2ind(size(C),nbd(:,1),nbd(:,2),nbd(:,3));
   
    count(ii)=nnz(C(nb_idx));
   end
    
end