function announce(varargin)
%prints message in matlab window with timestamp. Varargin is as many
%strings as you want appended. If any are not strings, are assumed numeric
%and converted. No cells allowed as arguments
varargin = cellfun(@(x) num2str(x),varargin,'UniformOutput',false);
nElements = length(varargin);
message = [];
for iElement = 1:nElements
    if size(varargin{iElement},1)>1
        varargin{iElement}=varargin{iElement}';
        if size(varargin{iElement},1)>1 %if still larger, i.e. it's a matrix
            varargin{iElement} = '<message removed, too many dimensions>';
        end
    end
    message = [message ' ' varargin{iElement}];
end
disp(['######### ' datestr(now,'HH.MM:SS') ' ' message])
end