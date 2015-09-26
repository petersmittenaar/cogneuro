function [randomWalks,filterCount] = generate_random_walks(nWalks,nTrials,noise,maxCorr,walkBound,hitRequired,meanBound,stdBound)
% [randomWalks,filterCount] = generate_random_walks(nWalks,nTrials,noise,maxCorr,walkBound,hitRequired,meanBound,stdBound)
% This function creates random walks of rewards based on settings in the
% input. All walks will have the same length. Requirements can be set to
% exclude a set of walks that doesn't satisfy them.
% Output is 
% randomWalks     nTrials x nWalks
% filterCount     keeps track of how many walks were filtered out for, in order as below
% 
% Inputs are (* indicates required). All defaults are no filter (i.e. truly
% random walk within 0 to 1 range). Give nothing, or empty vector, to use default
% nWalks          *number of walks
% nTrials         *number of trials
% noise           Gaussian noise added per trial, 2 element vector [mean std] of Gaussian. Default: [0 0.025]
% maxCorr         maximum allowed correlation in r-squared between any of the walks. Default: 1 (i.e. no filter)
% walkBound       inclusive bound where walk is allowed to go. If exceeded, another random number is drawn (rather than bound selected). Default: [0 1]
% hitRequired     extremes that must be hit by each walk, as [lowerRequired upperRequired]. Default: [inf -inf] (note these are sign-reversed, i.e. they're always hit)
% meanBound       bounds for the mean of each walk, as [lowerBound upperBound] of the mean. Default: [-inf inf] (sign-reversed, i.e. they're always hit)
% stdBound        bounds for std of the walk, as [lowerStdBound upperStdBound]. Default [0 inf] (i.e. must be more than 0, less than inf)
% 
% Peter Smittenaar 2013
% [randomWalks,filterCount] = generate_random_walks(nWalks,nTrials,noise,maxCorr,walkBound,hitRequired,meanBound,stdBound)

%% Input checking and initialization
if nargin < 2
    error('first two input arguments nWalks and nTrials are required')
end
assert(length(nWalks)==1,'nWalks should be single scalar')
assert(length(nTrials)==1,'nTrials should be single scalar')
if exist('noise','var') %if it was given in the first place
    if ~isempty(noise)      assert(all(size(noise)==[1 2]),'give noise in 1x2 vector'); %if it wasn't empty, check it had the right format
    else                    noise = [0 0.025]; end %if it was empty, assign default
else                        noise = [0 0.025]; end %if it didn't exist, assign default

if exist('maxCorr','var')  
    if ~isempty(maxCorr)      assert(length(maxCorr)==1,'give maxCorr as single scalar');
    else                    maxCorr = 1; end
else                        maxCorr = 1; end

if exist('walkBound','var') 
    if ~isempty(walkBound)  assert(all(size(walkBound)==[1 2]),'give walkBound in 1x2 vector');
    else                    walkBound = [0 1]; end
else                        walkBound = [0 1]; end

if exist('hitRequired','var') 
    if ~isempty(hitRequired)assert(all(size(hitRequired)==[1 2]),'give hitRequired in 1x2 vector');
    else                    hitRequired = [inf -inf]; end
else                        hitRequired = [inf -inf]; end

if exist('meanBound','var') 
    if ~isempty(meanBound)assert(all(size(meanBound)==[1 2]),'give meanBound in 1x2 vector');
    else                    meanBound = [-inf inf]; end
else                        meanBound = [-inf inf]; end

if exist('stdBound','var') 
    if ~isempty(stdBound)assert(all(size(stdBound)==[1 2]),'give stdBound in 1x2 vector');
    else                    stdBound = [0 inf]; end
else                        stdBound = [0 inf]; end

filterCount = zeros(1,4); %keeps track of what filter is taking out generated walks
%% Loop over creations of random walks and check they are correct
while true %keep going until conditions are satisfied
    clear randomWalks
    randomWalks = nan(nTrials,nWalks);
    % fill first row
    randomWalks(1,:) = ...
            rand(1,nWalks).*(walkBound(2) - walkBound(1)) ...
            + walkBound(1);
    % run over other trials, slowly drifting each of the reward
    % probabilities
    for iTrial = 2:nTrials
        % while any of the new values exceeds the bounds, keep generating
        % new values to add. The isnan is for when the script first arrives
        % at the line and no values have been assigned
        while any(randomWalks(iTrial,:) > walkBound(2) | randomWalks(iTrial,:) < walkBound(1)) || all(isnan(randomWalks(iTrial,:)))
            randomWalks(iTrial,:) = randomWalks(iTrial-1,:) + randn(1,nWalks) * noise(2) + noise(1);
        end
    end
    %% do all the quality checks.
%     disp(filterCount)
    % max correlation
    r = corrcoef(randomWalks);
    if any(any(r.^2 > maxCorr & r < 1))
        filterCount(1) = filterCount(1)+1;
        continue
    end
    % does it hit the goals?
    if ~(all(sum(randomWalks > hitRequired(2))) && all(sum(randomWalks < hitRequired(1))))
        filterCount(2) = filterCount(2)+1;
        continue
    end
    % mean of each stimulus is acceptable
    if any(mean(randomWalks) > meanBound(2)) || any(mean(randomWalks) < meanBound(1))
        filterCount(3) = filterCount(3)+1;
        continue
    end
    % is the variance for each of the walks within bounds
    if any(std(randomWalks) < stdBound(1)) || any(std(randomWalks) > stdBound(2))
        filterCount(4) = filterCount(4)+1;
        continue
    end
    %if all these requirements are met, break from while loop.
    break
    
end
end