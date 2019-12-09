function [ x ] = similar_x( a,b )
%SIMILAR_X outputs x dot y over norm x times norm y
x = dot(a,b)/norm(a)/norm(b);

end

