% Compute the essential matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xn matrices
%
% Output
% 	Eh 			Essential matrix with the det F = 0 constraint and the constraint that the first two singular values are equal
% 	E 			Initial essential matrix obtained from the eight point algorithm
%

function [Eh, E] = essentialMatrix(x1s, x2s)

    x1 = hom2cart(x1s');
    x2 = hom2cart(x2s');
    n = size(x1,1);
    
    %we set x2 = x_prime
    A = [x2(:,1).*x1(:,1) x2(:,1).*x1(:,2) x2(:,1) x2(:,2).*x1(:,1) x2(:,2).*x1(:,2) x2(:,2) x1(:,1) x1(:,2) repmat([1], n, 1)];
    
    [U,S,V] = svd(A);
    e = V(:,end);

    E = reshape(e,3,3)';
    [Ue,Se,Ve] = svd(E);
    s = (Se(1,1)+Se(2,2))/2;
    Se = [s 0 0; 0 s 0; 0 0 0];
    Eh = Ue*Se*Ve';
end