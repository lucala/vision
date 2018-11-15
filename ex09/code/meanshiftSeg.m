function [map, peak] = meanshiftSeg(img)
[xs,ys,zs] = size(img);
r = 0.03;
X = reshape(im2double(img), xs*ys, zs);

[map, peak] = mshift(X,r);

map = reshape(map, xs, ys);
end