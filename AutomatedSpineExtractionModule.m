tic;
addDirAndSubDirHavingThisFunction()

filepath= [pwd, filesep, 'Data'];
%filepath = 'C:\Users\pankaj\Desktop\SpineDetExt\Data';

filename='Test_Volume.tif'; %filename is the .tif or .raw file in the directory

RawAndMHD = 'Test_Volume';
blobSize2Remove=100;



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


abc=0; % if input image needs to be converted from .tif needs to .raw and .mhd
writetiff=0; % if output files need to be written in .tif format
if abc
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

if writetiff
    for K=1:length(Spines(1,1,:))
        imwrite(Spines(:,:,K)',strcat(editedSeg,'_ExtractedSpines','.tif'),'WriteMode','append', 'Compression', 'none')
    end
    
end

%% Removing small spines (less than 10 voxels in volume)
editedSpines=remove_small_conComp3D(Spines,numVoxSmallSpine);
dd=bwconncomp(editedSpines);
sprintf('The number of spines (after removing small ones) is %d.', dd.NumObjects)
nameExtractedEdited = strcat(nameExtracted, 'Edited_','bl_', num2str(branchLen), 'rad_', num2str(radius),'minVox_', num2str(numVoxSmallSpine));
WriteRAWandMHD(editedSpines, nameExtractedEdited, filepath)


% spineCords = zeros(numberofSpines, 3);
% for i = 1 : dd.NumObjects
% [alpha, beta, gamma] =ind2sub(size(editedSpines), dd.PixelIdxList{i});
% spineCords(i,:) = round([mean(alpha), mean(beta), mean(gamma)]);
% end
% csvwrite([filepath, filesep, 'Spine_Coordinates.csv'], spineCords);


% Centroid = zeros(size(editedSpines));
% for j = 1: numberofSpines
% Centroid(spineCords(j,1), spineCords(j,2), spineCords(j,3)) =1;
% end


                        
                                        

toc;
                                        