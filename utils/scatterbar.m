function h = scatterbar( data,ax_lims,connected,new_figure,doTidyfig,showPValues)
%SCATTERBAR Takes matrix and plots bar graph with individual datapoint
%scattered over the bar, and 95% CI. Alternatively, if variable 'connected' is true,
%the scattered datapoints will be replaced by lines between paired
%observations. new_figure can be set to true or false, whether or not you
%want the script to create a new figure (useful for e.g. subplots). Default
%is 'true'. Returns axis handle
% 
% function h = scatterbar( data,ax_lims,connected,new_figure,doTidyfig,showPValues)
% 
%   Takes an n-by-m matrix and plots bars representing the mean of each
%   column. Then takes all n elements per column and scatters these over
%   each bar; alternatively, draws lines between paired datapoints. Also plots errorbar representing 95% CI.
%   Idea is that this figure is then taken into Illustrator and adjusted as
%   necessary
%   Optional argument ax_lims as input for command axis. format: [y_min y_max], or leave empty to use defaults
%   Optional argument connected to indicate whether or not individual
%   datapoints should be connected. -1 means no scatter, 0 means scatter, 1
%   means connected.
%   showPValues is a 1 or 0 indicating whether 1-sample t-tests against 0
%   should be shown for each bar. 

if nargin == 0 %if no input 
    error('no input provided')
elseif ~isa(data,'double') %if not a double 
    error('input is not a double matrix')
end

if ~exist('ax_lims','var'),         ax_lims     = []; end
if ~exist('connected','var'),       connected   = 0; end
if ~exist('new_figure','var'),      new_figure  = true; end
if ~exist('doTidyfig','var'),       doTidyfig   = true; end
if ~exist('showPValues','var'),     showPValues = false; end

if new_figure, figure; end %create new figure if requested.

bar(nanmean(data),'k'); %take mean of each column and plot as bar
hold on
for i = 1:size(data,2) %for each bar
    %plot 95% confidence interval
    confInt = ci95t(data(:,i));
    line([i i],[nanmean(data(:,i))-confInt nanmean(data(:,i))+confInt],'Linewidth',5); 
    if connected == 0
        scatter(repmat(i,size(data,1),1),data(:,i),'r','filled');
    end

end

if connected == 1 %if option connected is 1, plot line for each subject
    plot(data','r')
end

if ~isempty(ax_lims)
    ylim(ax_lims)
end

if showPValues
    [~,p] = ttest(data); 
    ylims = get(gca,'YLim');
    proportionFromZero = 0.1;    
    % multiply the y-coordinate by whether it should be above or below zero
    % (based on nanmean(data)).
    handleText = text((1:length(p))',repmat(proportionFromZero.*diff(ylims),length(p),1).*(nanmean(data)>0)',num2str(p',2));
    set(handleText,'HorizontalAlignment','center','Color',[1 1 1])
end

% record current axis
h = gca;

% if you have Laurence's tidyfig.m script, run that too
if exist('tidyfig.m')==2 && doTidyfig
    tidyfig();
end

end

