% extract descriptor
%
% Input:
%   keyPoints     - detected keypoints in a 2 x n matrix holding the key
%                   point coordinates
%   img           - the gray scale image
%   
% Output:
%   descr         - w x n matrix, stores for each keypoint a
%                   descriptor. m is the size of the image patch,
%                   represented as vector
function descr = extractDescriptor(corners, img)  
 [~,n] = size(corners);
 descr = zeros(9*9,n);

 %descriptor of 9*9 patch organized [1 2 3; 4 5 6; 7 8 9] into column
 %vector
 for i=1:n
     pos = corners(:,i);
     w = img(pos(1)+(-4:4),pos(2)+(-4:4));
     descr(:,i) = w(:);
 end

 
end