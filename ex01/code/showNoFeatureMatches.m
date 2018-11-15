%this function is called if the matchDescriptor function was not able to
%match any features given the threshold. It will plot the two images with
%their respective features.
function showNoFeatureMatches(img1, corner1, img2, corner2, fig)
    [sx, sy, sz] = size(img1);
    img = [img1, img2];
    
    corner2 = corner2 + repmat([sy, 0]', [1, size(corner2, 2)]);
    
    figure(fig), imshow(img, []);    
    hold on, plot(corner1(1,:), corner1(2,:), '+r');
    hold on, plot(corner2(1,:), corner2(2,:), '+r');    
end