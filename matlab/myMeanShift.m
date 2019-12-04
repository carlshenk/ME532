function [Xc] = myMeanShift(X, niter, bw)
if(nargin < 2)
    niter = 100;
end
eps =.001;
Xc = X;
for i = 1:niter
    Xc1 = Xc;
    for j = 1:length(X)
        Xc(j, :) = shiftPts(Xc(j,:), X, 'flat', bw);
    end 
    plot(X(:,1), X(:,2), '.', 'MarkerSize', 12);
    hold on;
    
    plot(Xc(:,1), Xc(:,2), 'x');
    hold off;
    pause(.1);
    if(norm(Xc1-Xc) < eps)
        disp(['Iteration stopped at convergence at step: ' num2str(i) ]);
        return;
    end
    
    
end

end


function [ sh ] = shiftPts( p, origpts, ker_opt, bw )
if(nargin < 1)
    ker_opt = 'flat';
    bw = 1;
end

sh = zeros(1, size(origpts,2));
sf = 0;

for i = 1:length(origpts)
    pt = origpts(i,:);
    d = sqrt(sum((pt - p).^2));
    if(strcmp(ker_opt, 'flat'))
        weight = kernel_flat(d, bw);
    else
        weight = kernel_gaussian(d, bw);
    end
    
    sh = sh + pt*weight;
    sf = sf + weight;
    
end

if(sf ~= 0)
sh = sh/sf;
else
    sh = pt;
end

end






