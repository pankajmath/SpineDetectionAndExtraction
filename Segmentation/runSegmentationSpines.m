function runSegmentationSpines
%this function allows to obtain the segmentation for tubular structures. Nota that, we are using the ordering of the eigenvalues proposed by SATO. If we want to use FRANGI's sorting, we have to modify the file computeFeatures.m


%The parameters for segmentation are the following
% fpath <- string with the path to the folder of the input volume. Example fpath = 'C:\DATA'
% fname <- a cell including the names of the volumes to segment. Example fname = {'Vol_1' 'Vol_2'}
%NOTE: the path to the input volume is ---- 
% ---- fpath \ fName{1} \ fName{1}.raw
% ---- fpath \ fName{2} \ fName{2}.raw
% ---- fpath \ fName{3} \ fName{3}.raw and so on...

%The parameters for the segmentation are
% p.sigma <- the radius for segmentation

%We also have the optional parameters
% p.bins <- Just in case that we want to increase or decrease the
% sensitivity of the segmentation by deafult set to 500
% p.min_c <-  minimum value of voxels for a connected component to be taken
% as noise by default set to  round((4*p.sigma)^3);
% p.threshold <- threshold value to be used for segmentation by default 0.5

close all
clc

%fpath = 'C:\Users\pankaj singh\Desktop\Read\MatlabExp\Stack1';
fpath='C:\Users\pankaj\Documents\for_pankaj\SpineModel\LapExp_2pt5_times_notsameInt';
fname = {'Experiment_Create3D_Mesh_DenSpine_0_5_0_3_0_7_2_5' };
sigma_pre = 0.0;
sigma = 0.0;
p.GUI = true;
p.delete_files = false;
%p.bins =1000;
p.bins =500;
p.threshold = 0.8;

%p.min_c  = 15^3;
p.min_c=10;

total_time = 0;
for i=1:length(fname)
    for s=1:length(sigma)
        tic;
        p.sigma = sigma(s);
        p.sigma_pre = sigma_pre;
        %running spines segmentation
        ORION3_Spines(fpath,fname{i},p);
        t = toc;
        computeElapsedTime(t,'Spines ');
        total_time = total_time + t;
        computeElapsedTime(total_time,'Spines ');
    end
end
end

