filepath='C:\Users\pankaj singh\Desktop\Read\MatlabExp\TaraKeck\Stack1\Common\Log_Common\Check\';

E1 = RAWfromMHD('Log_Common_1_detectedEndPoints',[],filepath);

E2 = RAWfromMHD('Log_Common_2_detectedEndPoints',[],filepath);

thres=9;

n1=nnz(E1);

n2= nnz(E2);


ind1=find(E1==1);

ind2=find(E2==1);

Dist=zeros(1,n2);

F=zeros(1,n1);

[I, J, K] = ind2sub(size(E1),find(E1 == 1));

[L, M, N] = ind2sub(size(E2),find(E2 == 1));

for i=1: n1
    
    p= [I(i), J(i), K(i)];
    
    for j= 1: n2
        
        q=[L(j), M(j), N(j)];
        
        Dist(j)=norm( q- p);
        
        
    end
    min_dis=min(Dist);
    
    if min_dis < thres
        
        %a= find( Dist==min_dist );
        F(i)=1;
    end
    
    
end
nnz(F)
