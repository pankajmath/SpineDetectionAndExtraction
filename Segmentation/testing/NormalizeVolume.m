function NormalizeVolume
%function to normalize the intensity of a volume
relpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet5\Olfactory_Fibers_OP_2';
fname = 'Olfactory_Fibers_OP_2';
[V, spacingOut] = RAWfromMHD(fname,[],relpath); V = single(V);

V = log(V+1);

WriteRAWandMHD(V,[fname '_Log'],relpath,spacingOut);



end