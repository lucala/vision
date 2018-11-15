function [ K, R, C ] = decompose(P)
%decompose P into K, R and t
M = P(:,1:3);
[Rinv,Kinv] = qr(inv(M));
R = inv(Rinv);
K = inv(Kinv);

R = R*K(end,end);
K = K/K(end,end);

[~,~,V] = svd(P);
C = V(:,end);
C = C(1:3)./C(4);
end