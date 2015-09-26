%% saves the current figure to the desktop as postscript file, ready for illustrator
warning('off','MATLAB:print:adobecset:DeprecatedOption')
filename = get(gcf,'Name');
if isempty(filename)
    filename = 'matlab_recently_saved_figure';
end    

% make font larger so numbers stick together
% set(gca,'FontSize',16)
% screen_size = get(0, 'ScreenSize');
% set(gcf, 'Position', [0 0 screen_size(3) screen_size(4) ] )

%if this doesn't work, change filename_and_path to the actual path and
%filename you want to save to, e.g. 'D:/my_savefile.ps' (extension is .ps)
filename_and_path = [winqueryreg('HKEY_CURRENT_USER', 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'Desktop') ...
    '\' filename '.ps'];


%% take care of PITA Painter's mode not printing RGB 
% http://www.mathworks.com/matlabcentral/fileexchange/35469-rgb2cm-fix-rgb-color-data-in-painter-s-mode
patches = findall(gcf,'Type','patch') ;

cm = colormap ;
j=size(cm,1)+1 ;
for i=1:numel(patches)
    set(patches(i),'CDataMapping','direct')
    c = get(patches(i),'FaceColor') ;
    if strcmpi('flat',c)
        c = get(patches(i),'FaceVertexCData') ;
        if size(c,2)>1
            cm = [cm; c] ;
            n = size(c,1) ;
            set(patches(i),'FaceVertexCData',j+(0:n-1)')
            j=j+n ;
        end
    end
    c = get(patches(i),'MarkerFaceColor') ;
    if strcmpi('flat',c)
        c = get(patches(i),'FaceVertexCData') ;
        if size(c,2)>1
            cm = [cm; c] ;
            n = size(c,1) ;
            set(patches(i),'FaceVertexCData',j+(0:n-1)')
            j=j+n ;
        end
    end
end
colormap(cm)
%%
warning('OFF','MATLAB:print:DeprecatedOptionAdobecset')
print('-dpsc2', '-noui', '-adobecset', '-painters', filename_and_path); %#ok<FROPTX>
