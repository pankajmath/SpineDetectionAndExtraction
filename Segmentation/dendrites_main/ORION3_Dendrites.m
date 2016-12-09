function ID_segmentation = ORION3_Dendrites(file_path,file_name,p)
%segmentation process which computes the distribution of the eigenvalues of
%the Hessian matrix and assign a cost function to eliminate background voxels. The
%segmentation for foreground voxels gives values larger than 0.5.
% Parameters:
% file_path <- path where the volume is saved
% file_name <- Input volume
% p.sigma <- scale for the gaussian kernel to be utilized in the calculation
% of the eigenvalues

%optional parameters
% p.min_c <- minimum value of voxels for a connected component to be taken as noise.
% p.threshold <- threshold value to be used for segmentation --- default
% 0.5
%p.bins <- number of bins to compute the histogram --- default 500

%setting the default parameters of the algorithm
p = settingDefaultParameters(p,file_path);

%open a wait bar
if p.GUI
    s_progress = waitbar(0,'Segmentation progress...');
else
    s_progress = [];
end



%MAIN FUNCTION TO OBTAIN THE TRAINING SET OF BACKGROUND VOXELS
%STEP 1
%reading background samples using the laplacian 
[I SPACING Lap]= readNegativeSamples(file_path,file_name,p.sigma);
increaseWaitBar(s_progress,p,0.25)

%Getting the appropiate sigma value (it depends on the SPACING of the
%volume). Make sure that we have the correct spacing.
%fprintf('Spacing = [%f %f %f]\n', SPACING(1),SPACING(2),SPACING(3));

%Using X spacing to compute the appropiate sigma --- assuming X-Y same
%spacing
p.sigma = SPACING(1)*p.sigma;
%------------------------------------------------------------------

%MAIN FUNCTION TO OBTAIN THE SEGMENTATION
%Compute the feature vector
%STEP 2
features= computeFeatures(file_path,file_name,p.sigma);
increaseWaitBar(s_progress,p,0.5)

%getting feature vectors distribution for negative samples
%STEP 3
p = compute2DHistogram(features(I,:),p);
increaseWaitBar(s_progress,p,0.75)

%allocate memory to save the response to the cost function
R=zeros(size(I),'single');

%Get cost function for features with unkown label (voxels with positive value to the Laplacian)
%STEP 4-5
R(~I)= getResponseToHistogram(p,features(~I,:));

%segmenting and removing small components
Segmentation = remove_small_conComp3D(R>p.threshold, p.min_c);
increaseWaitBar(s_progress,p,1.0)

%save the segmentation
ID_segmentation = [file_name '_Segmentation_' p.file_ID_segmentation '_s_' num2string(p.sigma) '_t_' num2string(p.threshold) '_b_' num2string(p.bins)];
WriteRAWandMHD(Segmentation,ID_segmentation,p.folder_output,SPACING);

%------------------------------------------------------------------


%just to show input volume
%getting screen size
scrsz = get(0,'ScreenSize');

%depending in the size of the screen set the position of the figure
edge =-2;
pos1 = [edge scrsz(4)/4 scrsz(3)/3 scrsz(4)/2];
pos2 = [scrsz(3)/3 pos1(2) pos1(3) pos1(4)];
pos3 = [scrsz(3)*(2/3) pos1(2) pos1(3) pos1(4)];

V = RAWfromMHD(file_name,[],file_path);
figure('Position',pos1);
imshow(max(V,[],3)',[],'InitialMagnification','fit');colormap('jet'); colorbar; title('3D image stack Maximum Intensity Projection (MIP)','fontsize',15)

%show the cost function for the foreground
figure('Position',pos2);
imshow(max(R,[],3)',[],'InitialMagnification','fit');colormap('jet'); colorbar; title('Enhanced image MIP','fontsize',15)

%show the segmentation
figure('Position',pos3);
imshow(max(Segmentation,[],3)',[],'InitialMagnification','fit');colorbar; title('Segmentation MIP','fontsize',15)

%removing files in case the user does not want to keep the processing
%steps
if p.delete_files
    %deleting laplacian responses
    delete_RAW(file_path,[file_name '_LP_Lap_' num2string(Lap(1)) '_F']);
    delete_RAW(file_path,[file_name '_LP_Lap_' num2string(Lap(2)) '_F']);
    %deleting eigenvalues
    delete_RAW(file_path,[file_name '.EigVal1.Sigma.' num2str(p.sigma)]);
    delete_RAW(file_path,[file_name '.EigVal2.Sigma.' num2str(p.sigma)]);
    delete_RAW(file_path,[file_name '.EigVal3.Sigma.' num2str(p.sigma)]);
else
    %%saving the final response
    WriteRAWandMHD(R,[file_name '_Response_s' num2string(p.sigma)],file_path,SPACING);
end

    
end

