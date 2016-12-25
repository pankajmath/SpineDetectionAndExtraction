function p = compute2DHistogram(F,p)
%compute the cost function for a voxel to belong to background
%F is a nx2 vector the columns are the 2nd and 3rd eigenvalue sorted
%according to Frangi


%We may have many points to compute the distribution of the eigenvalues.
%Randomly selecting 1000000 will not affect the distribution
n_samples = size(F,1);
max_numberofSamples = 10^6;
if n_samples > max_numberofSamples
    %randomly selecting 1000000 samples
    I = randsample(n_samples,max_numberofSamples);
    F = F(I,:);
end

%removing noisy points and creating the bounding box for the histogram
I = removeIsolatedResponses(F(:,1)) | removeIsolatedResponses(F(:,2));
%fprintf('Removing %i elements \n', sum(I));
F(I,:) = [];

p.size = size(F,1);

for i=1:2
    %get minimum and maximum values for the current feature vector
    min_ = min(F(:,i));
    max_ = max(F(:,i));
    
    %compute the bin size for the current feature
    p.step{i} = (max_ - min_)/p.bins;   
    
    %compute the edges of the histogram
    p.edges{i} = min_:p.step{i}:max_;
end


%compute 2D histogram for the given edges
p.hist = hist3(F,'Edges',p.edges);

%compute cost function for the current histogram
[p.hist p.threshold]= normalizeHistogram(p);


end

function [h T]= normalizeHistogram(p)
%parameter for the smoothing of the Histogram
sigma_ = 5;

%get the histogram
h = p.hist;

%visualize the logaritm of the distribution of the eigenvalues
if p.showImages
    displayImage(log(h+1),'Log of distribution of eigenvalues',p);
end


%Apply sigmoid function to normalize the volume
h = 1./ (1 + exp(-2*h));


%Visulize the cost function after that we apply the sigmoid function
if p.showImages
    displayImage(h,'Transformation of the distribution',p);
end

%smoothing the histogram using a Gaussian kernel
%creating the filter
filt = fspecial('gaussian', ceil(6*sigma_), sigma_);

%convolving with the filter
h = imfilter(h,filt,'replicate','same');

%normalize to the interval [0,1]
min_ = min(h(:)); max_ = max(h(:));
h = (h-min_)/(max_ - min_);


%Visualize the final cost function
if p.showImages
    displayImage(h,'Smoothed cost function',p);
end

%Check that at least 97% of training set are correctly classified with the
%threshold
T = p.threshold;
b = h>=1-T;
percentile = sum(p.hist(b(:)))/sum(p.hist(:)); %percentile = number of training set of samples correctly classified/number of samples;
while percentile < 0.97
    T = (T+1)/2; %increasing the threshold
    b = h>=1-T;
    percentile = sum(sum(p.hist(b)))/sum(p.hist(:))
end

end

function displayImage(h,title_,p)
clim = [0 max(h(:))];
figure;imagesc(p.edges{2},p.edges{1},h,clim); colorbar; set(gca,'YDir','normal'); xlabel('\lambda_3','fontsize',15);ylabel('\lambda_2','fontsize',15); axis('normal'); title(title_,'fontsize',15)
end


