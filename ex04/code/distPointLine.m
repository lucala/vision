function d = distPointLine( point, line )
% d = distPointLine( point, line )
% point: inhomogeneous 2d point (2-vector)
% line: 2d homogeneous line equation (3-vector)

A = line(1);
B = line(2);
C = line(3);
x = point(1);
y = point(2);

d = abs(A*x + B*y + C)/(sqrt(A^2 + B^2));

end