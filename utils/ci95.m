function [SEMx1dot96,LBound,UBound,SEM,means] = ci95(data)
% [SEMx1dot96,LBound,UBound,SEM,means] = ci95(data)
% 
% calculates 95% confidence interval across first non-singleton dimension (i.e. per column in 2d matrix) 
% Returns lower bound, upper bound, standard error, and the size of one side of the 95% confidence interval, and the mean.
% ignores nans, so needs stats toolbox
% 
% NOTE THIS IS PROBABLY NOT WHAT YOU NEED; YOU SHOULD PROBABLY CALCULATE
% CONFIDENCE INTERVAL FROM T-DISTRIBUTION, SO USE ci95t

means = nanmean(data,1);
SEM = nanstd(data,1)./sqrt(sum(~isnan(data))); %divide by number of actual datapoints, i.e. non-NaNs
SEMx1dot96 = SEM.*1.96;
LBound = means - SEMx1dot96;
UBound = means + SEMx1dot96;

means       = squeeze(means);
SEM         = squeeze(SEM);
SEMx1dot96  = squeeze(SEMx1dot96);
LBound      = squeeze(LBound);
UBound      = squeeze(UBound);

end