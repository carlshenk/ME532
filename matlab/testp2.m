clear all
addpath(genpath('../'));

%% 1. READ IN DATA
% This function reads in the data from the json format used in the
% GameHaven database. It does not need editing.
rating_density = .5;
readData;

%% readData.m function outputs user matrix and sparse ratings matrix.
%user_t = matrix of users -- 500 x 109 -- 500 users with 109 attributes
% attributes are in columns. 
user_t = users_c(1:end, :);

%% like_t -- ratings matrix. 500 users rating 500 games. like(i,j) is how user i rated game j.
% rows are users, columns are games. 
like_t = likeMatrix(1:end, :);

%% Use SVD on User Attributes to determine level of clustering needed on data
[u,s,v] = svd(users_c');
s_vals = diag(s);
plot(s_vals);
axis([0, 100, 0 60])

% Determine number of centroids based on singular values
n_centroids = 5;

% Run the k-means algorithm to determine clusters
[cent_belong_vec, centroids, coherence] = mykmeans(user_t, n_centroids, 100);

%% Estimate Ratings matrix with 4 different methods
% Method 1: missing game rating = unweighted average of all members in cluster
% Method 2: missing game rating = weighted average of cluster members based on similarity
% Method 3: missing game rating = unweighted average of all users
% Method 4: missing game rating = weighted average of all users based on similarity.

%% Methods 1 and 2 -- for example let's use cluster 1. 
% Pull out user attributes and ratings for people in cluster 1. 
A1 = user_t(cent_belong_vec == 1, :);
L1 = like_t(cent_belong_vec == 1, :);

%% Method 1: Unweighted Average of all members in cluster becomes estimated rating.
% L1_est_error is a matrix that compares the estimated ratings against the
% actual ratings.
meanRate = full(sum(L1)./sum(L1 > 0));  %average rating of all people in cluster who had a rating
meanRate(isnan(meanRate)) = 0;
L1f = full(L1);
L1_est_error = full(L1);
L1_est = full(L1);
tic
for i = 1:size(L1,2)    % Loop over all games
gr = L1f(:,i);          % vector where gr(i) is how user i rated game
gr(gr == 0) = meanRate(i);   % assign average rating to all elements that have 0.
L1_est(:,i)= gr;        % estimated rating vector for game i 

gr = L1f(:,i);
gr(gr ~= 0) = meanRate(i);   % for error tracking, set only values that have been assigned to the average
L1_est_error(:,i) = gr;
end
t1 = toc;
%top 10 games recommended to user 15 using cluster averaging
y = L1_est(15,:);
[~, ind1] = sort(y);
disp('Top 10 games for user 15 in cluster 1 using Method 1: ');
ind1(end:-1:end-9)
disp('norm of error in prediction matrix using Method 1: ');
disp(norm(L1_est_error - L1));
disp(['Algorithm 1 took: ' num2str(t1) 's']);

%% Method 2: weighted sum using collaborative filtering in cluster
tic;
[L1_weighted, err1] = weightSum(L1, similarity_matrix(A1));
t2 = toc;
%top 10 games recommended to user 15 using collaborative filtering +
%clustering
x = L1_weighted(15,:);
disp('Top 10 games for user 15 in cluster 1 using Method 2: ');
[~, ind] = sort(x);
ind(end:-1:end-10)
disp('norm of error in prediction matrix using Method 2: ');
disp(norm(err1 - L1_weighted));
disp(['Algorithm 2 took: ' num2str(t2) 's']);

%% Method 3: Unweighted Average without clustering
% Basically the same as method 1, only we use the rating matrix instead of
% the clustered one.
F1 = like_t;
meanRate = full(sum(F1)./sum(F1 > 0));  %average rating of all people in cluster who had a rating
meanRate(isnan(meanRate)) = 0;
L1f = full(F1);
L1_est_error = full(F1);
L1_est = full(F1);
tic
for i = 1:size(F1,2)    % Loop over all games
gr = L1f(:,i);          % vector where gr(i) is how user i rated game
gr(gr == 0) = meanRate(i);   % assign average rating to all elements that have 0.
L1_est(:,i)= gr;        % estimated rating vector for game i 

gr = L1f(:,i);
gr(gr ~= 0) = meanRate(i);   % for error tracking, set only values that have been assigned to the average
L1_est_error(:,i) = gr;
end
t3 = toc;

%% Top 10 games recommended to user 15 in cluster 1 using unweighted average without clusters -- Method 3
% since we are looking at user 15 in cluster 1, need to pull that info out
% of the matrix
L1_est1 = L1_est(cent_belong_vec == 1, :); 
L1_est_error1 = L1_est_error(cent_belong_vec == 1, :);
y = L1_est1(15,:);
[~, ind3] = sort(y);
disp('Top 10 games for user 15 in cluster 1 using Method 3: ');
ind3(end:-1:end-9)
disp('norm of error in prediction matrix using Method 3: ');
disp(norm(L1_est_error1 - L1));
disp(['Algorithm 3 took: ' num2str(t3) 's']);


%% Method 4: top 10 games recommended to user 15 using collaborative filtering, no
%clustering
tic;
[full_weighted, err2] = weightSum(like_t, similarity_matrix(user_t));
t4 = toc;

L_full_weighted_c1 = full_weighted(cent_belong_vec == 1, :);
err2_weighted_c1 = err2(cent_belong_vec == 1, :);

z = L_full_weighted_c1(15,:);
[~, ind2] = sort(z);
disp('Top 10 games for user 15 in cluster 1 using Method 4: ');
ind2(end:-1:end-10)
disp('norm of error in prediction matrix using Method 3: ');
disp(norm(L_full_weighted_c1 - err2_weighted_c1));
disp(['Algorithm 4 took: ' num2str(t4) 's']);

