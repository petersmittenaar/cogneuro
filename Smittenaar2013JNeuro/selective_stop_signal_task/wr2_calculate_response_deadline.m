function wr2_calculate_response_deadline
%p2_CALCULATE_RESPONSE_DEADLINE looks at trials from practice phase and
%sets response deadline such that particular percentage would be correct.
%NOW DOES 80% + 100ms

global params

%%
percentage_correct = 90; %percentage correct

%collect RTs from all trials
rts = params.log(params.log(:,21) == 1,22);

%take last 15 (there's always at least 15 response times, absolute minimum
%successful Go responses)

rts = rts(end-14:end,1);


%% lognormal fitting
pd = fitdist(rts,'lognormal');
% pd contains mean and standard deviation. Calculate how many standard
% deviations you need to take to get to percentage_correct success.

% norminv returns number of standard deviations. When combined with mean
% and standard deviation, returns value
sds = norminv(percentage_correct/100,pd.mu,pd.sigma);
params.task.cutoff = exp(sds)+100; %convert back to ms rather than log(ms)

end

