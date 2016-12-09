clear all
%function that enhances the image from the eigenvalues
file_path = 'E:\RECONSTRUCTIONS\Diadem\DataSet5\Olfactory_Fibers_OP_9';
file_name = 'Olfactory_Fibers_OP_9';
sigma = 1.5;

%Depending on the computer. We have to run the 32 or 64bits executable file
C = computer;
if strcmp('PCWIN64',C)
    %Run the 64 bits version
    exeName = 'ComputeEigenValueNormalizedScale_win64.exe';
else
    %run the 32 bits version
   exeName = 'ComputeSingleEigenValue.Win.exe';               
end

%compute the eigenvalues for the given scale
computeEigenvalues(exeName,fullfile(file_path,file_name),sigma);

[V1 V2 V3]=readEigenvalues(file_name, file_path, sigma);

V1 = V2.*V3;

V = RAWfromMHD(file_name,[],file_path);

WriteRAWandMHD(V1,[file_name '_Sato'],file_path);