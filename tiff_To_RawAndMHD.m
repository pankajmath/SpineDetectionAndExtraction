function RawAndMHD=tiff_To_RawAndMHD(filepath,filename)
% filepath='C:\Users\pankaj singh\Documents\DemoSFN\';
% 
% filename='E10_R1_T7.tif'; % filename is the .tif or .raw file in the directory

info = imfinfo(filename); % provides information about the graphics

 num_images = numel(info); % number of image stacks in the graphics 
 
 A=cell(1,num_images);
for k = 1:num_images
    %A{k}=rgb2gray(imread(filename,k))'; % reading k^th slice/stack of the graphics
    A{k}=(imread(filename,k))'; % reading k^th slice/stack of the graphics
end
image=cat(3,A{:}); % putting them together to get a 3D image

a=strcat('Sajo_',filename);
RawAndMHD=a(1:end-4);
WriteRAWandMHD(image,RawAndMHD,filepath);


% filepath=filepath;

close all
%clear all
end