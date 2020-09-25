function output = cmvn (input)

%fprintf('cmvn script at /homes/bc305/myphd/journal1/codebase/matlab/std/utility/');

[~,N] = size(input); 
% % % Compute the standard deviation and mean
std_temp = std(input,0,2);
mean_temp = mean(input,2);
% % % Normalize the training input data
output = (input-repmat(mean_temp,1,N))./repmat(std_temp,1,N);
