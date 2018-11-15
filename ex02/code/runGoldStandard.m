function [K, R, t, error] = runGoldStandard(xy, XYZ)
[~,n] = size(XYZ);

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy,XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error
Pn = P_normalized;
pn = [Pn(1,:) Pn(2,:) Pn(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized, i/5);
end

pn = reshape(pn,4,3)';

%denormalize camera matrix
P = inv(T)*pn*U;

%factorize camera matrix in to K, R and t
[K,R,C] = decompose(P);
t = -R*C;

%compute reprojection error
hom = P*XYZ;
hom = hom2cart(hom')';
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
plot(projPoints(1,:), projPoints(2,:), 'g+')
hold off;

end