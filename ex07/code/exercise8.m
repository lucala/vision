% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)
% add folder to path and call vl_setup;

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices
Kinv = inv(K);
[F, inliers] = ransacfitfundmatrix(fa(1:2, matches(1,:)), fb(1:2, matches(2,:)), 0.0001);
x1 = fa(1:2, matches(1,inliers));
x2 = fb(1:2, matches(2,inliers));

%draw epipolar geometry
figure(1),clf, imshow(img1, []); hold on, plot(x1(1,:), x1(2,:), '*r');
figure(2),clf, imshow(img2, []); hold on, plot(x2(1,:), x2(2,:), '*r');
x1s = cart2hom(x1')';
x2s = cart2hom(x2')';
figure(1)
for k = 1:size(x1,2)
    drawEpipolarLines(F'*x2s(:,k), img1);
end
figure(2)
for k = 1:size(x2,2)
    drawEpipolarLines(F*x1s(:,k), img2);
end

daInliers = da(:,matches(1,inliers));

E = K'*F*K;

x1_calibrated = Kinv*cart2hom(x1')';
x2_calibrated = Kinv*cart2hom(x2')';

Ps{1} = [eye(4)];
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);
%triangulate the inlier matches with the computed projection matrix
[XS, err] = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated);

showFeatureMatches(img1, x1, img2, x2, 20);
%% Add an addtional view of the scene 

imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
[m2, scores] = vl_ubcmatch(daInliers, dc);

x3 = fc(1:2, m2(2,:));

x3_calibrated = Kinv*cart2hom(x3')';
%run 6-point ransac

[P, newInliers] = ransacfitprojmatrix(x3_calibrated, XS(:,m2(1,:)), 0.05);
R = P(1:3,1:3)*Kinv;
if det(R) < 0
    P = P*(-1);
    P(3,4) = P(3,4)*(-1);
end
Ps{3} = P;
x1Inliers = x1(:, m2(1,newInliers));

%showFeatureMatches(img1, x1(1:2, m2(1,:)), img3, fc(1:2, m2(2,:)), 21);
showFeatureMatches(img1, x1Inliers, img3, fc(1:2, m2(2,newInliers)), 21);

x3_calibrated = x3_calibrated(:,newInliers);
x1_calibrated1 = x1_calibrated(:,m2(1,newInliers));


%triangulate the inlier matches with the computed projection matrix
[XS2, err] = linearTriangulation(Ps{1}, x1_calibrated1, Ps{3}, x3_calibrated);
% %% Add more views...
imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[fc, dc] = vl_sift(img4);

%match against the features from image 1 that where triangulated
[m2, scores] = vl_ubcmatch(daInliers, dc);

x4 = fc(1:2, m2(2,:));

x4_calibrated = Kinv*cart2hom(x4')';
%run 6-point ransac

[P, newInliers] = ransacfitprojmatrix(x4_calibrated, XS(:,m2(1,:)), 0.05);
R = P(1:3,1:3)*Kinv;
if det(R) < 0
    P = P*(-1);
    P(3,4) = P(3,4)*(-1);
end
Ps{4} = P;
x1Inliers = x1(:, m2(1,newInliers));

%showFeatureMatches(img1, x1(1:2, m2(1,:)), img4, fc(1:2, m2(2,:)), 22);
showFeatureMatches(img1, x1Inliers, img4, fc(1:2, m2(2,newInliers)), 22);

x4_calibrated = x4_calibrated(:,newInliers);
x1_calibrated1 = x1_calibrated(:,m2(1,newInliers));


%triangulate the inlier matches with the computed projection matrix
[XS3, err] = linearTriangulation(Ps{1}, x1_calibrated1, Ps{4}, x4_calibrated);

imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[fc, dc] = vl_sift(img5);

%match against the features from image 1 that where triangulated
[m2, scores] = vl_ubcmatch(daInliers, dc);

x5 = fc(1:2, m2(2,:));

x5_calibrated = Kinv*cart2hom(x5')';
%run 6-point ransac

[P, newInliers] = ransacfitprojmatrix(x5_calibrated, XS(:,m2(1,:)), 0.05);
R = P(1:3,1:3)*Kinv;
if det(R) < 0
    P = P*(-1);
    P(3,4) = P(3,4)*(-1);
end
Ps{5} = P;
x1Inliers = x1(:, m2(1,newInliers));

%showFeatureMatches(img1, x1(1:2, m2(1,:)), img5, fc(1:2, m2(2,:)), 23);
showFeatureMatches(img1, x1Inliers, img5, fc(1:2, m2(2,newInliers)), 23);

x5_calibrated = x5_calibrated(:,newInliers);
x1_calibrated1 = x1_calibrated(:,m2(1,newInliers));


%triangulate the inlier matches with the computed projection matrix
[XS4, err] = linearTriangulation(Ps{1}, x1_calibrated1, Ps{5}, x5_calibrated);

%% Plot stuff

fig = 10;
figure(fig);

%use plot3 to plot the triangulated 3D points
hold on;
scatter3(XS(1,:),XS(2,:),XS(3,:));
scatter3(XS2(1,:),XS2(2,:),XS2(3,:));
scatter3(XS3(1,:),XS3(2,:),XS3(3,:));
scatter3(XS4(1,:),XS4(2,:),XS4(3,:));

%draw cameras
drawCameras(Ps, fig);

axis([-1 2 -1 2 -1 3]);
hold off;