%%
clear all;close all

% number of subjects in your simulated study
n=16;
% range of effect sizes on x-axis
range = 0.1:.001:1;

figure();
% call sampsizepwr, which in this case will return the power.
% By giving the second argument as [0 1], i.e. the standard normal distribution,
% any value in variable range can be interpreted as number of standard
% deviations from the null distribution, i.e. effect size in Cohen's d. 
plot(range,sampsizepwr('t',[0 1],range,[],n),'k','LineWidth',5); 
xlabel('effect size ---->'); 
ylabel('power (1-beta)');
axis([min(range) max(range) 0 1]); 