% NOT FOR GENERAL USE

% quick and dirty script to re-write some field codes before making data
% publicly available.

% dat is a file from Robb's appdata2struct.m file
tmp=dat;
for i = 1:length(dat), 
    age = dat(i).age;
    if age<1.1
        tmp(i).age='18-24';
    elseif age<2.1
        tmp(i).age='25-29';
    elseif age<3.1
        tmp(i).age='30-39';
    elseif age<4.1
        tmp(i).age='40-49';
    elseif age<5.1 
        tmp(i).age='50-59';
    elseif age<6.1
        tmp(i).age='60-69';
    elseif age<7.1
        tmp(i).age='70+';
    else
        tmp(i).age='unknown';
    end
    
    gender = dat(i).gender;
    if gender<0.1
        tmp(i).gender = 'male';
    elseif gender<1.1
        tmp(i).gender = 'female';
    end
    
    ed = dat(i).education;
    if ed<0.1
        tmp(i).education = 'GCSE';
    elseif ed<1.1
        tmp(i).education = 'A-level';
    elseif ed<2.1
        tmp(i).education = 'degree';
    elseif ed<3.1
        tmp(i).education = 'postgraduate';
    end
    
    if regexp(dat(i).devicetype,'^iP*')
        tmp(i).devicetype = 'iOS'; 
    else tmp(i).devicetype = 'other'; 
    end
    
    for ii = 1:length(dat(i).timesubmitted)
        tmp(i).timesubmitted{ii} = tmp(i).timesubmitted{ii}(1:10);
    end
    
    if isnan(dat(i).appversion)
        tmp(i).appversion = '1-0';
    end
end
