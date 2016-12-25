function B = remove_small_conComp3D(B, minPix)
%function to remove component components with less than minPix
%B is a binary imagy
%figure;imshow(B,[]);
conComp = bwconncomp(B,26);
for i=1:conComp.NumObjects
    if (size(conComp.PixelIdxList{i},1)<=minPix)
        B(conComp.PixelIdxList{i})=0;
    end
end
%figure;imshow(B,[]);
end