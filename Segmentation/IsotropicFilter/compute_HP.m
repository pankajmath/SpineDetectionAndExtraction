function compute_HP(relpath,fname)
%Allows to compute only HP filter
%L_val --- values for the laplacian. Example L_val = [0.3 0.5 0.6]
%relpath --- path to the volumes
%fname --- file name to compute the laplacian

close all;
%reading the volume
Image=single(RAWfromMHD(strcat(fname,'.mhd'),[],relpath));

%computing the fourier transform
disp('Forward Fourier Transform....')
Image=fftn(Image);
disp('done....')

%getting the size of the image
[nx ny nz]=size(Image);

step =0.05;

for fact1 =0.25:0.1:0.5
    filt=Makefilter(nx,ny,nz,60,fact1,0);
    for fact2 =0.05:step:fact1-step
        %generate Laplacian filter
        disp('Generating filter....');
        filt1=Makefilter(nx,ny,nz,60,fact2,0);
        disp('done....')
        
        filt1=filt-filt1;
        %Apply the filter
        disp('Applying filter....')
        ImageN=Image.*filt1;
        disp('done....')

        %obtain the inverse fourier transform
        disp('Inverse Fourier Transform....')
        ImageN=ifftn(ImageN,'symmetric');
        figure; imshow(max(ImageN,[],3)',[]); colormap('jet');colorbar; title(['fact1 = ' num2string(fact1) '_fact_2 = ' num2string(fact2)])
        disp('done....')
        WriteRAWandMHD(ImageN,strcat(fname,'_HP_',num2string(fact1),'__',num2string(fact2),'_F'),relpath);
    end
end

end

