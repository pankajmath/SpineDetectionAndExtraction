tic;

filepath= 'C:\Users\pankaj singh\Desktop\Read\MatlabExp\TaraKeck\Stack1\Common\Log_Common\';
fileseg= 'Log_Common_1_E2_sigma_2_Segmentation_SPINES_s_2_t_0_8_b_500';
V = RAWfromMHD(fileseg,[],filepath);

%swcfile=strcat(filepath,fileseg,'_CL.swc');
swcfile=strcat(filepath,fileseg,'_CL.swc');


% fpath='C:\Users\pankaj singh\Desktop\Read\MatlabExp\TaraKeck\Stack1\Common\Log_Common\';
% fSeg='Test_Log_Common_1_Partial';
% 
% fCenterLine=strcat(fpath,fSeg,'_CL.swc');

S=zeros(size(V));

CL=importdata(swcfile);


C=[CL(:,3) CL(:,4) CL(:,5)];

[a,~]=size(C);

for i=1:a
S(C(i,1),C(i,2),C(i,3))=1;
end

S=uint8(S);

b=strcat(fileseg,'_CenterLine');

WriteRAWandMHD(S,b,filepath)



toc;