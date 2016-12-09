function detectedEndpts=endPointsDetectionDemo(fpath,fRaw,fSeg,sigma)
%function that allows you to detect the end points from a Binary volume
%the segmentation and input volume should be in the same folder
%Input paramters
%fpath: the relative path to the folder which contain the input and
%segmentation volumes
%fRaw: file name of the input volume
%fSeg: file name of the segmented volume
%sigma: the approximate radius of the tubular structure (TS)


%fpath='C:\Users\pankaj singh\Desktop\Read\MatlabExp\TaraKeck\Stack1\Common\Log_Common\SpineExtraction\Time_2\';
%fRaw='Log_Common_2';
%fSeg='Log_Common_2_Edited';
%sigma=2;
close all;
%polinomial degree for the hdaf function
n=60;
normalization_constant = 0.1674; 

%parameters for the fast marching 
%the front propagation stops a this point
end_points      = [ -1;-1;-1 ]; 
%maximum number of iterations
nb_iter_max = 5000000;


%computing the fact value for the low pass filter 
LP = normalization_constant * sqrt(2.0*n+1)/(sigma*pi); 
    
%computing the Low Pass of the input volume
if (~exist(fullfile(fpath,strcat(fRaw,'_LP_',num2string(LP),'_F.mhd')),'file')) 
    compute_LP(fpath,fRaw,LP)
end

%reading the binary volume
B = RAWfromMHD(fSeg,[],fpath);

%Original Binary volume 
B_seg = B>0;

%reading the low pass volume
V_LP = RAWfromMHD(strcat(fRaw,'_LP_',num2string(LP),'_F'),[],fpath);

%Just including large TS which may not be capture from the segmentation
%We just use a threshold in the LP volume to include large TS
B = logical(B) | V_LP>0.5*max(V_LP(:));

%selecting seed points in each connected component
start_points=detectSeedPoints(B);

%computing fast marching only for voxels in the segmented volume
V_fastMarching = perform_front_propagation_AS_FLOAT_BINARYCOUNT_3d(single(B),...
                 single(start_points-1),single(end_points-1),nb_iter_max,B);

%the values outside the binary volume should be set to zero             
V_fastMarching(~B) = 0;
             
%Creating a mask to obtain the maximum in each voxel
 msk = true(9,9,9);

%we need to set the middle voxel to false
 msk(5,5,5) = false;
             
%calculating the maximum for each voxel in the 5x5x5 neighboorhood 
s_dil = imdilate(V_fastMarching,msk);

%check which voxels are local maximum
M = V_fastMarching>s_dil;

%Just local maximum inside the volume
M = M & B_seg;

%fileName to be written
detectedEndpts=strcat(fSeg,'_detectedEndPoints');
%write the detected endpoints
WriteRAWandMHD(M,detectedEndpts,fpath);


% figure;imshow(max(M,[],3),[]);
% figure;imshow(max(B,[],3),[]);
end

function start_points=detectSeedPoints(B)
%fast marching uses 6 connected components to do propagation. Hence, I
%detected seed points for each connected connected using a six neighboor
conComp = bwconncomp(B,6);

%set current set of seed points to empty
start_points = [];

%detecting end point for each connected component
for i=1:conComp.NumObjects
    %getting the coordinates for the first point in a connected component
    [x y z] = ind2sub(size(B),conComp.PixelIdxList{i}(1));
    
    %adding the point to the set of seed points
    start_points = [start_points [x; y; z]];
end

%note that the set of end points should be given in a 3xn array where n is
%the number of starting points
end



