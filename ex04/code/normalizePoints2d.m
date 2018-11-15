% Normalization of 2d-pts
% Inputs: 
%           x1s = 2d points
% Outputs:
%           nxs = normalized points
%           T = normalization matrix
function [nxs, T] = normalizePoints2d(x1s)

[~, n] = size(x1s);
xy = hom2cart(x1s')';
xy_hom = cart2hom(xy')';

%data normalization
%first compute centroid
xy_centroid = mean(xy,2);

%then, compute scale
%for the distance we need to first remove the centroid to center the data
dist_xy = sqrt(sum((xy-repmat(xy_centroid,[1 n])).^2,1));

w_xy = sqrt(2)/mean(dist_xy);

%create T and U transformation matrices
%first translate then scale
T = [w_xy 0 0; 0 w_xy 0; 0 0 1]*[1 0 -xy_centroid(1); 0 1 -xy_centroid(2); 0 0 1];

%and normalize the points according to the transformations
nxs = T*xy_hom;
    
end
