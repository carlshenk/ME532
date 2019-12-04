function [ closest_centroid_vec, centroids, c_new ] = mykmeans( data, ncentroids, max_iter )
%MYKMEANS Summary of this function goes here
%   Detailed explanation goes here
if(nargin < 3)
    max_iter = 100;
end

closest_centroid_vec = zeros(length(data), 1);
temp_dist_vec = zeros(length(data), ncentroids);

%assume centroids is an int -- first pick randomly
centroids = zeros(ncentroids, 2);
for i = 1:ncentroids
   use_pt = ceil(rand(1)*length(data));
   centroids(i,:) = data(i,:);
end

c_new = 0;

for i = 1:max_iter
    c_old = c_new;
    c_new_acc = 0;
    for j = 1:length(data)
        for k = 1:ncentroids
            temp_dist_vec(j,k) = euc_dist(data(j,:), centroids(k,:));
        end
        [~, closest_centroid_vec(j)] = min(temp_dist_vec(j,:));
         
    end
    
    %update centroids and calculate coherence
    for k = 1:ncentroids
        belong_indx = closest_centroid_vec == k;
        temp_pts = data(belong_indx,:);
        centroids(k,:) = mean(temp_pts);
        
        c_new_acc = c_new_acc + norm(temp_pts - centroids(k,:));
    end
    
    %calculate coherence
    c_new = c_new_acc;
    
    if(c_new == c_old)
        return;
    end
    
end

