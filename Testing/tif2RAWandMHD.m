function image=tif2RAWandMHD(fpath,fname,fdestName)

fileName=[fpath,filesep,fname,'.tif'];


info =imfinfo(fileName,'tif');

num_images=numel(info);

f= cell(num_images,1);
for k=1:num_images
    f{k}= imread(fileName, k, 'Info', info)';
end

image=cat(3,f{:});

WriteRAWandMHD(image,fdestName,fpath)


end