% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences
%
% Output
% 	Fh 			Fundamental matrix with the det F = 0 constraint
% 	F 			Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)

    x1 = hom2cart(x1s');
    x2 = hom2cart(x2s');
    n = size(x1,1);
    
    %we set x2 = x_prime
    A = [x2(:,1).*x1(:,1) x2(:,1).*x1(:,2) x2(:,1) x2(:,2).*x1(:,1) x2(:,2).*x1(:,2) x2(:,2) x1(:,1) x1(:,2) repmat([1], n, 1)];
    [U,S,V] = svd(A);
    f = V(:,end);

    F = reshape(f,3,3)';

    [Uf,Sf,Vf] = svd(F);
    Sf(3,3) = 0;
    Fh = Uf*Sf*Vf';

end