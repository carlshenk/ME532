% clear all

readData;

%divide users into training and validation data
user_t = users_c(1:end, :);
like_t = likeMatrix(1:end, :);



%2 -- cluster players
[u,s,v] = svd(users_c);
s_vals = diag(s);
plot(s_vals);
axis([0, 100, 0 60])

%how many centroids to use?
n_centroids = 5;

[cent_belong_vec, centroids, coherence] = mykmeans(user_t, n_centroids, 100);

%3 -- predict like matrix based on clustered data
%use similarity function to weight rating suggestion toward near neighboors
%https://en.wikipedia.org/wiki/Collaborative_filtering
A1 = user_t(cent_belong_vec == 1, :);
L1 = like_t(cent_belong_vec == 1, :);

% using no weighting function on average
meanRate = full(sum(L1)./sum(L1 > 0));
meanRate(isnan(meanRate)) = 0;
L1_est = full(L1);
for i = 1:size(L1,2)
gr = L1_est(:,i);
gr(gr == 0) = meanRate(i);
L1_est(:,i)= gr;

end

%weighted sum using collaborative filtering
[L1_weighted, err1] = weightSum(L1, similarity_matrix(A1));

%top 10 games recommended to user 15 using collaborative filtering +
%clustering
x = L1_weighted(15,:);
[~, ind] = sort(x);
ind(end:-1:end-10)
disp(norm(err1 - L1));

%top 10 games recommended to user 15 using cluster averaging
y = L1_est(15,:);
[~, ind1] = sort(y);
ind1(end:-1:end-10)
disp(norm(L1_est - L1));

%top 10 games recommended to user 15 using collaborative filtering, no
%clustering
[full_weighted, err2] = weightSum(like_t, similarity_matrix(user_t));
z = full_weighted(15,:);
[~, ind2] = sort(z);
ind2(end:-1:end-10)
disp(norm(err2 - like_t));


