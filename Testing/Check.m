Z= zeros(size(S));
n=278;
a=zeros(n);
voxthres=4;
maxlen=20;


for i=1:n
    for j=1:n
        
       %if (Length(i,j)>0 && (Length(i,j)==Sum_intensity(i,j)|| Length(i,j)==Sum_intensity(i,j)+2 ))
        if (Length(i,j)>0 && Length(i,j)< maxlen && (Length(i,j)<=Sum_intensity(i,j)+voxthres ))
           a(i,j)=1;
       end
    end
end

sim=find(a==1);
[icor,jcor]=ind2sub(size(a),sim);

ipoints=endpoints(icor);
jpoints=endpoints(jcor);

Z(ipoints)=1;

Z(jpoints)=1;
Z=uint8(Z);

% 
% for k=1: length(icor)
%     idx(k)= endpoints(icor