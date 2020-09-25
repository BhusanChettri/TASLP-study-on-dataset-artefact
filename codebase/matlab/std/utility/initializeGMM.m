function [initMeans,initCovariances,initPriors] = initializeGMM(data,msize)

rng default;
%disp('init param')

data = [data{:}]';

%data(0:0)
disp('size of the data: ')
size(data)

initMeans = data(randi([1 size(data,1)],1,msize),:);
initCovariances = repmat(diag(cov(data)),1,msize)';
initPriors = ones(msize,1)/msize;

disp('Parameter initialisation is done..');
end
