% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(X, K)

[l,z] = size(X);
mu = zeros(K,z);
for i=1:K
    mu(i,:) = X(datasample(1:l,1),:);
end

end