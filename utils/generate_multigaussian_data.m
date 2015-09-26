function data = generate_multigaussian_data(n,means,sds)
% function data = generate_multigaussian_data(n,means,sds)
% You can use this script to generate data with a number of gaussians 
% with particular mean and standard deviation. If mean and standard deviation 
% are not given, mean and sd are randomly drawn from normal distribution.
% n is the number of datapoints per Gaussian (default = 100), means is 
% a vector with means for each gaussian (and thus sets number of Gaussians; default = 1 Gaussian)
% , sds is standard deviation of each respective gaussian

if nargin < 1
    n = 100;
end
if nargin < 2
    means = randn(1,1);
end
nr_gaussians = length(means);
if nargin < 3
    sds = randn(nr_gaussians,1);
end

%create a column vector for each requested Gaussian
data_columns = nan(n,nr_gaussians);
for gaussian = 1:nr_gaussians %for each gaussian
    data_columns(:,gaussian) = means(gaussian) + sds(gaussian).*randn(n,1);
end

%transform columns into one big column vector
data = data_columns(:);
end

