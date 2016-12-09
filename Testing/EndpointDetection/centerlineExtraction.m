function centerlineExtraction(fpath,fRaw,fSeg,sigma)
close all;
%polinomial degree
n=60;

normalization_constant = 0.1674; 
%computing the fist value for the Laplacian this is the main parameter to
%detect the boundary of the tubular structure
LP = normalization_constant * sqrt(2.0*n+1)/(sigma*pi); 
    
%computing the LP of the input volume
if (~exist(fullfile(fpath,strcat(fRaw,'_LP_',num2string(LP),'_F.mhd')),'file')) 
    compute_LP(fpath,fRaw,LP)
end

%reading the binary volume
B = RAWfromMHD(fSeg,[],fpath);

%reading the LP 
V_LP = RAWfromMHD(strcat(fRaw,'_LP_',num2string(LP),'_F'),[],fpath);

%Just including largeTS which may be eliminated by using a low scale
B = B | V_LP>0.5*max(V_LP(:));

%computing distance transform of the input volume
DT = bwdist(~B);

%volume with maximum in the centerline
V_max = DT.*V_LP;
%V_max = DT;

%Calculate local maximum in a 5x5x5 neighboor
msk = true(3,3,3);
msk(2,2,2) = false;
s_dil = imdilate(V_max,msk);
M = V_max>=s_dil;
%Just local maximum inside the volume
M = M &B;

WriteRAWandMHD(M,'Seed_Points',fpath);
WriteRAWandMHD(DT,'DT_Binary',fpath);
WriteRAWandMHD(V_max,'DT_VLP_Binary',fpath);

figure;imshow(max(M,[],3),[]);
figure;imshow(max(B,[],3),[]);


end