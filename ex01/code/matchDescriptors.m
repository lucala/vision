% match descriptors
%
% Input:
%   descr1        - k x n descriptor of first image
%   descr2        - k x m descriptor of second image
%   thresh        - scalar value to threshold the matches
%   
% Output:
%   matches       - 2 x w matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, thresh)
    %k = 9*9 height of descriptor vector
    [~,n] = size(descr1);
    [~,m] = size(descr2);
    matches = [];
    %check every combination of descr1 and descr2 for best matches
    for i=1:n
        d1 = descr1(:,i);
        for j=1:m
            d2 = descr2(:,j);
            d = d1 - d2;
            ssd = dot(d,d);
            if ssd < thresh %only add mapping if ssd below threshold
                matches = [matches [i;j]];
            end
        end
    end
    
end