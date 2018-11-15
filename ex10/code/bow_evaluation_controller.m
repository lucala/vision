%
% BAG OF WORDS RECOGNITION EXERCISE
% Alex Mansfield and Bogdan Alexe, HS 2011
%

%training
disp('creating codebook');
sizeCodebook = 200;
numIterations = 10;
vCenters = create_codebook('../data/controller-training-pos',sizeCodebook,numIterations);
%keyboard;
disp('processing positve training images');
vBoWPos = create_bow_histograms('../data/controller-training-pos',vCenters);
disp('processing negative training images');
vBoWNeg = create_bow_histograms('../data/controller-training-neg',vCenters);
%vBoWPos_test = vBoWPos;
%vBoWNeg_test = vBoWNeg;
%keyboard;
disp('processing positve testing images');
vBoWPos_test = create_bow_histograms('../data/controller-testing-pos',vCenters);
disp('processing negative testing images');
vBoWNeg_test = create_bow_histograms('../data/controller-testing-neg',vCenters);

nrPos = size(vBoWPos_test,1);
nrNeg = size(vBoWNeg_test,1);

test_histograms = [vBoWPos_test;vBoWNeg_test];
labels = [ones(nrPos,1);zeros(nrNeg,1)];

disp('______________________________________')
disp('Nearest Neighbor classifier')
bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_nearest);
disp('______________________________________')
disp('Bayesian classifier')
bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_bayes);
disp('______________________________________')
