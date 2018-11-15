function P = expectation(mu,var,alpha,X)
K = length(alpha);
N = size(X,1);
g = zeros(N,K);

for j=1:N  
    s = 0;
    for i= 1:K
        d = X(j,:) - mu(i,:);
        sigma = var{i};
        p = 1/((2*pi)^(3/2)*sqrt(det(sigma))) * exp(-0.5*d*(sigma^-1)*d');
        g(j,i) = alpha(i)*p;
        s = s + g(j,i);
    end
    
    g(j,:) = g(j,:)./s;
end

P = g;
end