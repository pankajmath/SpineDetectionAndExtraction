function compute_Laplacian(relpath,fname, L_val,n)
%Function to calculate the Laplacian 
%L_val --- values for the laplacian. Example L_val = [0.3 0.5 0.6]
%relpath --- path to the volumes
%fname --- file name to compute the laplacian
% n --- the degree of the polynomial to approximate the exponential


%reading the volume
[Image SPACING]=RAWfromMHD(strcat(fname,'.mhd'),[],relpath);

Image = single(Image);

%computing the fourier transform
%fprintf('Computing Laplacian Filters....')
Image=fftn(Image);


%getting the size of the image
[nx ny nz]=size(Image);

for i =1:length(L_val)
    %Getting the value for the Laplacian
    fact = L_val(i);
    
    %generate Laplacian filter
    filt=Makefilter(nx,ny,nz,n,fact,1);

    %Apply the filter
    ImageN=Image.*filt;

    %obtain the inverse fourier transform
    ImageN=ifftn(ImageN,'symmetric');
    WriteRAWandMHD(ImageN,strcat(fname,'_LP_Lap_',num2string(fact),'_F'),relpath,SPACING);
end

%fprintf('done....\n')
end
