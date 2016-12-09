function testOnlineSVM
close all;
fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet5\Olfactory_Fibers_OP_3\';
fbin = 'Olfactory_Fibers_OP_3_Segmentation_s_1_75_t_0_5_b_500';
fname = 'Olfactory_Fibers_OP_3';
sigma = 2.0; 
radius = 15;

% fpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet5\Olfactory_Fibers_OP_5\';
% fbin = 'Olfactory_Fibers_OP_5_3D_Segmentation_s_1_5_t_0_5_b_500';
% fname = 'Olfactory_Fibers_OP_5';
% sigma = 1.0; 
% radius = 10;

p.threshold = 0.5;
p.min_c = 3^3;

% V = RAWfromMHD(fname,[],fpath);
%Reading binary volume
B = RAWfromMHD(fbin,[],fpath);

%getting testing values
DT = bwdist(B);
Unkown = DT<radius; 


%reading background samples using the laplacian 
[N P Unkown] = readNegativePositiveSamples(fpath,fname,sigma);
% 
% 

% 

% DTP = bwdist(~B);
% P = DTP>2;
% N = DT>0 & DT<2*radius/10; 

WriteRAWandMHD(N,'Negative_L',fpath);
WriteRAWandMHD(P,'Positive_L',fpath);

Unkown = DT<radius; 

%getting features samples
features= computeFeatures3D(fpath,fname,sigma,1);

%features = calculateFeatures(features(:,1),features(:,2),features(:,1));
%features = calculateFeatures(features(:,1),features(:,2),features(:,3));
%trainigng the model
model=trainSVMmodel(features(P,:),features(N,:));

%allocating memory to test
probability_Prediction = single(zeros(size(Unkown)));

%testing the model
probability_Prediction(Unkown)=testSVMmodel(features(Unkown,:),model);

WriteRAWandMHD(probability_Prediction,[fname '_probability_Prediction'],fpath,[1 1 1]);

figure; imshow(max(probability_Prediction,[],3)',[]);colormap('jet'); colorbar;

%segmenting and removing small components
Segmentation = remove_small_conComp3D(probability_Prediction>p.threshold, p.min_c);

%save the segmentation
WriteRAWandMHD(Segmentation,[fname '_Segmentation_svm_' num2string(sigma) '_t_' num2string(p.threshold)],fpath,[1 1 1]);

figure; imshow(max(Segmentation,[],3)',[]);colormap('jet'); colorbar;
end


function [F P]= readFeatures(fpath,fname,sigma,N_l, P_l, U_l)

Y = sortEigenvalues(fname,fpath,sigma);


F = [calculateFeatures(Y(N_l,1),Y(N_l,2),Y(N_l,3)) zeros(size(N_l,1),1); ...
    calculateFeatures(Y(P_l,1),Y(P_l,2),Y(P_l,3)) ones(size(P_l,1),1)];

P = [calculateFeatures(Y(U_l,1),Y(U_l,2),Y(U_l,3)) zeros(size(U_l,1),1)];



end

function model=trainSVMmodel(P,N)
nsamples = 2000;
%randomly selecting nsamples to speed up the training

I = randsample(size(P,1),nsamples);
P = P(I,:);
I = randsample(size(N,1),nsamples);
N = N(I,:);
k_crossvalidation = 2;
I=randsample(nsamples,nsamples);
constant = 100;
[G C] = meshgrid([1/100000 1/10000 1/5000 1/1000 1/500 1/250 1/100 1/50 1/25 1/10 1 2 4 8 16 32],[1/100 1/50 1/10 1 2 4 10 50 100 200 500]);
numberofexperiments = 50;
exp_rand = randsample(length(G(:)),numberofexperiments);
max_accuracy = 0;
for i =1:length(exp_rand)
    model = svmtrain([ones(size(P,1)/2,1); zeros(size(N,1)/2,1)], double([P(1:size(P,1)/2,:);N(1:1:size(N,1)/2,:)]) , ['-b 1 -g ' num2str(G(exp_rand(i))) ' -c ' num2str(C(exp_rand(i)))]);
    [predicted_label, accuracy1, decision_values] = svmpredict([ones(size(P,1)/2,1); zeros(size(N,1)/2,1)], double([P(size(P,1)/2 +1:end,:);N(size(N,1)/2 +1:end,:)]), model , '-b 1');
    model = svmtrain([ones(size(P,1)/2,1); zeros(size(N,1)/2,1)],  double([P(size(P,1)/2 + 1:end,:);N(size(N,1)/2 +1:end,:)]) , ['-b 1 -g ' num2str(G(exp_rand(i))) ' -c ' num2str(C(exp_rand(i)))]);
    [predicted_label, accuracy2, decision_values] = svmpredict([ones(size(P,1)/2,1); zeros(size(N,1)/2,1)],double([P(1:size(P,1)/2,:);N(1:1:size(N,1)/2,:)]), model , '-b 1');
    current_accuracy = (accuracy1(1)+accuracy2(1))/2;
    fprintf('G = %f, C= %f, accuracy = %f \n', G(i),C(i),current_accuracy);
    if current_accuracy>max_accuracy
        G_m = G(i);
        C_m = C(i);
    end
end

model = svmtrain([ones(size(P,1),1); zeros(size(N,1),1)], double([P(1:size(P,1),:);N(1:size(N,1),:)]) , ['-b 1 -g ' num2str(G_m) ' -c ' num2str(C_m)]);

end

function decision_values=testSVMmodel(L,model)

[predicted_label, accuracy, decision_values] = svmpredict(zeros(size(L,1),1), double(L), model , '-b 1');
decision_values = decision_values(:,1);
end

function F = calculateFeatures(E1,E2,E3)
F = [E1 E2 E3 (E1.^2 + E2.^2 + E3.^2) abs(E2./E3) abs(E1./E3) (abs(E3)-abs(E2))./(abs(E3)+abs(E2)) abs(E1)./sqrt(abs(E3.*E2))];
%F = [(E1.^2 + E2.^2 + E3.^2) abs(E2./E3) abs(E1./E3) (abs(E3)-abs(E2))./(abs(E3)+abs(E2)) abs(E1)./sqrt(abs(E3.*E2))];
end