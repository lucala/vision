clickPoints = false;


%dataset = 0;   % Your pictures
% dataset = 1; % ladybug
 dataset = 2; % rect

% image names
if(dataset==0)
    imgName1 = '';
    imgName2 = '';
elseif(dataset==1)
    imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png';
    imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';
elseif(dataset==2)
    imgName1 = 'images/rect1.jpg';
    imgName2 = 'images/rect2.jpg';
end

% read in images
img1 = im2double(imread(imgName1));
img2 = im2double(imread(imgName2));

[pathstr1, name1] = fileparts(imgName1);
[pathstr2, name2] = fileparts(imgName2);

cacheFile = [pathstr1 filesep 'matches_' name1 '_vs_' name2 '.mat'];

% get point correspondences
if (clickPoints)
    [x1s, x2s] = getClickedPoints(img1, img2);
    save(cacheFile, 'x1s', 'x2s', '-mat');
else
    load('-mat', cacheFile, 'x1s', 'x2s');
end

% show clicked points
figure(1),clf, imshow(img1, []); hold on, plot(x1s(1,:), x1s(2,:), '*r');
figure(2),clf, imshow(img2, []); hold on, plot(x2s(1,:), x2s(2,:), '*r');


%% YOUR CODE ...
[x1sn, T1] = normalizePoints2d(x1s);
[x2sn, T2] = normalizePoints2d(x2s);
% estimate fundamental matrix
[Fh, F] = fundamentalMatrix(x1sn, x2sn);
F = T2'*F*T1;
Fh = T2'*Fh*T1;

[Uf,Sf,Vf] = svd(F);
epipoleF1 = hom2cart(Vf(:,end)')';
epipoleF2 = hom2cart(Uf(:,end)')';
[Ufh,Sfh,Vfh] = svd(Fh);
epipoleFh1 = hom2cart(Vfh(:,end)')';
epipoleFh2 = hom2cart(Ufh(:,end)')';

% draw epipolar lines in img 1
figure(1)
for k = 1:size(x1s,2)
    drawEpipolarLines(Fh'*x2s(:,k), img1);
end
% draw epipole
 plot(epipoleFh1(1),epipoleFh1(2),'g*');
% plot(epipoleF1(1),epipoleF1(2),'g*');

% draw epipolar lines in img 2
figure(2)
for k = 1:size(x2s,2)
    drawEpipolarLines(Fh*x1s(:,k), img2);
end
% draw epipole
 plot(epipoleFh2(1),epipoleFh2(2),'g*');

%show epipolar line for a new point
image_to_clic=1;
figure(image_to_clic)
newp=ginput(1);newp=[newp 1]';
plot(newp(1), newp(2), '*g')
figure(3-image_to_clic)
if image_to_clic==1
    figure(2);drawEpipolarLines(Fh*newp, img2);
else
    figure(1);drawEpipolarLines(Fh'*newp, img1);
end
