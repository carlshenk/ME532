function [out] = kernel_gaussian(d, bw)
%     out = exp(-.5*d.^2)/(2*pi).^(bw/2);
    out = 1/(bw*sqrt(2*pi)) * exp(-.5*(d/bw).^2);
end