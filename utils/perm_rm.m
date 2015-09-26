function p = perm_rm(data,iter,plot)
% function [] = perm_rm(data,iter,plot)
% Takes data (m by 2 matrix) which contains 2 measurements per row (e.g. 2 scores per subject). 
% These values are shuffled r number of times, set by iter (default:
% 10000). The distribution is plot and calculated how extreme this value is
%, which is characterized by p-value. Plot indicates whether or not you
%want histogram

% rng('shuffle') %seed number generator at unpredictable location

if size(data,2) ~= 2
    error('only takes 2 repeated measurements per subject/row')
end
if nargin == 1
    iter = 10000;
    plot = false;
elseif nargin == 2
    plot = false;
elseif nargin == 3
    if isempty(iter)
        iter = 10000;
    end
end
   

% calculate mean difference score of original dataset
test_score = nanmean(data(:,2)-data(:,1));

permuted_scores = nan(iter,1);
for i = 1:iter
    swap = randn(size(data,1),1)>0; %logical indicating which to swap
    permuted_data(swap,1:2) = [data(swap,2) data(swap,1)];
    permuted_data(~swap,1:2) = [data(~swap,1) data(~swap,2)];
    permuted_scores(i,1) = nanmean(permuted_data(:,2)-permuted_data(:,1));
end

if plot
    figure
    hist(permuted_scores,100);
    hold on
    lims = get(gca,'YLim');
    line([test_score test_score],[lims(1) lims(2)]);
    hold off
end

% The Use of Permutation Tests in Nonlinear Principal Components Analysis: Application
% p = (q + 1)/(P + 1)
% with q the number of values equal to or higher than the observed value, 
% and P the number of permutations. (In this computation, the 1 is added, 
% because under the null hypothesis, the observed value is also
% considered to be a random permutation.)
p = (sum(abs(permuted_scores)>=abs(test_score))+1)/(iter+1);
lowerBound = 1/(iter+1);
if p<=lowerBound % never do == on doubles, despite it being impossible that p<lowerBound
    disp(['Lower bound for p-value is ' num2str(1/(iter+1))])
    warning('Your p-value is at its lower bound. Consider running more iterations or check whether all your values are greater in one condition than the other')
end

%% this is with old permutation equation (wrong)
% p = sum(abs(permuted_scores)>=abs(test_score))/iter; % original one
%%if p-value is smaller than .01, re-run with 100,000 iterations
% if all(diff(data,1,2)>0) || all(diff(data,1,2)<0) %if one side is always larger than other
%     warning('all your repeated measures are larger in one condition than the other')
%     disp('This happening by chance is equal to 1/(2^nObservations). This is your p-value.')
%     p = 1/(2^size(data,1));
% 	disp('Or do a ttest...')
% elseif p < .01 && iter < 100000
%     warning('iterating with 100,000 iterations because p-value is smaller than .01')
%     p = perm_rm(data,100000,plot);
% end
end
