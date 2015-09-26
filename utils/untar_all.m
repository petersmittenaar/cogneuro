function untar_all(source,target)
% function untar_all(source,target)
% untars all .tar files in a directory into target directory. 
% Defaults for source and target directory are the current directories

tic
switch nargin %assign defaults based on number of input arguments
    case 0
        source = pwd;
        target = pwd;
    case 1
        target = pwd;
end


files = dir(fullfile(source,'*.tar'));

for i = 1:size(files,1)
    untar(fullfile(source,files(i).name),target);
    disp(['Untarred ' num2str(i) ' archives'])
end

disp(['done (' num2str(round(toc)) 's)'])