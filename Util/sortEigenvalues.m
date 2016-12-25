function Y = sortEigenvalues(file_name, file_path,sigma)
%sorting the eigenvalues according to magnitud

[V1 V2 V3]=readEigenvalues(file_name, file_path, sigma);

%create a matrix with the rows to sort
D = [V1(:) V2(:) V3(:)];

%clear variable
%clear V1 V2 V3;

%number of division of D to avoid out of memory or the sorting process
%becoming very slow due to swaping between ram memory and virtual memory
n = 5;

%get the position to divide the data in n different sets
pos_n = floor(size(D,1)/n);

Y = [];
for i=1:n
    %check if we are in the last division
    if i==n
        %the volume may not by divisible by 4 then we have to make sure not
        %to go beyond the size of the data
        pos_n = size(D,1);
    end
    
    %sorting i-th division of the volume (to avoid out of memory)
    Y = [Y; sortEig(D(1:pos_n,:))];
    
    %deleting i-th division of the volume
    D(1:pos_n,:) = [];
end

end

function Y = sortEig(D)
%sort values according to absolute value... Note that values of Sorted are
%absolute values
[Sorted I]=sort(abs(D),2);
clear Sorted;

%create a vector to save the values
Y = single(zeros(size(I)));

%sorting for the column j
for j = 1:3 
    %finding the appropiate order
    for i=1:3
        r = I(:,j) ==i;
        %saving the appropiate order
        Y(r,j) = D(r,i); 
    end
end


end