clear all

readData;

[u,s,v] = svd(users_c);
s_vals = diag(s);
plot(s_vals);
axis([0, 100, 0 60])