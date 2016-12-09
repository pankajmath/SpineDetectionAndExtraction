%function to test the approach for seeding

% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet5\Olfactory_Fibers_OP_1';
% fRaw = 'Olfactory_Fibers_OP_1';
% fSeg = 'Olfactory_Fibers_OP_1_Segmentation_s_1_5';
% sigma = 2;
% 
% fpath = 'E:\RECONSTRUCTIONS\Multiphoton\V20050623\V20050623Ac';
% fRaw = 'V20050623Ac';
% fSeg = 'V20050623Ac_Segmentation_s_0_3_t_0_5_b_500';
% sigma = 2;

% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet3\Neocortical_Layer_6_Axons_Stack_03';
% fRaw = 'Neocortical_Layer_6_Axons_Stack_03';
% fSeg = 'Neocortical_Layer_6_Axons_Stack_03_Segmentation_s_1_5_t_0_5_b_500';
% sigma = 1.5;

% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet4\NPF086';
% fRaw = 'NPF086';
% fSeg = 'NPF086_Segmentation_s_3';
% sigma = 3.0;
% 
% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet1\Cerebellar Climbing Fibers\CF_3\CF_RowAColD';
% fRaw = 'CF_RowAColD';
% fSeg = 'CF_RowAColD_Segmentation_s_5_t_0_95_b_500';
% sigma = 6.0;

% fpath = 'E:\RECONSTRUCTIONS\Multiphoton\V20050620\V20050620c';
% fRaw = 'V20050620c';
% fSeg = 'V20050620c_Segmentation_s_0_6';
% sigma = 1.5;

fpath = 'E:\RECONSTRUCTIONS\Multiphoton\V20060452';
fRaw = 'V20060452';
fSeg = 'V20060452_Segmentation_s_0_765_t_0_5_b_500';
sigma = 1.5;

% fpath = 'E:\RECONSTRUCTIONS\confocal\V022305A\V022305Aa';
% fRaw = 'V022305Aa';
% fSeg = 'V022305Aa_Segmentation_s_0_4604';
% sigma = 2.0;

% fpath = 'E:\RECONSTRUCTIONS\Spines\ZSeries-10052010-1810-386_Cycle001_CurrentSettings_Ch1_000001_0_180\ZSeries-sub_132x132x132';
% fRaw = 'ZSeries-sub_132x132x132';
% fSeg = 'ZSeries-sub_132x132x132_Segmentation_s_1_5_t_0_75_b_500';
% sigma = 2.0;


tic;
centerlineExtraction(fpath,fRaw,fSeg,sigma);
toc