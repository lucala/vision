function [ map, peaks ] = mshift( X, r )

[l,~] = size(X);
map = zeros(l,1);

peaks = [];
for j=1:l
    x = X(j,:);
    %find peak
    peak = peakfinder( X, reshape(x,1,3), r);

    if j==1
        peaks = [peaks; peak];
        map(1) = 1;
    else
        [sn,~] = size(peaks);
        d = repmat(peak,sn,1) - peaks;
        neighbour = find(sum(d.*d,2) < (r/2)^2);
        if ~isempty(neighbour)
            map(j) = neighbour(1);
        else 
            peaks = [peaks; peak];
            map(j) = size(peaks,1);
        end
    end
end

end