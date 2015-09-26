function [z,p1,p2] = log_vector_to_z(vector)
%LOG_VECTOR_TO_Z Takes a vector, log-transforms it and takes z-scores. p1 is p-statistic
%for input, p2 is p-statistic for ouput taken from Shapiro-Wilks test.
%Significant alpha means null-hypothesis (of normality) must be rejected

%   Useful for e.g. reaction time data
%
% Peter Smittenaar 2011

log_vector = log(vector);
z = zscore(log_vector);

%normality tests. p1 for raw data, p2 for transformed data.
[~,p1] = swtest(vector);
[~,p2] = swtest(z);

end

