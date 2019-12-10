function [out] = kernel_density(xi, X, bw, flag)
% function has ability to pick which kernel density to use -- either flat
% or gaussian
%if flag == flat, uses flat. otherwise uses gaussian kernel.
 tmp = euc_dist(xi, X); 

 if(strcmp(flag, 'flat'))
out = sum(kernel_flat(tmp, bw));
 else
 out = sum(kernel_gaussian(tmp, bw));   
 end

end