function computeEigenvalues(input,sigma)
%function that allows to compute the eigenvalues according to the Sato's
%sorting.

%Depending on the computer. We have to run the 32 or 64bits executable file
C = computer;
if strcmp('PCWIN64',C)
    %Run the 64 bits version
    exeName = 'ComputeSingleEigenValue.Win64.exe';
else
    %run the 32 bits version
   exeName = 'ComputeSingleEigenValue.Win.exe';               
end

%We need the path of the current file. To know th path to the executable
%file to calculate the eigenvalue
currentFilePath = which(mfilename('fullpath'));
[exePath,NAME,EXT] = fileparts(currentFilePath);

%In this path the folder Executable contains the executables file to
%calculate the eigenvalues
exePath = fullfile(exePath,'Executable');

for i = 1:length(sigma)
    if ~exist([input '.EigVal1.Sigma.' num2str(sigma(i)) '.mhd'])
        %compute eigenvalues only if they has not been calculated
        %fprintf('Computing eigenvalues with sigma = %f ...', sigma );
         [s, w] = dos(['"' fullfile(exePath,exeName)  '" ' '"' input  '" ' num2str(sigma(i)) ]);
        %fprintf('done ...\n');
    end
end

end