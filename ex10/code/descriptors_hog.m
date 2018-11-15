function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    w = cellWidth; % set cell dimensions
    h = cellHeight;

    descriptors = zeros(size(vPoints,1),nBins*4*4); % one histogram for each of the 16 cells
    patches = zeros(size(vPoints,1),4*w*4*h); % image patches stored in rows

    [grad_x,grad_y]=gradient(img);
    angles = atan2(grad_y,grad_x);
    angleSpace = linspace(-pi,pi,9);


for i = 1:size(vPoints,1)
        bins = [];
        tmp = vPoints(i,:);
        patch = img(tmp(1)-7:tmp(1)+8, tmp(2)-7:tmp(2)+8);
        patches(i,:) = patch(:)';
        anglePatch = angles(tmp(1)-7:tmp(1)+8, tmp(2)-7:tmp(2)+8);
        for u=1:4
            for v=1:4
                tmpAngle = anglePatch(1+(u-1)*cellWidth:u*cellWidth,1+(v-1)*cellHeight:v*cellHeight);
                bins = [bins histcounts(tmpAngle,angleSpace)];
            end
        end
        descriptors(i,:) = bins;
end

% use this for super super fast descriptor extraction!!
%[descriptors,~] = extractHOGFeatures(img, vPoints, 'CellSize', [w h],'BlockSize', [4 4], 'BlockOverlap', [0 0], 'NumBins', nBins);

end
