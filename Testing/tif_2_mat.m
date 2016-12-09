
fileName='Y:\Documents\UTMB\PV 20X  UH\10-05-14_9329KO_W12T4_PV-GAD67_CA1_20X_St-6.tif';

info =imfinfo(fileName,'tif');
%info=imfinfo(fileName);

num_images=numel(info);

f= cell(num_images,1);
for k=1:num_images
    f{k}= imread(fileName, k, 'Info', info)';
end

image1=cat(3,f{:});