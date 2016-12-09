function [I SPACING Lap]= readNegativeSamples(file_path,file_name,sigma)
%reading the negative samples
%degree of polynomial for the taylor expansion of the exponential
n = 60;

%computing the fist value for the Laplacian this is the main parameter to
%detect the boundary of the tubular structure
Lap(1) = sqrt(2.0*n+1)/(sqrt(2)*(3.6853*sigma - 2.1676)*pi); 

outer_boundarySigma = 1.5*sigma; %this is in the spatial domain

%computing the second value for the Laplacian to remove noisy response
%close to the boundary
Lap(2) = sqrt(2.0*n+1)/(sqrt(2)*(3.6853*outer_boundarySigma - 2.1676)*pi); 

%truncate Lap value to only two decimals. This is to avoid long strings
%when creating the name of the laplacian output;
Lap = str2num(sprintf('%.2f  %.2f',Lap));

%computing the laplacian to get negative examples
if (~exist(fullfile(file_path,[file_name '_LP_Lap_' num2string(Lap(1)) '_F.mhd']),'file') || ~exist(fullfile(file_path,[file_name '_LP_Lap_' num2string(Lap(2)) '_F.mhd']),'file'))
    compute_Laplacian(file_path, file_name, Lap,n);
end

%reading the computed negative samples
L1 = RAWfromMHD([file_name '_LP_Lap_' num2string(Lap(1)) '_F'],[],file_path);

[L2 SPACING]= RAWfromMHD([file_name '_LP_Lap_' num2string(Lap(2)) '_F'],[],file_path);

%take only the Negativa part which we know belong to the background
I = L1>0 | L2> 0;

end