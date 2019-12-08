function [out] = kernel_density(xi, X, bw, flag)
 tmp = euc_dist(xi, X); 

 if(strcmp(flag, 'flat'))
out = sum(kernel_flat(tmp, bw));
 else
 out = sum(kernel_gaussian(tmp, bw));   
 end

end