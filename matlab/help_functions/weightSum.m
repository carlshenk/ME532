function [ L1_filled, err ] = weightSum( L1, S1 )
%WEIGHTSUM Summary of this function goes here
%   Detailed explanation goes here

L1_filled = full(L1);
err = L1_filled;

for i = 1:size(L1,2)
    
    %xi == how all 53 users rated game i
     xi = full(L1(:,i));
     
   for j = 1:size(L1,1)

         weight_p1 = S1(j,:);
        predicted_rating= sum(xi.*weight_p1'./sum(weight_p1(xi ~=0)));
        err(j,i) = predicted_rating;
        if(L1(j,i) == 0)
            
            
           L1_filled(j,i) = predicted_rating;  
            
        end        

       
       
   end 
end

L1_filled(isnan(L1_filled)) = 0;
err(isnan(err)) = 0;
end

