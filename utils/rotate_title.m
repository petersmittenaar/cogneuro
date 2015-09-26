function rotate_title(angle,ax)
% rotates the title of the current axis' title (default) or title axis ax
% to angle (default 45 degrees from unit).
% Provide angle as positive value between 0 and 360 inclusive
% Inspired by http://www.mathworks.co.uk/matlabcentral/newsreader/view_thread/259001
if ~exist('angle','var')
	angle = 45;
end
if ~exist('ax','var')
	ax = get(gca,'Title'); %get axis title's handle
end

if angle > 0 && angle < 180
    alignment = 'left';
elseif angle > 180 && angle < 360
    alignment = 'right';
else
    alignment = 'center';
end

P = get(ax,'position');
set(ax,'rotation',angle,'HorizontalAlignment',alignment)
% set(ax,'rotation',angle)

end

