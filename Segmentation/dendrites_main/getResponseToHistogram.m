function R= getResponseToHistogram(parameters,F)
%this function obtains the cost function to belong to the background for
%features F

%For each feature vector compute the position in the histogram
for i=1:2
    %get current feature
    features = F(:,i);
    
    %Getting the appropiated parameters for the feature i
    %minimum and maximum value used to compute the histogram
    min_bin = parameters.edges{i}(1);
    max_bin = parameters.edges{i}(end);
    
    %Getting the bin size
    bin_step = parameters.step{i};
    
    
    %features falling outside the range of the histogram. Move to the
    %boundary of the histogram (it will not affect the value of the response because we have low values close to the boundary)
    I = features < min_bin;
    features(I) = min_bin;
    I = features > max_bin;
    features(I) = max_bin;
    
    %computing the position of the bin
    pos{i} = floor((features - min_bin)/bin_step)+1;
end

%getting the histogram of background
histogram_background = parameters.hist;
clear features I parameters;

%changing values of the bins from (bin_i,bin_j) to index
index = sub2ind(size(histogram_background),pos{1},pos{2});

%creating the response function to background for each bin
R = histogram_background(index);

%calculating the response for foreground
R = 1-R;
end