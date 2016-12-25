function [V1 V2 V3]=readEigenvalues(file_name, file_path, sigma)

V1 = RAWfromMHD([file_name '.EigVal1.Sigma.' num2str(sigma)],[],file_path); 
V2 = RAWfromMHD([file_name '.EigVal2.Sigma.' num2str(sigma)],[],file_path); 
V3 = RAWfromMHD([file_name '.EigVal3.Sigma.' num2str(sigma)],[],file_path); 
%to avoid problems in computing average, first we remove all Nan Number
I = isnan(V1) | isnan(V2)| isnan(V3); V1(I)=0; V2(I)=0; V3(I)=0;
%fprintf('Total number of NaN: %i\n', length(find(I>0)));
clear I;

end