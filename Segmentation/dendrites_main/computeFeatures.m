function F= computeFeatures(file_path,file_name,sigma)
%The features are the eigenvalues of the Hessian Matrix

%compute the eigenvalues for the given scale
computeEigenvalues(fullfile(file_path,file_name),sigma);

%----------------------------------------------------------------------------------
%EXTRACTING THE FEATURE VECTORS

%Current Eigenvalues sorted according to Sato V3 <V2<V1
% if fea_id==1
%     
%     [V1 V2 V3]=readEigenvalues(file_name, file_path, sigma);
% 
%     F{fea_id} = [V2(:) V3(:)];
% end
% F = F{fea_id};
% 
% 


%%%%%SORTING ACCORDING TO FRANGI
% %sorting the input such that |V1|<= |V2| <= |V3| (according to frangi)
Sorted = sortEigenvalues(file_name, file_path,sigma);

F = [Sorted(:,2) Sorted(:,3)];

clear Sorted;

end
