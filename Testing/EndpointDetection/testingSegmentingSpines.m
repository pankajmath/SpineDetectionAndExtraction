%test segmentation of spines
clear all;
clc;
fpath = 'E:\RECONSTRUCTIONS\Spines\ZSeries-10052010-1810-386_Cycle001_CurrentSettings_Ch1_000001_0_180\sub_ZSeries\ZSeriessub2_E2_s_1_5';
fRaw  = 'ZSeriessub2_E2_s_1_5';
fSeg = 'ZSeriessub2_E2_s_1_5_Segmentation_s_1_5_t_0_75_b_500';
fEndPoint = 'ZSeriessub2_E2_s_1_5_detectedEndPoints';

%reading the volumes
V = RAWfromMHD(fRaw,[],fpath);
B = RAWfromMHD(fSeg,[],fpath); B = B>0;
EndPoints = RAWfromMHD(fEndPoint,[],fpath);
B = bwdist(B);
B = B<=2;

%detecting the coordinates of end points
I = find(EndPoints);
[x y z] = ind2sub(size(B),I);

%parameters fast marching
%the front propagation stops a this point
end_points      = [ -1;-1;-1 ]; 
%maximum number of iterations
nb_iter_max = 5000000;

%giving high propagation to voxels with low intensity
min_c = min(V(:));
max_c = max(V(:));
V = (V-min_c)/(max_c - min_c);
V = 1-V;
V(B) = exp(V(B)); V(~B) = 0;

start_points = [x'; y'; z'];

%computing fast marching only for voxels in the segmented volume
V_fastMarching = perform_front_propagation_AS_FLOAT_BINARYCOUNT_3d(V,...
                 single(start_points-1),single(end_points-1),nb_iter_max,B);
             
I = V_fastMarching > exp(10); V_fastMarching(I) = 0;          
             
%write the fast marching 
WriteRAWandMHD(V_fastMarching,strcat(fRaw,'_FM_Spines'),fpath);             
WriteRAWandMHD(V,strcat(fRaw,'_Speed'),fpath);      