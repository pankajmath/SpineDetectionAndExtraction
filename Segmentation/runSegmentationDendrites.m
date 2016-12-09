function runSegmentationDendrites
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

%Sample
%  fname = {'NPF013' 'NPF015' 'NPF023' 'NPF024' 'NPF025' 'NPF026' 'NPF027' 'NPF037' ...
%      'NPF039' 'NPF048' 'NPF049' 'NPF050' 'NPF057' 'NPF058' 'NPF062' 'NPF067' ...
%      'NPF068' 'NPF069' 'NPF070' 'NPF071' 'NPF080' 'NPF086' 'NPF098' 'NPF099' ...
%      'NPF119' 'NPF139' 'NPF140' 'NPF143' 'NPF144' 'NPF150'};
% % fname = {'NPF086' 'NPF098' 'NPF099' 'NPF119' 'NPF139' 'NPF140' 'NPF143' 'NPF144' 'NPF150'};
% % fname = {'NPF039'};
% % fname = {'NPF067'};
% % fname = {'NPF068'};
% % fname = {'NPF069'};
% % fname = {'NPF070'};
% % fname = {'NPF071'};
% % fname = {'NPF080'};
% % fname = {'NPF086'};
% % fname = {'NPF098'};
% % fname = {'NPF099'};
% % fname = {'NPF119'};
%  fname = {'NPF027'};
%  fname = {'NPF023'};
%  fname = {'NPF048'};
%  fname = {'NPF049'};
%  fname = {'NPF070'};
%  fname = {'NPF098'};
%  fname = {'NPF119'};
% 

fpath = 'C:\Users\pankaj\Desktop\data_ROI1';

fname = {'ROI_C1-01-27-15_217KO_T1_PV-488GAD67-568_CA1o_63X_St-81'};

% %fname = {'NPF099'};
sigma = 2;
% p.threshold =0.95;
% % p.images = true;
% p.threshold  = 0.75;
 p.bins = 1000;
 
 p.showImages=true;


% fname = {'NPF057_E2_s_3'};
% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet4\NPF057';
% fname = {'NPF099'};
% p.sigma =3.0;
% p.threshold = 0.75;
% p.images = true;

% fname = {'cow5902_E2_s_2'};
% fpath = 'C:\DATA\Yifeng\cow5902\';
% %fname = {'NPF099'};
% p.sigma =2.0;
% p.images = true;


%  fname = {'Olfactory_Fibers_OP_1' 'Olfactory_Fibers_OP_2' 'Olfactory_Fibers_OP_3' 'Olfactory_Fibers_OP_4' ...
%  'Olfactory_Fibers_OP_5' 'Olfactory_Fibers_OP_6' 'Olfactory_Fibers_OP_7' 'Olfactory_Fibers_OP_8' 'Olfactory_Fibers_OP_9'};
% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet5';
% fname = {'Olfactory_Fibers_OP_3'};
% sigma = 2;
% % p.threshold = 0.95;
%  p.images = true;
%  p.bins = 100;
% p.bins = 1000;
% p.threshold = 0.95;
% p.bins=500;
% p.threshold = 0.85;
% p.images = true;
%p.min_c = 200;

% fpath = 'E:\RECONSTRUCTIONS\Multiphoton\V20050623';
% fname = {'V20050623Ac'};
% p.sigma =  1.5;
% p.bins = 125;
% % p.bins = 50;
% % p.threshold = 0.75;
% p.images = true;
% p.bins = 50;

% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet3';
% % fname = {'Neocortical_Layer_6_Axons_Stack_01' 'Neocortical_Layer_6_Axons_Stack_02' 'Neocortical_Layer_6_Axons_Stack_03' ...
% %     'Neocortical_Layer_6_Axons_Stack_04' 'Neocortical_Layer_6_Axons_Stack_05' 'Neocortical_Layer_6_Axons_Stack_06'};
% fname = {'Neocortical_Layer_6_Axons_Stack_03'};
% sigma =2.0;
% p.bins = 2000;
% % p.images = true;
% 
% fpath = 'C:\DATA\Fernanda\FerSol_1\';
% fname = {'FerSol_1_Sato'};
% p.sigma = 1.5;
% p.bins = 150;
% p.threshold = 0.6;
% p.bins = 500;

% fpath = 'C:\DATA\Fernanda\';
% fname = {'FerSol_1'};
% p.sigma = 1.5;
% p.threshold = 0.95;
% p.bins = 250;
% p.min_c = 4^3;
% % p.threshold = 0.9;
% %p.images = true;
% p.bins = 150;
%p.min_c = 15^3;

% fpath = 'C:\DATA\SyntheticData\Experiments\Cylinder\';
% fname = {'cylinder_r3'};
% p.sigma = 2.0;
% p.threshold = 0.9;
%p.images = true;
%p.min_c = 15^3;

% fpath = 'E:\RECONSTRUCTIONS\confocal\V053006A\';
% fname = {'V053006Ad'};
% p.sigma = 2.0;
% 
% fpath = 'C:\DATA\CTA\S69120\';
% fname = {'S69120_Sato'};
% p.sigma = 1.5;
%p.bins = 250;
% p.images = true;
% p.bins = 2000;
%p.min_c = 15^3;
%p.min_c = 3^3;
%p.threshold = 0.35;

%p.bins = 5000;
% p.threshold = 0.5;
% 
% fpath = 'E:\RECONSTRUCTIONS\Labate\TaraKeck_12R2\TaraKeck_12R2_E2\';
% fname = {'TaraKeck_12R2_E2_Log'};
% p.sigma = 3.0;
% p.min_c = 15^3;
% p.bins = 250;
% p.threshold = 0.5;
% 
% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet2\';
% fname = {'Stack8'};
% p.sigma = 2.0;
% p.images = true;
% p.threshold = 0.5;
% 
% fpath = 'C:\DATA\Hippocampus\';
% fname = {'Hippocampus_50'};
% p.sigma = 1.5;
% p.threshold = 0.5;
% 
% fpath = 'E:\RECONSTRUCTIONS\Multiphoton\V20050615A\';
% fname = {'V20050615Ae'};
% p.sigma = 2.0;
% p.bins = 500;
% p.images = true;
%p.bins = 2000;

% fpath = 'E:\RECONSTRUCTIONS\EXACT09\Training\RAW\CASE02';
% fname = {'V_Preprocessed'};
% p.sigma = 2;

% fpath = 'P:\Reconstruction\ReconstructionForJournalTMI\Diadem\Dataset5\02_Denoised_Frames';
% fname = {'Olfactory_Fibers_OP_3_D'};
% p.sigma = 1.5;

% 
% fpath = 'E:\RECONSTRUCTIONS\Multiphoton\V20020404';
% fname = {'V20020404Ba'};
% p.sigma =2.0;
% 
% fpath = 'E:\RECONSTRUCTIONS\Spines\ZSeries-10052010-1810-386_Cycle001_CurrentSettings_Ch1_000001_0_180\sub2_ZSeries';
% fname = {'ZSeries-sub2_E2_s_1_5'};
% p.sigma =1.5;
% p.threshold = 0.9;
% p.min_c = 10^3;


% fpath = 'E:\RECONSTRUCTIONS\Spines\ZSeries-10052010-1810-386_Cycle001_CurrentSettings_Ch1_000001_0_180\sub_ZSeries';
% fname = {'ZSeriessub2_E2_s_1_5'};
% p.sigma =1.5;
% p.threshold = 0.75;
% p.min_c = 10^3;

% fpath = 'E:\RECONSTRUCTIONS\Spines\ZSeries-10052010-1810-386_Cycle001_CurrentSettings_Ch1_000001_0_180';
% fname = {'sub2_ZSeries'};
% p.sigma =1.5;
% p.threshold = 0.75;

% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet4\';
% fname = {'NPF070'};
% p.sigma = 3.0;
% p.min_c = 4^3;
%p.threshold = 0.75;
% radius = [1 1.5 2 2.5];


% fpath = 'E:\RECONSTRUCTIONS\Spines\ZSeries-10052010-1810-386_Cycle001_CurrentSettings_Ch1_000001_0_180';
% fname = {'sub_ZSeries'};
% p.sigma =1.25;
%p.min_c = 15^3;


% fpath = 'E:\RECONSTRUCTIONS\Multiphoton\V20050623';
% fname = {'V20050623Ac'};
% sigma =2;
% p.bins = 1000;


% fpath = 'E:\RECONSTRUCTIONS\Spines\ZSeries-10052010-1810-386_Cycle001_CurrentSettings_Ch1_000001_0_180\sub_ZSeries';
% fname = {'ZSeriessub2_E2_s_1_5'};
% p.sigma =2.0;
% p.min_c = 10^3;
% p.threshold = 0.75;
% radius = 1.5;
% p.threshold = 0.9;

% fpath = 'E:\RECONSTRUCTIONS\DRIVE\training\images';
% fname = {'21_training'};
% p.sigma =0.5;
% p.bins =200;
% p.threshold = 0.5;

% fpath = 'E:\RECONSTRUCTIONS\Multiphoton\V20050629\V20050629Ad';
% fname = {'Syntethic_V'};
% p.sigma =2.25;
% p.threshold = 0.75;
% fpath = 'E:\RECONSTRUCTIONS\EXACT09\Training\RAW';
% fname = {'CASE02'};
% fpath = 'E:\RECONSTRUCTIONS\EXACT09\Training\RAW\CASE02';
% fname = {'DT'};
% p.sigma =2.0;
% fpath = 'E:\RECONSTRUCTIONS\Synthetic volumes';
% fname = {'Spiral_DT_Noise_m_0_v_0_2'};
% p.sigma =0.775;


% fname = {'Neocortical_Layer_6_Axons_Stack_01'};
% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet3';
% p.sigma =1.5;
% p.threshold =0.95;
% p.bins = 500;

% fname = {'CF_RowAColA' 'CF_RowAColB' 'CF_RowAColD' 'CF_RowAColE' ...
% 'CF_RowBColA' 'CF_RowBColB' 'CF_RowBColC' 'CF_RowBColD' 'CF_RowBColE' ...
% 'CF_RowCColA' 'CF_RowCColB' 'CF_RowCColC' 'CF_RowCColD' 'CF_RowCColE'};
% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet1\Cerebellar Climbing Fibers\CF_3';
% fname = {'CF_RowBColB' };
% p.sigma =4;
% p.threshold = 0.5;

% fpath = 'C:\DATA\NaAsO2 063010 Flk';
% fname = {'Stack_Time_37' };
% p.sigma =2;
% p.threshold = 0.5;
% p.min_c = 0;
% 
% 
% fpath = 'C:\DATA\NaAsO2 063010 Flk\Stack_Time_37';
% fname = {'Stack_time37_padded' };
% p.sigma =2;
% p.threshold = 0.5;
% p.min_c = 0;

% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet1\Cerebellar Climbing Fibers\CF_3\CF_RowAColD';
% fname = {'E3_sigma5' };
% p.sigma =4;
% p.threshold = 0.95;

% fpath = 'E:\RECONSTRUCTIONS\Spines\ZSeries-10052010-1810-386_Cycle001_CurrentSettings_Ch1_000001_0_180\sub_ZSeries\';
% fname = {'ZSeriessub2_E2_s_1_5' };
% p.sigma =1.5;
% p.bins = 500;
% p.min_c = 12^3;
% p.threshold = 0.75;

% fpath = 'C:\DATA\CTA\S69120';
% fname = {'S69120_E2' };
% p.sigma = 1.5;
%p.min_c = 20^3;

% fpath = 'E:\RECONSTRUCTIONS\Spines\ZSeries-10052010-1810-386_Cycle001_CurrentSettings_Ch1_000001_0_180\ZSeries-sub_132x132x132\ShearletCoefficients\';
% fname = {'max_response_Shearlets' };
% p.sigma =1.5;
% p.threshold = 0.5;

% fpath = 'E:\RECONSTRUCTIONS\Spines\ZSeries-10052010-1810-386_Cycle001_CurrentSettings_Ch1_000001_0_180';
% fname = {'sub_ZSeries' };
% p.sigma =1.5;
% p.threshold = 0.75;
% p.min_c = 10^3;

% fpath = 'E:\RECONSTRUCTIONS\Spines\ZSeries-10052010-1810-386_Cycle001_CurrentSettings_Ch1_000001_0_180\sub2_ZSeries';
% fname = {'sub2_ZSeries_AnisotropicDiffusion' };
% p.sigma =1.5;
% p.threshold = 0.5;
% p.min_c = 10^3;

% fpath = 'E:\RECONSTRUCTIONS\Synthetic volumes\OP_1\';
% fname = {'OP_1_GaussianNoise_m_0_v_0_01_Log' 'OP_1_GaussianNoise_m_0_v_0_1_Log' 'OP_1_GaussianNoise_m_0_v_0_02_Log' 'OP_1_GaussianNoise_m_0_v_0_2_Log' ...
%     'OP_1_GaussianNoise_m_0_v_0_03_Log' 'OP_1_GaussianNoise_m_0_v_0_3_Log' 'OP_1_GaussianNoise_m_0_v_0_04_Log' 'OP_1_GaussianNoise_m_0_v_0_4_Log' ...
%     'OP_1_GaussianNoise_m_0_v_0_005_Log' 'OP_1_GaussianNoise_m_0_v_0_05_Log' 'OP_1_GaussianNoise_m_0_v_0_5_Log' 'OP_1_GaussianNoise_m_0_v_0_006_Log' ...
%     'OP_1_GaussianNoise_m_0_v_0_06_Log' 'OP_1_GaussianNoise_m_0_v_0_007_Log' 'OP_1_GaussianNoise_m_0_v_0_07_Log' 'OP_1_GaussianNoise_m_0_v_0_008_Log' ...
%     'OP_1_GaussianNoise_m_0_v_0_009_Log' 'OP_1_GaussianNoise_m_0_v_0_09_Log' 'OP_1_GaussianNoise_m_0_v_0_9_Log' 'OP_1_GaussianNoise_m_0_v_0_075_Log'};
% %fname = {'OP_1_GaussianNoise_m_0_v_0_075_Log'};
% sigma = [0.75 2.75 3.0 3.25];
% sigma = [1.75];
% %p.bins = 125;
% %p.threshold = 0.7;
% % p.bins = 125;
% 
% fpath = 'E:\RECONSTRUCTIONS\Synthetic volumes\OP_1\';
% fname = {'OP_1_PosionNoise_Log'};
% %fname = {'OP_1_GaussianNoise_m_0_v_0_075_Log'};
% sigma = [0.75 1.0 1.25 1.5 1.75 2.0 2.25 2.5 2.75 3.0];
% p.threshold = 0.75;

% 
% 

% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet1\Cerebellar Climbing Fibers\CF_3\';
% fname = {'CF_RowAColA' 'CF_RowAColB' 'CF_RowAColD' 'CF_RowAColE' 'CF_RowBColA' 'CF_RowBColB' 'CF_RowBColC' ...
%     'CF_RowBColD' 'CF_RowBColE' 'CF_RowCColA' 'CF_RowCColB' 'CF_RowCColC' 'CF_RowCColD' 'CF_RowCColE'};
% % fname = {'CF_RowAColA' };
% sigma = 7;
%p.images = true;
%p.bins = 125;
%p.threshold = 0.5;

% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet2\Hippocampal_CA3_Part_2_Max';
% fname = {'Stack5_2' 'Stack6' 'Stack7' 'Stack8' 'Stack9' 'Stack10' 'Stack11' 'Stack12'};
% % fname = {'CF_RowAColA' };
% sigma = 3;
% p.min_c = 16^3;
%p.threshold = 0.9;
% p.bins = 100;
% 
% fname = {'V081005Ad3'};
% fpath = 'E:\RECONSTRUCTIONS\confocal\V081005A';
% % fname = {'CF_RowAColD' };
% p.sigma =3;
% p.bins = 100;
% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet2\Hippocampal_CA3_Part_2_Max';
% fname = {'stack_6_1' 'stack_7_1' 'stack_8_1' ...
%     'stack_6_2' 'stack_7_2' 'stack_8_2' 'stack_9_2' ...
%     'stack_2_3' 'stack_3_3' 'stack_4_3' 'stack_5_3' 'stack_6_3' 'stack_7_3' 'stack_8_3' ...
%     'stack_2_4' 'stack_3_4' 'stack_4_4' 'stack_5_4' 'stack_6_4' 'stack_7_4' 'stack_8_4' 'stack_9_4' ...
%     'stack_4_5' 'stack_5_5' 'stack_6_5' 'stack_7_5' 'stack_8_5' 'stack_9_5' ...
%     'stack_4_6' 'stack_5_6' 'stack_9_6' ...
%     'stack_4_7' 'stack_5_7'};
% %fname = {'stack_4_5'};
% fname = {'CF_RowAColA' };
% sigma = 2;
% p.min_c = 12^3;
% fpath = 'E:\RECONSTRUCTIONS\Labate\TaraKeck_12R2\';
% fname = {'TaraKeck_12R2_Log' };
% p.sigma = 4.0;
%  p.threshold = 0.95;
% p.bins = 500;

%fpath = 'C:\DATA\Fernanda\';
%fname = {'FerSol_2' };
%sigma =  2.0;



% p.delete_files = false;
% p.showImages = false;
%p.GUI = true;
%p.min_c = 15^3;
%p.bins = 250;
%p.threshold = 0.9;

%p.min_c =15^3;
% p.threshold  = 0.5;
% p.bins = 500;
total_time = 0;
for i=1:length(fname)
    for s=1:length(sigma)
        tic;
        p.sigma = sigma(s);
        
        %ID for the output of the segmentation of DENDRITES
        p.file_ID_segmentation = 'DENDRITES';

        ORION3_Dendrites(fpath,fname{i},p);
        %ORION_3(fpath,fname{i},p);
        t = toc;
        computeElapsedTime(t, 'Segmentation');
        total_time = total_time + t;
        computeElapsedTime(total_time, 'Segmentation');
    end
end
end

