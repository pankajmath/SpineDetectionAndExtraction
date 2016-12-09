function [eigenvalues_path file_output]=Read_CreateFolderSecondEigenvalueHessian(fPath,fName,sigma)
%function that allows to read the second eigenvalue and create a new folder
%which allows to save the second eigenvalue
%for spine segmentation we use isotropic gaussians
spacing = [1 1 1];

%output name for the second eigenvalue
file_output = [fName '_E2_sigma_' num2string(sigma) ]; 

%path where the second eigenvalue will be saved
eigenvalues_path = fullfile(fPath,file_output);

%check if we already created the file. If it is true then we dont need to
%repeat the operation
if (~exist(fullfile(eigenvalues_path,[file_output '.RAW']),'file'))
    
    %make the directory to save the eigenvalue
    mkdir(eigenvalues_path);
    
    %reading the second eigenvalue
    V = RAWfromMHD([fName '.EigVal2.Sigma.' num2str(sigma)],[],fPath);

    %writing the second eigenvalue to the created folder
    WriteRAWandMHD(-V,file_output,eigenvalues_path,spacing);
end


end