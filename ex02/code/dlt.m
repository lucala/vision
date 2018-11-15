function [P] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function

[~, n] = size(xy);
A = [];
z = zeros(1,4);
for i=1:n
    tmp = XYZ(:,i)';
    top = -xy(1,i)*tmp;
    bot = xy(2,i)*tmp;
    %A = [A; [XYZ(:,i)' zeros(1,4) -xy(1,i)*XYZ(:,i)'; zeros(1,4) -XYZ(:,i) xy(2,i)*XYZ(:,i)]];
    A = [A; [tmp z top; z -tmp bot]];
end

[~,~,V] = svd(A);
P = V(:,end);
P = reshape(P,4,3)';
