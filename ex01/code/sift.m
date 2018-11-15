%called with 2 grayscale images, computes sift features and descriptors
%use threshold to filter for uniqueness, same as for Harris corners

function [matches] = sift(img1, img2, imgBW1, imgBW2, threshFeatures, threshMatch, fig)

%compute sift keypoints and descriptors
[k1,d1] = vl_sift(single(imgBW1),'PeakThresh',threshFeatures);
[k2,d2] = vl_sift(single(imgBW2),'PeakThresh',threshFeatures);

%find matches between the 2 images
[matches, scores] = vl_ubcmatch(d1, d2, threshMatch);

%plot results of sift
[sx, sy, sz] = size(img1);
img = [img1, img2];
    
%only need x,y coordinates of keypoints
k1 = k1(1:2, :);
k2 = k2(1:2, :);
k1 = k1(:, matches(1,:));
k2 = k2(:, matches(2,:));

k2 = k2 + repmat([sy, 0]', [1, size(k2, 2)]);
figure(fig), imshow(img, []);    
hold on, plot(k1(1,:), k1(2,:), '+r');
hold on, plot(k2(1,:), k2(2,:), '+r');   
    
figure(fig+1), imshow(img, []);    
hold on, plot(k1(1,:), k1(2,:), '+r');
hold on, plot(k2(1,:), k2(2,:), '+r');    
hold on, plot([k1(1,:); k2(1,:)], [k1(2,:); k2(2,:)], 'b');    
end