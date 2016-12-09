fpath='C:\Users\pankaj singh\Desktop\Read\MatlabExp\TaraKeck\Stack1\Common\Log_Common\SmallPortion\Time2\'; 

fname='Log_Common_2';

fseg='Log_Common_2_Edited';

O1=RAWfromMHD(fname,[],fpath);

O2 = RAWfromMHD(fseg,[],fpath);

%  S=zeros(size(O1));
% for i=375:425
% for j=80:230
% for k=1:38
% S(i,j,k)=O1(i,j,k);
% end
% end
% end

 S1=zeros(51,151,38);
 S2=zeros(size(S1));
for i=1:51
for j=1:151
for k=1:38
S1(i,j,k)=O1(374+i,79+j,k);
S2(i,j,k)=O2(374+i,79+j,k);
end
end
end

name=strcat('Time_',num2str(2),'_Partial');
WriteRAWandMHD(uint16(S1),strcat(name,'_OrgVol'),fpath)
WriteRAWandMHD(uint8(S2),strcat(name,'_Seg'),fpath)

