function files = list_files(filter,directory,directories)
% function files = list_files(filter,directory,directories)
%returns a cell column FILES which contains all the filenames that pass through FILTER in directory DIRECTORY
%Directory and filter are strings, files is a nx1 cell array. Directories
%are returned only when argument DIRECTORIES == 1
%
% Peter Smittenaar, 2012

switch nargin
    case 0
        directory = pwd;
        filter = '';
        directories = 0;
    case 1
        directory = pwd;
        directories = 0;
    case 2
        directories = 0;
end

list = dir(fullfile(directory,filter));
list = list(~cellfun(@(x) strcmp(x,'.'),{list(:).name})); %filters out the '.'
list = list(~cellfun(@(x) strcmp(x,'..'),{list(:).name})); %filters out the '..'
if ~directories
    list = list(~cellfun(@(x) x==1,{list(:).isdir})); %filters out directories
end
files = {list(:).name}';
end