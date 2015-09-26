disp('Hey Peter')
rng('shuffle')
disp(['Random number generator seeded with ''shuffle'': ' num2str(sum(clock*100))]);

p = pathdef;
addpath(p);

% addpath(fullpath('dropbox matlab folder'))'
% cd('matlab folder');
try
    cd('C:\Users\psmitten\Dropbox\matlab_code');
catch
    cd('D:\Dropbox\projects');
end

format short

clear all



% -nosplash
% 
% profile on
% myfun;
% profile report