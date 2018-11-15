function [ peak ] = peakfinder( X, x, r )
[l,~] = size(X);
peak = zeros(1,3);
%find peak
while(true)
    tmpX = X - repmat(x,l,1);
    tmp = tmpX.*tmpX;
    check = sum(tmp,2);
    meanx = X(check <= r*r,:);
    if sum(meanx)==0
        break;
    end
    meanx = mean(meanx,1);
    if meanx-x == zeros(1,3)
        peak = meanx;
        break;
    end

    x = meanx;
end

end
