
function centerLineFile=CenterLinefromSWCtoRAWnMHD_demo(filepath,fileseg)
% filepath= 'C:\Users\pankaj singh\Desktop\Read\MatlabExp\TaraKeck\Stack1\Common\Log_Common\SpineExtraction\Time_2\';
% fileseg= 'Log_Common_2_Edited';
V = RAWfromMHD(fileseg,[],filepath);

%swcfile=strcat(filepath,fileseg,'_CL.swc');
swcfile = [filepath,filesep, fileseg,'_CL_Branch.swc'];


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

centerLineFile=b;

end


