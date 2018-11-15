function [K, R, t, error] = runDLT(xy, XYZ)
[~,n] = size(XYZ);

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy,XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%denormalize camera matrix
P = inv(T)*P_normalized*U;

hom = P*XYZ;
hom = hom2cart(hom')';

%factorize camera matrix in to K, R and t
[K,R,C] = decompose(P);
t = -R*C;

%compute reprojection error
%error = abs(hom2cart(xy')'-hom);
error = sum(sqrt(sum((hom2cart(xy')'-hom).^2,1)))/n;

%plot reprojected points
points = worldPoints();
%projPoints = [R, t]*[0;50;80;1];
projPoints = [R, t]*points;
projPoints = K*projPoints;
projPoints = hom2cart(projPoints')';
hold on;
plot(hom(1,:), hom(2,:), 'ro')
plot(projPoints(1,:), projPoints(2,:), 'c+')
hold off;

end