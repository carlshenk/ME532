function [ S1 ] = similarity_matrix( A1 )
%SIMILARITY_MATRIX
% outputs S1 which is the similarity matrix of the rows of A1. S1(i,j) =
% similar_x(A(i,:), A(j,:)
% outputs 1 if xi == xj
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

