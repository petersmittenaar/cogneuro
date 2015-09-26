function plot2svgdef(filename)
	% wrapper to automatically save to desktop. filename is optional. Do not provide extension, will automatically set svg.
	if ~exist('filename','var')
		filename = 'matlab_recently_saved_figure';
	end    
	%change filename_and_path to desktop
	filename_and_path = fullfile(winqueryreg('HKEY_CURRENT_USER', 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'Desktop'),[filename '.svg']];
	
	addpath(fullpath(mfilefolder,'plot2svg'))
	plot2svg(filename_and_path)
	rmpath(fullpath(mfilefolder,'plot2svg'))
