function p = settingDefaultParameters(p,file_path)
%Just setting the defailt paramters for the segmentation

%just in case the user wants to use a specific threshold value
if ~isfield(p,'threshold')
    p.threshold = 0.5;
end

%just in case the user wants to use a specific value for minimum number of
%components
if ~isfield(p,'min_c')
    p.min_c = round((4*p.sigma)^3);
end

%Just in case that user wants to create a specific number of bins to
%calculate the histogram
if ~isfield(p, 'bins')
   p.bins = 500;
end

%path to save the output segmentation
if ~isfield(p,'folder_output')
    p.folder_output = file_path;
end

%just an ID of the segmentation
if ~isfield(p,'file_ID_segmentation')
    p.file_ID_segmentation = '';
end

%just a field to delete files used in the segmentation process
%Default value is not to delete files
if ~isfield(p,'delete_files')
    p.delete_files = false;
end

%A field to show the process of creating the discriminant function
if ~isfield(p,'showImages')
    p.showImages = false;
end

%A field to show the process of the segmentation
if ~isfield(p,'GUI')
    p.GUI = false;
end

end