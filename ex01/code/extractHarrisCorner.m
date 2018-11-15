% extract harris corner
%
% Input:
%   img           - n x m gray scale image
%   thresh        - scalar value to threshold corner strength
%   
% Output:
%   corners       - 2 x k matrix storing the keypoint coordinates
%   H             - n x m gray scale image storing the corner strength
function [corners, H, allcorners] = extractHarrisCorner(img)
 [n,m] = size(img);

 %blur to get rid of noise
 blur = fspecial('gaussian');
 img = imfilter(img,blur);
 
 %calculate gradients
 gx = zeros(n-1, m-1);
 gy = zeros(n-1, m-1);
 
 for i=2:m-1
    gx(1:(n-1),i) = (img(1:(n-1),i+1) - img(1:(n-1),i-1))/2;
 end
 for i=2:n-1
    gy(i,1:(m-1)) = (img(i+1,1:(m-1)) - img(i-1,1:(m-1)))/2;
 end

 %calculate for every pixel 2x2 matrix [I_x^2 I_x*I_y; I_x*I_y I_y^2]
 Ix2 = zeros(n-1, m-1);
 Ixy = zeros(n-1, m-1);
 Iy2 = zeros(n-1, m-1);
 
 Ix2 = gx.^2;
 Ixy = gx.*gy;
 Iy2 = gy.^2;


% calculate harris response in 3x3 patch around every pixel, the sum
% represents Harris matrix. K is the Harris response for every pixel.
 K = zeros(n,m);
 for i=2:n-2
     for j=2:m-2
        I11 = [Ix2(i-1,j-1) Ixy(i-1,j-1); Ixy(i-1,j-1) Iy2(i-1,j-1)];
        I12 = [Ix2(i-1,j) Ixy(i-1,j); Ixy(i-1,j) Iy2(i-1,j)];
        I13 = [Ix2(i-1,j+1) Ixy(i-1,j+1); Ixy(i-1,j+1) Iy2(i-1,j+1)];
        I21 = [Ix2(i,j-1) Ixy(i,j-1); Ixy(i,j-1) Iy2(i,j-1)];
        I22 = [Ix2(i,j) Ixy(i,j); Ixy(i,j) Iy2(i,j)];
        I23 = [Ix2(i,j+1) Ixy(i,j+1); Ixy(i,j+1) Iy2(i,j+1)];
        I31 = [Ix2(i+1,j-1) Ixy(i+1,j-1); Ixy(i+1,j-1) Iy2(i+1,j-1)];
        I32 = [Ix2(i+1,j) Ixy(i+1,j); Ixy(i+1,j) Iy2(i+1,j)];
        I33 = [Ix2(i+1,j+1) Ixy(i+1,j+1); Ixy(i+1,j+1) Iy2(i+1,j+1)];
        
        H = I11 + I12 + I13 + I21 + I22 + I23 + I31 + I32 + I33;

        K(i,j) = det(H)/trace(H);

     end
 end
 
 % set threshold at 99 percent quantile, the remaining values are the 1
 % percent highest responses
 thresh = quantile(K(:),0.99);
 check = true;
 corners = [];
 allcorners = [];

 %only take features which lie more than 4 pixels in the image as to not
 %conflict with 9x9 patch of descriptors. Inner loop computes non-maximum
 %suppression.
 for i=4:n-3
     for j=4:m-3
         if K(i,j) > thresh
             allcorners = [allcorners [i;j]];
             for u=-1:1
                 for v=-1:1
                    if K(i,j) < K(i+u,j+v)
                        check = false;
                    end
                 end
             end
             if(check == true)
                 corners = [corners [i;j]];
             end
             check = true;
         end
     end
 end

 H = K;
end