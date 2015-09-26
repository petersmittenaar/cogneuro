function filepath = mfilefolder
%MFILEFOLDER Returns full path of caller function
%   Based on mfilename('fullpath'), which returns the full path but
%   includes the function name. This function returns the current path in a
%   string, ending with a backslash \

% Peter Smittenaar, 2011

st = dbstack(1,'-completenames'); %collect all caller functions
if size(st,1) == 0 %if function is called on its own
    error('No caller: you probably ran mfilefolder on its own rather than by calling it from another function')
end

st = st(1); %get rid of all but the function directly calling
function_length = size(st.name,2); %length of m-file name
path_length = size(st.file,2); %length of full path of m-file
filepath = st.file(1,1:(path_length-function_length-2)); %subtract the two and account for '.m' at end of path name


end

