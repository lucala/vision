function [xyn, XYZn, T, U] = normalization(xy, XYZ)
[~, n] = size(xy);

xy_hom = xy;
XYZ_hom = XYZ;
xy = xy(1:end-1,:);
XYZ = XYZ(1:end-1,:);

%data normalization
%first compute centroid
xy_centroid = mean(xy,2);
XYZ_centroid = mean(XYZ,2);

%then, compute scale
%for the distance we need to first remove the centroid to center the data
dist_xy = sqrt(sum((xy-repmat(xy_centroid,[1 n])).^2,1));
dist_XYZ = sqrt(sum((XYZ-repmat(XYZ_centroid,[1 n])).^2,1));
w_xy = sqrt(2)/mean(dist_xy);
w_XYZ = sqrt(3)/mean(dist_XYZ);

%create T and U transformation matrices
%first translate then scale
T = [w_xy 0 0; 0 w_xy 0; 0 0 1]*[1 0 -xy_centroid(1); 0 1 -xy_centroid(2); 0 0 1];
U = [w_XYZ 0 0 0; 0 w_XYZ 0 0; 0 0 w_XYZ 0; 0 0 0 1]*[1 0 0 -XYZ_centroid(1); 0 1 0 -XYZ_centroid(2); 0 0 1 -XYZ_centroid(3); 0 0 0 1];

%and normalize the points according to the transformations
xyn = T*xy_hom;
XYZn = U*XYZ_hom;

end