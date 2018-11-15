function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos, sigmaPos] = computeMeanStd(vBoWPos);
[muNeg, sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words


    p = normpdf(histogram,muPos,sigmaPos);
    p = p(~isnan(p));
    ptotal = sum(log(p));

    n = normpdf(histogram,muNeg,sigmaNeg);
    n = n(~isnan(n));
    ntotal = sum(log(n));

    
    %dec = ptotal/(ptotal+ntotal);
    label = ptotal>ntotal;%(dec>0.5);
    
end