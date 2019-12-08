clear all;

%generate some points
pts = rand_2D_points(100, 3, 10, .2);
figure
plot(pts(:,1), pts(:,2), 'x');
title('initial data');

%% Kmeans example
%plot some points
figure
hold on;

n_clusters = 3;
colors = {'b', 'r', 'g', 'm', 'k', 'y', 'c'};
[cent_belong_vec, centroids, coherence] = mykmeans(pts, n_clusters, 100);
for i = 1:n_clusters
   use_color = colors{mod(i, length(colors))+1};
   idx = cent_belong_vec == i;
   plot(pts(idx, 1), pts(idx, 2), [use_color 'x']);
    
end




%% MEan shift cluster example

bandwidth = 1.5;

fig = figure;
X = pts;
plot(X(:,1), X(:,2), 'r.', 'MarkerSize', 12);
hold on;
plot(X(:,1), X(:,2), 'bx');
hold off;
pause(.2);
a = myMeanShift(X, 80, bandwidth);
hold on;
ax = axis;
y = [ax(3):.01:ax(4)]';
x = [ax(1):.01:ax(2)]';
z = zeros(length(x), length(y));
for i = 1:length(x)
    for j = 1:length(y)
        z(i, j) = kernel_density([x(i) y(j)], X, bandwidth, 'gaus');
    end
end
contour(x,y,z')