function [N P T]= readNegativePositiveSamples(file_path,file_name,sigma)
%reading the negative samples

%degree of polynomial for the taylor expansion of the exponential
n = 60;

%normalizing the sigma from the Fourier space to Spatial Domain. %I found this parameter by computing Dr. Papadakis filter in the Fourier space  and
%applying a inverse transform to send it back to the spatial domain. Finally, finding the gaussian kernel that best
%match the filter. 
normalization_constant = 0.1674; 
normalization_constant = 0.2615/sqrt(2); 

%computing the fist value for the Laplacian this is the main parameter to
%detect the boundary of the tubular structure
Lap(1) = normalization_constant * sqrt(2.0*n+1)/(sigma*pi); 

outer_boundarySigma = sigma + sigma/2; %this is in the spatial domain

%computing the second value for the Laplacian to remove noisy response
%close to the boundary
Lap(2) = normalization_constant* sqrt(2.0*n+1)/(outer_boundarySigma*pi);

%truncate Lap value to only two decimals. This is to avoid long strings
%when creating the name of the laplacian output;
Lap = str2num(sprintf('%.2f  %.2f',Lap));

%computing the laplacian to get negative examples
if (~exist(fullfile(file_path,[file_name '_LP_Lap_' num2string(Lap(1)) '_F.mhd']),'file') || ~exist(fullfile(file_path,[file_name '_LP_Lap_' num2string(Lap(2)) '_F.mhd']),'file'))
    compute_Laplacian(file_path, file_name, Lap,n);
end

%reading the computed negative samples
[L1 SPACING]= RAWfromMHD([file_name '_LP_Lap_' num2string(Lap(1)) '_F'],[],file_path);

[L2 SPACING]= RAWfromMHD([file_name '_LP_Lap_' num2string(Lap(2)) '_F'],[],file_path);

%take only the Negativa part which we know belong to the background
N = L1>max(L1(:)/100);
P = L1<min(L1(:)/10);

T = L1 < max(L1(:) + 1);

%NOTE THAT: There is a problem with the implementation of the Laplacian. We have in the implementation |e|^2 F_LP and it should be - |e|^2 F_LP.
%Theory said that voxels in the background should have positive response.
%However, due to implementation that we are using background voxels
%correspong to negative values.


%create the seed point volume
% % % s = find(I);
% % % s = randsample(s,5000);
% % % L = L1>inf | L2 >inf;
% % % L(s) = 1;
% % % WriteRAWandMHD(L,[file_name '_SeedPoints'],file_path);

end