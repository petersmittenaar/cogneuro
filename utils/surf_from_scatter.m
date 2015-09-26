function surf_from_scatter(data,labels)
% function to create surface plots from scatter data. Data should be an m x
% 3 vector. Labels should be 1x3 cell array with labels for the axes
% (optional). If the data is m x n where n > 3 it is assumed that what is requested is
% more of a surf command, where x becomes 1:m, y = 1:n, and z equals
% data(:)
% Taken from http://www.mathworks.com/matlabcentral/fileexchange/5105
% Zain Mecklai

% Edited by Peter Smittenaar January 2013 to make it into a function

if size(data,2) == 3
    x = data(:,1);
    y = data(:,2);
    z = data(:,3);
end

%% Plot it with TRISURF
ffigure
if size(data,2) == 3
    tri = delaunay(x,y);
    h = trisurf(tri, x, y, z);
elseif size(data,2) > 3
    h = surf(data);
end
axis vis3d

%% Clean it up

if exist('labels','var') %if argument was given
    xlabel(labels{1})
    ylabel(labels{2})
    zlabel(labels{3})
else
    axis off
end
l = light('Position',[-50 -15 29]);
% set(gca,'CameraPosition',[208 -50 7687])
% lighting phong
shading interp
colorbar EastOutside

end