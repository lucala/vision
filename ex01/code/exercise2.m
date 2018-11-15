% Exercise 3
%
close all;

%
% COMMENT/UNCOMMENT following lines to select image
%

%default images
 IMG_NAME1 = 'images/I1.jpg';
 IMG_NAME2 = 'images/I2.jpg';

%own images1
% IMG_NAME1 = 'images/cv1.jpg';
% IMG_NAME2 = 'images/cv2.jpg';

%own images2
% IMG_NAME1 = 'images/cv1.jpg';
% IMG_NAME2 = 'images/cv2.jpg';


%threshold dependent on image
%I1/I2=0.02,SW1/SW2=0.3, CV1/CV2=0.45
switch IMG_NAME1
    case 'images/I1.jpg'
        thresh = 0.02;
    case 'images/sw1.jpg'
        thresh = 0.3;
    case 'images/cv1.jpg'
        thresh = 0.45;
end
    
% read in image
img1 = im2double(imread(IMG_NAME1));
img2 = im2double(imread(IMG_NAME2));

img1 = imresize(img1, 0.5);
img2 = imresize(img2, 0.5);

% convert to gray image
imgBW1 = rgb2gray(img1);
imgBW2 = rgb2gray(img2);


% Task 3.1 - extract Harris corners
 [corners1, H1, allcorners1] = extractHarrisCorner(imgBW1');
 [corners2, H2, allcorners2] = extractHarrisCorner(imgBW2');

% show images with Harris corners
showImageWithCorners(img1, allcorners1, 8);
showImageWithCorners(img2, allcorners2, 9); 
 
% show images with Harris corners using non maximum suppression
showImageWithCorners(img1, corners1, 10);
showImageWithCorners(img2, corners2, 11);

% Task 3.2 - extract your own descriptors
 descr1 = extractDescriptor(corners1, imgBW1');
 descr2 = extractDescriptor(corners2, imgBW2');

% Task 3.3 - match the descriptors
 matches = matchDescriptors(descr1, descr2, thresh);
 
% In case match descriptors does not find any matches with the given
% threshold just plot the features
 if size(matches) == 0
    showNoFeatureMatches(img1, corners1, img2, corners2, 15);
 else
    showFeatureMatches(img1, corners1(:, matches(1,:)), img2, corners2(:, matches(2,:)), 20);
 end

% Task 1.4 SIFT features
 sift(img1, img2, imgBW1, imgBW2, 0.02, 7, 40);