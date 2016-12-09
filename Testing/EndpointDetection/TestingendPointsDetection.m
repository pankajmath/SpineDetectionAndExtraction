%function to test the approach for end point detection

%fpath: the relative path to the folder which contain the input and
%segmentation volumes
%fRaw: file name of the input volume
%fSeg: file name of the segmented volume
%sigma: the approximate radius of the tubular structure (TS)
%example
fpath = 'E:\RECONSTRUCTIONS\Spines\';
fRaw = 'ZSeriessub2_Input';
fSeg = 'ZSeriessub2_Segmentation';
sigma = 2.0;


fpath = 'E:\RECONSTRUCTIONS\Spines\ZSeries-10052010-1810-386_Cycle001_CurrentSettings_Ch1_000001_0_180\sub_ZSeries\ZSeriessub2_E2_s_1_5\';
fRaw = 'ZSeriessub2_E2_s_1_5';
fSeg = 'ZSeriessub2_E2_s_1_5_Segmentation_s_1_5_t_0_75_b_500';
sigma = 2.0;


fpath = 'E:\RECONSTRUCTIONS\Multiphoton\V20060452\';
fRaw = 'V20060452';
fSeg = 'V20060452_Segmentation_s_0_765_t_0_5_b_500';
sigma = 1.5;

fpath = 'E:\RECONSTRUCTIONS\Labate\TaraKeck_12R2\TaraKeck_12R2_Log';
fRaw = 'TaraKeck_12R2_Log';
fSeg = 'TaraKeck_12R2_Log_Segmentation_s_4_t_0_5_b_500';
sigma = 4.0;

tic;
endPointsDetection(fpath,fRaw,fSeg,sigma);
toc
