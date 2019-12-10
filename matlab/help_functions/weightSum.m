function [ L1_filled, err ] = weightSum( L1, S1 )
%WEIGHTSUM This function takes a sparse rating matrix L1 and fills in the
%columns with ratings from an S1 similarity matrix.
% inputs: L1: sparce matrix with user ratings as rows, games as columns

L1_filled = full(L1);
err = L1_filled;

%iterate over all games
for i = 1:size(L1,2)
    
    %xi == how all 53 users rated game i
     xi = full(L1(:,i));
     
     %now iterate over all players
   for j = 1:size(L1,1)

         %weight vector is row of similarity matrix
         weight_p1 = S1(j,:);
         %predict rating as weighted average of ratings of users in cluster
        predicted_rating= sum(xi.*weight_p1'./sum(weight_p1(xi ~=0)));
        err(j,i) = predicted_rating;
        if(L1(j,i) == 0)
           %only overwrite un-rated values
           L1_filled(j,i) = predicted_rating;  
            
        end        

       
       
   end 
end

L1_filled(isnan(L1_filled)) = 0;
err(isnan(err)) = 0;
end

