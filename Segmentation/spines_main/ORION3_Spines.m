function ID_segmentation = ORION3_Spines(file_path,file_name,p)
%function that allows to segment spines from the input volume by
%pre-processing the 3D image stack using the second eigenvalue of the
%Hessian Matrix, then ORION3 is used to segment dendrites

%saving the output where the 3D image stack is located
p.folder_output = file_path;

%ID for the output
p.file_ID_segmentation = 'SPINES';

%folder to save the processing steps of the spines segmentation
folder_spines_processing = fullfile(file_path, 'SPINE_processing');


%Moving everything to the folder SPINES if the folder has not been created
if (~exist(fullfile(folder_spines_processing,[file_name '.RAW']),'file'))
    %make the directory to save the processing steps to segment spines
    mkdir(folder_spines_processing);
    
    %reading the 3D image stack
    V = RAWfromMHD(file_name,[],file_path);
       
    %writing the 3D image stack with isotropic spacing
    WriteRAWandMHD(V,file_name,folder_spines_processing);
    
end

%compute the eigenvalues for the given scale
computeEigenvalues(fullfile(folder_spines_processing,file_name),p.sigma_pre);

%folder where all the processing steps are going to be cerried
[eigenvalues_path file_output] =Read_CreateFolderSecondEigenvalueHessian(folder_spines_processing,file_name,p.sigma_pre);

%running the segmentation algorithm
ID_segmentation = ORION3_Dendrites(eigenvalues_path,file_output,p);

%just in case the user wants to remove the directory
if p.delete_files 
    rmdir(fullfile(file_path,'SPINE_processing'),'s');
end

end