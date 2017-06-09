tic;
addDirAndSubDirHavingThisFunction() % adds current directory and subdirectories to path

filepath= [pwd, filesep, 'Data']; % assumes that the 3d image is in subdirectory 'Data'

filename='Test_Volume.tif'; %name of the .tif image
tif2raw=1; % if input image needs to be converted from .tif to .raw and .mhd
RawAndMHD = 'Test_Volume'; % name of the .raw and/or .mhd file, if already available
blobSize2Remove=100;

%some parameter setting
p.sigma_pre = 2.0;
p.sigma = 2.0;      
p.GUI = false;
p.delete_files = false;
p.bins=400;         % number of bins in the histogram calculation
p.threshold = .8; % threshold used in segmentation
%p.min_c  = 15^3;
%p = settingDefaultParameters(p,filepath);

branchLen=15; % centerline branches smaller than this length will not be
              %considered when extracting the spines
radius=18;     % the maximum radius of the sphere we 
               %consider from the centerline
numVoxSmallSpine =10; % the minimum number of voxels in a spine

if tif2raw
%% Converting tif to raw and mhd
RawAndMHD=tiff_To_RawAndMHD(filepath,filename);
end
%% Segmentation of raw 3D image; Removing small blobs
spine_FileName=runSegmentationSpinesDemo(filepath,RawAndMHD, p);

segmentedImage=RAWfromMHD(spine_FileName,[],filepath);

newSegmentedImage=remove_small_conComp3D(segmentedImage,blobSize2Remove);
if writetiff
    
    for K=1:length(newSegmentedImage(1,1,:))
        imwrite(logical(newSegmentedImage(:,:,K)'),strcat(spine_FileName,'_Edited_', num2str(blobSize2Remove),'.tif'),'WriteMode','append', 'Compression', 'none');
    end
end


WriteRAWandMHD(newSegmentedImage,strcat(spine_FileName,'_Edited_', num2str(blobSize2Remove)),filepath);

editedSeg=strcat(spine_FileName,'_Edited_',num2str(blobSize2Remove));

%% Obtaining Centerline of the segmented image
traceScript_BranchinfoDemo(filepath,editedSeg);

centerLineFile=CenterLinefromSWCtoRAWnMHD_demo(filepath,editedSeg);

%% Detecting EndPoints(terminal points)
sigma=2;
detectedEndpts=endPointsDetectionDemo(filepath,RawAndMHD,editedSeg,sigma);


%% Spine Extraction
SpineExtraction_from_SegmentedVolume_Demo(filepath,editedSeg,detectedEndpts,...
                                            strcat(editedSeg,'_CL_Branch.swc'),...
                                            centerLineFile,branchLen,radius);
                                        
nameExtracted = strcat(editedSeg,'_ExtractedSpines_','bl_', num2str(branchLen), 'rad_', num2str(radius));               
                                        
Spines=RAWfromMHD(nameExtracted,[],filepath);
cc=bwconncomp(Spines);
sprintf('The total number of spines is %d.', cc.NumObjects)

%% Removing small spines (less than 10 voxels in volume)
editedSpines=remove_small_conComp3D(Spines,numVoxSmallSpine);
dd=bwconncomp(editedSpines);
sprintf('The number of spines (after removing small ones) is %d.', dd.NumObjects)
nameExtractedEdited = strcat(nameExtracted, 'Edited_','bl_', num2str(branchLen), 'rad_', num2str(radius),'minVox_', num2str(numVoxSmallSpine));
WriteRAWandMHD(editedSpines, nameExtractedEdited, filepath)

toc;
                                        
