function lineHandle = xyline(h)
% plots xyline in current axis, unless other axis handle is given. Returns handle of line

if ~exist('h','var')
	h = gca;
end
axes(h)

% tells you [x_min x_max y_min y_max]
lims = [get(gca,'XLim') get(gca,'YLim')];

lineStart = max(lims([1 3]));
lineStop = min(lims([2 4]));

lineHandle = line([lineStart lineStop],[lineStart lineStop]);
set(lineHandle,'Color',[0 0 0])


end

