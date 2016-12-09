function computeElapsedTime(t,ID)
%Just to compute the segmentation time
hours = floor(mod(t/60^2,60));
minutes = floor(mod(t/60,60));
seconds = floor(mod(t,60));
fprintf([ID ' time is %ih %imin %is\n'],hours,minutes,seconds)
end