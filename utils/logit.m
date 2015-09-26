function out = logit(in,transform)
% LOGIT transforms input to and from the logit function, which takes values
% from -inf to +inf for input values between 0 and 1.
% Inputs:
% in: scalar, vector, or matrix. Each operation is executed on the values
% independently in case of vector or matrix input.
% transform: can be either 'to continuous' or 'to bounded' to indicate
% value should go from between 0 and 1 to a range of -inf to +inf (i.e., to
% continuous) or to go from infinite range to between 0 and 1 (i.e. to
% bounded). DEFAULT: 'to continuous'
% 
% Output:
% out: same size as variable 'in', but now transformed
% 
% Also see http://en.wikipedia.org/wiki/Logit
% Peter Smittenaar, Oct 2013, for reinforcement learning models
% 
% function out = logit(in,transform) 
% with transform = 'to continuous' OR 'to bounded'

if ~exist('transform','var')
    transform = 'to continuous';
end

% % % % guard against extreme values, which break it and make it into NaNs
if strcmp(transform,'to bounded')
    in(in>100) = 100;
    in(in<-2000) = -2000;
end
switch transform
    case 'to continuous'
        out = log(in)-log(1-in);
    case 'to bounded'
        out = exp(in)./(exp(in)+1);
    otherwise
        error('invalid transform selected')
end

assert(all(size(in)==size(out)));
% check if any part of the output is not real
if any(~isreal(out))
    error('Some output is not real. This is probably because you set the transform incorrectly. If you do intend to transform values that are not between 0 and 1 with the logit function, which is unlikely, comment out the error')
end

end

