function [ d ] = euc_dist( pt1, pt2 )
%EUC_DIST assume pt1 and pt2 are nx1 row vectors
d = sqrt(sum((pt1-pt2).^2, 2));

end

