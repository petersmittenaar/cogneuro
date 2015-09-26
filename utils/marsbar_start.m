%apparently it can mess up your SPM if marsbar is in the default path (I
%think it has a couple of similarly-named functions). So this script adds
%marsbar and then starts it. 
spm8('nogui');
addpath([mfilefolder '\marsbar-0.43']);
marsbar