clickPoints = false;

% dataset = 0;   % Your pictures
% dataset = 1; % ladybug
 dataset = 2; % rect

% image names
if(dataset==0)
    imgName1 = '';
    imgName2 = '';
    
    % Your camera calibration
    K = [];

elseif(dataset==1)
	imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png';
	imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';

	K = [130.5024      0  500.0005
	      0  130.5024  372.3164
	      0         0    1.0000];
elseif(dataset==2)
	imgName1 = 'images/rect1.jpg';
	imgName2 = 'images/rect2.jpg';

	K = [  	1653.5  0    	0982.7;
			0    	1655.3 	0725.4;
			0.0		0.0		1.0 ];
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
figure(1),hold off, imshow(img1, []); hold on, plot(x1s(1,:), x1s(2,:), '*r');  
figure(2),hold off, imshow(img2, []); hold on, plot(x2s(1,:), x2s(2,:), '*b');


%% YOUR CODE ...
iK = inv(K);

nnx1s = iK*x1s;
nnx2s = iK*x2s;

[nnx1s,T1] = normalizePoints2d(nnx1s);
[nnx2s,T2] = normalizePoints2d(nnx2s);

% estimate fundamental matrix
[Eh, E] = essentialMatrix(nnx1s, nnx2s);

% plot cameras
P = decomposeE(T2'*E*T1,iK*x1s,iK*x2s);

E = T2'*E*T1;
Eh = T2'*Eh*T1;

Eh = iK'*Eh*iK;
E = iK'*E*iK;

% compute the corresponding epipolar lines from F=K_inv'*E*K_inv
% draw epipolar lines in img 1
figure(1)
for k = 1:size(x1s,2)
     drawEpipolarLines(Eh'*x2s(:,k), img1);
end
% draw epipolar lines in img 2
figure(2)
for k = 1:size(x2s,2)
     drawEpipolarLines(Eh*x1s(:,k), img2);
end


