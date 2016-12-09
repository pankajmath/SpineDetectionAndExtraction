tic;
addDirAndSubDirHavingThisFunction()

filepath= [pwd, filesep, 'Data'];

filename='Test_Volume.tif'; %filename is the .tif or .raw file in the directory

RawAndMHD = 'Test_Volume';
blobSize2Remove=100;

abc=0;
writetiff=0;
if abc
%% Converting tif to raw and mhd
RawAndMHD=tiff_To_RawAndMHD(filepath,filename);
end
%% Segmentation of raw 3D image; Removing small blobs
spine_FileName=runSegmentationSpinesDemo(filepath,RawAndMHD);

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
branchLen=15;
radius=15;
SpineExtraction_from_SegmentedVolume_Demo(filepath,editedSeg,detectedEndpts,...
                                            strcat(editedSeg,'_CL_Branch.swc'),...
                                            centerLineFile,branchLen,radius);
                                        
Spines=RAWfromMHD(strcat(editedSeg,'_ExtractedSpines'),[],filepath);
cc=bwconncomp(Spines);
numberofSpines=cc.NumObjects
if writetiff
    for K=1:length(Spines(1,1,:))
        imwrite(Spines(:,:,K)',strcat(editedSeg,'_ExtractedSpines','.tif'),'WriteMode','append', 'Compression', 'none')
    end
    
end

%% Removing small spines (less than 10 voxels in volume)
editedSpines=remove_small_conComp3D(Spines,10);
dd=bwconncomp(editedSpines);
numberofSpines=dd.NumObjects
spineCords = zeros(numberofSpines, 3);
for i = 1 : dd.NumObjects
[alpha, beta, gamma] =ind2sub(size(editedSpines), dd.PixelIdxList{i});
spineCords(i,:) = round([mean(alpha), mean(beta), mean(gamma)]);
end
% csvwrite([filepath, filesep, 'Spine_Coordinates.csv'], spineCords);
WriteRAWandMHD(editedSpines, 'EditedSpineExtraction', filepath)








% Centroid = zeros(size(editedSpines));
% for j = 1: numberofSpines
% Centroid(spineCords(j,1), spineCords(j,2), spineCords(j,3)) =1;
% end


                        
                                        

toc;
                                        