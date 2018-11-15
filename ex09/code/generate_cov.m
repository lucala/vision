% Generate initial values for the K
% covariance matrices

function c = generate_cov(X, K)
c = cell(K,1);
tmp = max(double(X(:)));

for i=1:K
    tmpVec = tmp*ones(1,3);
    c{i} = diag(tmpVec);
end

end