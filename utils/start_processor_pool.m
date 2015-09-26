function start_processor_pool(cores)
if ~exist('cores','var')
    cores = 4; % default
end
if isempty(which('matlabpool'))
    warning('parallel toolbox not installed, not starting any cores')
    return
end
assert(length(cores)==1,'more than 1 value given for cores')
assert(isnumeric(cores),'cores should be an integer');
if matlabpool('size') == 0 %if pool is closed
    matlabpool(cores)
    disp(['Cores opened: ' num2str(matlabpool('size'))])
elseif matlabpool('size') ~= cores
    matlabpool close
    matlabpool(cores)
end

end