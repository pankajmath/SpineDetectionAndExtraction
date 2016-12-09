
fileName='Y:\Documents\UTMB\10-05-14_211WT_W4T1_PV-Vgat_CA1_20X_St-6_blue.tif';

%info =imfinfo(fileName,'tif');
info=imfinfo(fileName);

num_images=numel(info);

g= cell(num_images,1);
for k=1:num_images
    g{k}= imread(fileName, k, 'Info', info);
end

%image1=cat(3,f{:});