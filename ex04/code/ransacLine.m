function [k, b] = ransacLine(data, dim, iter, threshDist, inlierRatio)
% data: a 2xn dataset with #n data points
% num: the minimum number of points. For line fitting problem, num=2
% iter: the number of iterations
% threshDist: the threshold of the distances between points and the fitting line
% inlierRatio: the threshold of the number of inliers

number = size(data,2); % Total number of points
bestInNum = 0;         % Best fitting line with largest number of inliers
k=0; b=0;              % parameters for best fitting line
nrTotalInliers = round(inlierRatio*number);

for i=1:iter
    % Randomly select 2 points
    y = randsample(number, 2);
    p1 = data(:,y(1));
    p2 = data(:,y(2));
    % Compute the distances between all points with the fitting line
    coef = polyfit([p1(1) p2(1)],[p1(2) p2(2)],1);
    y = coef*[data(1,:)' repmat([1], number, 1)]';
    d = abs(data(2,:)-y);
    % Compute the inliers with distances smaller than the threshold
    inliers = find(d<=threshDist);
    nrInliers = length(inliers);
    % Update the number of inliers and fitting model if better model is found
    if (nrInliers > bestInNum) && (nrInliers >= nrTotalInliers)
        k = coef(1);
        b = coef(2);
        bestInNum = nrInliers;
    end
end

end
