function [ S1 ] = similarity_matrix( A1 )
%SIMILARITY_MATRIX Summary of this function goes here
%   Detailed explanation goes here
    S1 = zeros(size(A1,1));
for i = 1:size(A1,1)
    %here we're working on user i
    xi = A1(i,:);
   for j = i:size(A1,1);
       if i == j
           S1(i,j) = 1;
           continue;
       end
       xj = A1(j,:);
       S1(i,j) = similar_x(xi,xj);
       S1(j,i) = S1(i,j);
       
   end 
end


end

