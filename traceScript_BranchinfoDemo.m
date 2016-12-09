function traceScript_BranchinfoDemo(filepath,editedSeg)

% Copyright © 2012 Computational Biomedicine Lab (CBL), 
% University of Houston. All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, is prohibited without the prior written consent of CBL.
%

%%%%%%%%%%%%%%%%%%%% 
% CHANGING OPTIONS % 
%%%%%%%%%%%%%%%%%%%% 
% pathList = {'C:\Users\david\Desktop\for David\Raw\OP\Olfactory_Fibers_OP_1'};
% nameList = {'Olfactory_Fibers_OP_1'}; 
% mdSuffix = '_dOP';
% clSuffix = '_CL';
% zSmearFactor = 1;

 pathList = {filepath};
%pathList={'Y:\Documents\DemoSFN'};
    %'C:\Users\pankaj singh\Desktop\Read\MatlabExp\TaraKeck\Stack1\Common\Log_Common\SpineExtraction\Time_2\'...
   % 'C:\Users\pankaj singh\Desktop\Read\Laezza\'...
%     'C:\Users\pankaj singh\Desktop\Read\Laezza\'...
%     'C:\Users\pankaj singh\Desktop\Read\Laezza\'...
%     'C:\Users\pankaj singh\Desktop\Read\Laezza\'...
%     'C:\Users\pankaj singh\Desktop\Read\Laezza\'...
%     'C:\Users\pankaj singh\Desktop\Read\Laezza\'...
%     'C:\Users\pankaj singh\Desktop\Read\Laezza\'...
%     'C:\Users\pankaj singh\Desktop\Read\Laezza\'...
%     'C:\Users\pankaj singh\Desktop\Read\Laezza\'};
%};

 nameList = {editedSeg};
% nameList={'RawAndMHD_k1016-1988-A4 0d_Edited_ROI'};
    %'Log_Common_2_Edited'...
%     'Laezza_DIV14_GSK24h_combined_Denoised_Segmentation_DENDRITES_s_0_56_t_0_75_b_1000',...
%     'Laezza_DIV14_GSK24h_combined_Segmentation_DENDRITES_s_2_t_0_75_b_1000' ...
%     'Laezza_first_blue_Segmentation_DENDRITES_s_0_56_t_0_75_b_1000'...
%     'Laezza_first_combined_Denoised_Segmentation_DENDRITES_s_0_56_t_0_75_b_1000'...
%     'Laezza_first_combined_Segmentation_DENDRITES_s_0_56_t_0_75_b_1000'...
%     'Laezza_second_blue_Denoised_Segmentation_DENDRITES_s_0_56_t_0_75_b_1000'...
%     'Laezza_second_blue_Segmentation_DENDRITES_s_0_56_t_0_75_b_1000'...
%     'Laezza_second_combined_Denoised_Segmentation_DENDRITES_s_0_56_t_0_75_b_1000'...
%     'Laezza_second_combined_Segmentation_DENDRITES_s_0_56_t_0_75_b_1000'}; 
%};
mdSuffix = '';
clSuffix = '_CL_Branch.swc';
zSmearFactor = 1;



%%%%%%%%%%%%%%%%% 
% FIXED OPTIONS % 
%%%%%%%%%%%%%%%%% 
K = length(pathList);
L = zeros(K,4);

% parfor k = 1:K
for k = 1:K
    path = pathList{k};
    %name = strcat(nameList{k}, mdSuffix,'_BIN');
    name = strcat(nameList{k}, mdSuffix);
    savName = fullfile(path,strcat(name,clSuffix));
    %LB = .5;
    LB = .2;
    B = RAWfromMHD(name,[],path);
    [S D I] = genSeeds(B,LB,zSmearFactor); 
    T = joinSeeds(D,S,I); 
    T = genTraceTable_Branch(T); 
    dlmwrite(savName, T.amiraTable, 'delimiter', ' ');
    % disp(k);
end



end

% CREATED: 
% - Date: 09/06/2012
% - By: David Jimenez.
%EDITED:
%- Date: 03/02/2014
% - By: Pankaj Singh.
%
