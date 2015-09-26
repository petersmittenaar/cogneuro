function [age,days] = calculate_age(startDate,endDate,century)
% [age,days] = calculate_age(startDate,endDate,century)
% calculate_age(startDate,endDate) Takes dates in a string, format ddmmyy (assumed to be in 1900s) or ddmmyyyy. Give a
% start and end date and two output arguments are [numberOfYears,numberOfDays]. It is
% not 100% accurate because rather than calculating leap years properly, it
% assumes each year takes 365.25 years. Days IS accurate.
% if giving start and enddate with only 6 numbers, give century to indicate
% what century we're talking about. Give as string, e.g. '19' or '20'.
% Assumed to be 19 in case no century given for backwards compatibility

%% check input and add '19' to the number in case input is given is ddmmyy
if nargin < 2
    error('more inputs please')
end

if ~exist('century','var')
    century = '19';
end
if length(startDate) == 6
    startDate = [startDate(1:4) century startDate(5:6)];
end
if length(endDate) == 6
    endDate = [endDate(1:4) century endDate(5:6)];
end

%% convert to datenum objects to datevec can work its magic
% as here http://www.mathworks.co.uk/matlabcentral/newsreader/view_thread/58981
% startDate and endDate are in string format at this point
startDateNum=datenum(startDate,'ddmmyyyy');
endDateNum=datenum(endDate,'ddmmyyyy');
age=floor((endDateNum-startDateNum)/365.25);
days = endDateNum-startDateNum;
end