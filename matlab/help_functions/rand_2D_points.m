function [ points ] = rand_2D_points( npts, n_centroids,space, noise )
%RAND_2D_POINTS Summary of this function goes here
%   Detailed explanation goes here
  points = zeros(npts, 2);
  centroids = space*rand(n_centroids, 2)-.5; 
  
  for i = 1:npts
     centroid_assign = ceil(rand(1) * n_centroids); 
     points(i, 1) = noise*space*rand(1) + centroids(centroid_assign,1);
     points(i, 2) = noise*space*rand(1) + centroids(centroid_assign, 2);
      
  end

end

