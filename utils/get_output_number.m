function varargout = get_output_number(func,outputNo,varargin)
% get_output_number(func,outputNo,varargin)
% function to get only the outputNo'th output from a function, mostly useful
% when working with anonymous functions and you want the n-th output to be the
% 1st output. I've used it with princomp as transformation for my DTI data 
% in BG dti-functional project. 
% Stolen from http://stackoverflow.com/questions/3096281/skipping-outputs-with-anonymous-function-in-matlab
% user Yishai Shimoni, retrieved August 2014.
varargout = cell(max(outputNo),1);
[varargout{:}] = func(varargin{:});
varargout = varargout(outputNo);
end