function f = fminGoldStandard(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

[K,~,~] = decompose(P);

sc = K(1,2);
a1 = K(1,1);
a2 = K(2,2);

%hom2cart
Pc = P*XYZ;
Pc = hom2cart(Pc')';

%compute squared geometric error
error = sum(sum((xy(1:2,:)-Pc).^2));

%compute cost function value
f = error + w*sc^2 + w*(a1-a2)^2;
end