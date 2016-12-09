function val=hdaf(n,c_nk,x)  
%n : degree of the polinomial approximation to the exponential
%sigma: -------
%x: values to compute the laplacian 

%changing the values of x 
x = x*c_nk^2;

%computing coefficients for taylor expansion of exponential to degree n
coefficients = [factorial(n:-1:1) 1];  
coefficients = 1./coefficients;

%evaluate the taylor expansion of exponential to degree n
en = polyval(coefficients,x);

%evaluation of the filter
val=en.*exp(-x);
%val=exp(-x);
% val = en;

end
