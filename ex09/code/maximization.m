function [mu, var, alpha] = maximization(P, X)

K = size(P,2);
[l,z] = size(X);
alpha = sum(P,1)/l;
var = cell(K,1);
mu = zeros(K,z);

for i=1:K
   mu(i,:) = (X'*P(:,i))./sum(P(:,i),1)';
   t = zeros(3,3);
   for j=1:l
      d = X(j,:)-mu(i,:); 
      t = P(j,i)*(d'*d) + t;
   end
   var{i} = 1/sum(P(:,i),1) * t;
end

end