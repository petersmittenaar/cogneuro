function sameaxis(ha,limits)
% sets axes on x and y to be the same. Handle and axis limits optional.
% sets xticklabels to be same as y, and sets axis to square
if ~exist('ha','var')
	ha = gca;
end
if ~exist('limits','var')
	xlimits = get(gca,'XLim');
	ylimits = get(gca,'YLim');
	limits = [min(min([xlimits' ylimits'])) max(max([xlimits' ylimits']))];
end

axis(ha,[limits limits])
axis(ha,'square')
ytick = get(ha,'YTick');
yticklabels = get(ha,'YTickLabel');
set(ha,'XTick',ytick,'XTickLabel',yticklabels);



end