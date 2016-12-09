function TestenhanceV()

relpath = 'E:\RECONSTRUCTIONS\Diadem\DataSet5\Olfactory_Fibers_OP_3';
fname = 'Olfactory_Fibers_OP_3';
fact = 0.5;

compute_LP(relpath,fname,[0.2 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7]);

end

function enhanceV(relpath,fname,fact,output_n)
compute_Laplacian(relpath,fname, fact,60);

V = RAWfromMHD(fname,[],relpath);
L = RAWfromMHD(strcat(fname,'_LP_Lap_',num2string(fact),'_F'),[],relpath);

V = single(V).*L;

I = V>0;
V(I) = -sqrt(V(I));

V(~I) =  sqrt(abs(V(~I)));

%normalize
I = V==0;
V(~I) = 255*V(~I)/max(V(:));

WriteRAWandMHD(V,output_n,relpath);


end