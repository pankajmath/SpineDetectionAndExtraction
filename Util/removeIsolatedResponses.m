function I = removeIsolatedResponses(F)
%we are interested only in getting the distribution where we have large
%values of the histogram. We use random sampling to remove isolated responses
%F: input vector of the features as column vector

%number of time to average the bounding box
n = 200;

%size of rand sample
rand_s = 200;
if rand_s > size(F,1)
    rand_s = size(F,1);
end

min_ = 0;
max_ = 0;
for i=1:n
    %randonly select rand_s samples from the Feauture vector
    I = randsample(size(F,1),rand_s);
    
    %select the feature points
    T = F(I);
    
    %get the bounding box for the current sample. (We divide by n, because we average all the boxes sizes)
    min_ = min_ + min(T(:))/n;
    max_ = max_ + max(T(:))/n;
end

%compute interval size
d = max_ - min_;

m = (max_-min_)/2;

%fprintf('min = %f   max = %f\n', min_, max_);
%create tree times the interval size
min_ = m - 2*d; 
max_ = m + 2*d; 


%get features vectors outside this box
I = F<min_ | F>max_;

end