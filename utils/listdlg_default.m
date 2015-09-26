function [selection,ok,selected] = listdlg_default(options,instruction) 
%LISTDLG_DEFAULT Takes string of selection options and returns a cell with
%all options selected. Also returns ok if successfully selected. The third
%return is a vector with indices of the selected items.
% function [selection,ok,selected] = listdlg_default(options,instruction) 

switch nargin
    case 0
        warning('No options given for selection');
        selection = '';
        return
    case 1
        instruction = '';
end

list_px_length = 15*length(options); %15 pixels * number of options
if list_px_length > 1000 list_px_length = 1000; end %make sure it's not longer than 1000

[selected,ok] = listdlg( ... 
    'ListString',options, ...
    'SelectionMode','multiple', ...
    'PromptString',instruction, ...
    'OKString','Yo-ho-ho', ...
    'CancelString','Belay', ...
    'ListSize',[800 list_px_length] ...
    );

if ok %if a choice was made
    selection = {options{selected}};
else
    selection = '';
end

end

