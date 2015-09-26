function tidyfig(f,saveFig)
% function tidyfig(f,saveFig)
% by Laurence Hunt, modified by Peter
if ~exist('f','var')
    f = [];
end
if isempty(f)
    f = gcf;
end
figure(f);
if ~exist('saveFig','var')
    saveFig = true;
end

%% option 1
% set(gca,'FontSize',16);
% set(get(gca,'XLabel'),'FontSize',16);
% set(get(gca,'YLabel'),'FontSize',16);
% set(get(gca,'Title'),'FontSize',16,'FontWeight','bold');

%% option 2 to handle multiple axes
axisHandles = findall(f,'type','axes');
for iAxis = 1:length(axisHandles)
    set(axisHandles(iAxis),'FontSize',14);
    set(get(axisHandles(iAxis),'XLabel'),'FontSize',14);
    set(get(axisHandles(iAxis),'YLabel'),'FontSize',14);
    set(get(axisHandles(iAxis),'Title'),'FontSize',14,'FontWeight','bold');
    set(gca, 'box', 'off') % turn box off. OH YEAH!
end


%%
set(gcf,'Color',[1 1 1]);

% added by Peter S: copy to clipboard, save as ai, return to commandwindow
print -dmeta  -noui
if saveFig
    aisave
end
% commandwindow
