function compute_LP(relpath,fname,LP)
%Allows to compute only Low pass filter
%L_val --- values for the laplacian. Example L_val = [0.3 0.5 0.6]
%relpath --- path to the volumes
%fname --- file name to compute the laplacian


%reading the volume
Image=single(RAWfromMHD(strcat(fname,'.mhd'),[],relpath));

%computing the fourier transform
disp('Forward Fourier Transform....')
Image=fftn(Image);
disp('done....')

%getting the size of the image
[nx ny nz]=size(Image);

for fact1 =LP
    %generate Laplacian filter
    
    filt1=Makefilter(nx,ny,nz,60,fact1,0);
    

    %Apply the filter
    ImageN=Image.*filt1;
    

    %obtain the inverse fourier transform
    
    ImageN=ifftn(ImageN,'symmetric');
    
    WriteRAWandMHD(ImageN,strcat(fname,'_LP_',num2string(fact1),'_F'),relpath);
end

end

