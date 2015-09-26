function varargout = ffigure(title,h)
%FFIGURE Plots figures at fullscreen without focus theft. Usage same as
%figure. Optional argument sets figure name
%   Peter Smittenaar 2011, based on Bilge Butak blog
%   (http://infinitesimalmind.blogspot.com)
% and the sfigure function by Daniel Eaton
% (http://www.mathworks.com/matlabcentral/fileexchange/8919-smartsilent-figure)

screen_size = get(0, 'ScreenSize');

if nargin>1 
	if ishandle(h)
		set(0, 'CurrentFigure', h);
        f1 = h;
	else
		f1 = figure(h);
	end
else
	f1 = figure;
end

set(f1, 'Position', [0 0 screen_size(3) screen_size(4) ] );

if nargout == 1
varargout{1} = f1;
end
if nargin > 0
    set(gcf,'name',title)
end
end

