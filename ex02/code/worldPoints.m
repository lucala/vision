function [XYZ] = worldPoints()

%square size
s = 10;
% amount of x y z
%x = 7; y = 6; z = 9;
x = 10; y = 10; z = 16;

% x plane
res = [];
for j = 0:z
    for i = 0:x
        res = [res [i*s; 0; j*s; 1]];
    end
    for i = 1:y
        res = [res [0; i*s; j*s; 1]];
    end
end

XYZ = res;

end