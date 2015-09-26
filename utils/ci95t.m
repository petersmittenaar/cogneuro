function [ciOneSide,LBound,UBound,SEM,means] = ci95t(data,errorDim)
% [SEMx1dot96,LBound,UBound,SEM,means] = ci95t(data,errorDim)
% 
% calculates 95% confidence interval across the first dimension (e.g. over rows in 2d matrix) 
% or across errorDim
% Returns lower bound, upper bound, standard error, and the size of one side of the 95% confidence interval, and the mean.
% ignores nans, so needs stats toolbox
% 
% Uses the t-distribution to calculate interval. Discussed with Sukhbinder,
% this is the way to do it because your estimate of the standard deviation
% comes from the data. If you knew the standard deviation from a huge
% dataset and just plugged it in, then you could use the CI from the normal
% distribution (i.e. ci95.m). Crucially, if using t-distribution, you can't
% do *1.96, the value should be the 95% CI in the t-distribution.

if ~exist('errorDim','var'), errorDim = 1; end
means = nanmean(data,errorDim);
SEM = nanstd(data,0,errorDim)./sqrt(sum(~isnan(data),errorDim)); %divide by number of actual datapoints, i.e. non-NaNs
[~,~,ci] = ttest(data,[],[],[],errorDim);
% ugger = ',:'; % to allow for n-dimensional input
% eval(['LBound = ci(1' repmat(ugger,1,ndims(ci)-1) ');']);
% eval(['UBound = ci(2' repmat(ugger,1,ndims(ci)-1) ');']);

% I put the following in when working with multi-dimensional data, but it's
% ugly as sin.
uggerStart = ':,'; % to allow for n-dimensional input
uggerFinish = ',:'; % to allow for n-dimensional input
tmp = [repmat(uggerStart,1,errorDim-1) '1' repmat(uggerFinish,1,ndims(ci)-errorDim)];
eval(['LBound = ci(' tmp ');']);
tmp = [repmat(uggerStart,1,errorDim-1) '2' repmat(uggerFinish,1,ndims(ci)-errorDim)];
eval(['UBound = ci(' tmp ');']);
ciOneSide = UBound-means; % subtract mean from highest side of ci

% keyboard
means       = squeeze(means);
SEM         = squeeze(SEM);
ciOneSide   = squeeze(ciOneSide);
LBound      = squeeze(LBound);
UBound      = squeeze(UBound);

end