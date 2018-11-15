% =========================================================================
% Exercise 4
% =========================================================================

%don't forget to initialize VLFeat

%Load images
imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png';
imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';

img1 = single(rgb2gray(imread(imgName1)));
img2 = single(rgb2gray(imread(imgName2)));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);
[matches, scores] = vl_ubcmatch(da, db);

%show matches
showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);

% =========================================================================

%run 8-point RANSAC
[inliers1, inliers2, outliers1, outliers2, M, F] = ransac8pF(fa(1:2, matches(1,:)), fb(1:2, matches(2,:)), 10);

%show inliers and outliers
plot(inliers1(1,:), inliers1(2,:), 'og');
plot(inliers2(1,:)+repmat(size(img1,2),1,size(inliers2,2)), inliers2(2,:), 'og');
corner1 = inliers1;
corner2 = inliers2;
sy = size(img1,2);
corner2 = corner2 + repmat([sy, 0]', [1, size(corner2, 2)]);
plot([corner1(1,:); corner2(1,:)], [corner1(2,:); corner2(2,:)], 'g');
%plot(outliers1(1,:), outliers1(2,:), 'or');
%plot(outliers2(1,:)+repmat(size(img1,2),1,size(outliers2,2)), outliers2(2,:), 'or');
%showFeatureMatches(img1, inliers1, img2, inliers2, 20);

%show number of iterations needed
M
%show inlier ratio
nrInliers = length(inliers1)
inlierRatio = length(inliers1)/(length(inliers1)+length(outliers1))
%and check the epipolar geometry of the computed F


% =========================================================================