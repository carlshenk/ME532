function [out] = kernel_flat(d, bw)
    out = zeros(size(d));
    idx = abs(d) <= bw;
    out(idx) = 1./(2*bw);
end