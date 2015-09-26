function newSequence = generate_permuted_sequence(baseVector,multiples,streakLength,unitSize)
% newSequence = generate_permuted_sequence(baseVector,multiples,streakLength,unitSize)
% generate_permuted_sequence takes a vector of elements, replicates that
% multiples times, and constrains the streak length to a max and min.
% Inputs:
% baseVector      1xN vector of inputs (or Nx1), must be unique numbers (REQUIRED)
% multiples       1xN vector of how many times each element in basevector should occur (or Nx1). Defaults to ones
% streakLength    Nx2 matrix. Each row indicates the min (1st column) and max (2nd column) number of consecutive occurrences of an element in baseVector. Defaults to [0 Inf] for each element
% unitSize        1xN vector of inputs (or Nx1). Default to ones. Indicates in batches of how many each element is put in. This is because if streakLength(:,1) is large, the probability of this happening is too small. If elements are put in in larger bunches, you increase probability of a random sequence working out.
% 
% Output: newSequence, baseVector * multiples' elements in column vector
% 
% newSequence = generate_permuted_sequence(baseVector,multiples,streakLength,unitSize)

if length(unique(baseVector))~=length(baseVector)
    error('baseVector should only have unique values')
end
if ~exist('multiples','var')
    multiples = ones(1,length(baseVector));
end
if ~exist('streakLength','var')
    streakLength = repmat([0 Inf],length(baseVector),1);
end
if ~exist('unitSize','var')
    unitSize = ones(1,length(baseVector));
end
% if baseVector is row vector, change to column.
if size(baseVector,2)~=1
    baseVector = baseVector';
end
% if multiples is row vector, change to column
if size(multiples,2)~=1
    multiples = multiples';
end
% if unitSize is row vector, change to column
if size(unitSize,2)~=1
    unitSize = unitSize';
end
% check a few things
assert(size(streakLength,2)==2)
assert(size(streakLength,1)==size(baseVector,1))
assert(size(baseVector,1)==size(multiples,1))
assert(size(baseVector,2)==1)
assert(size(multiples,2)==1)
assert(size(unitSize,1)==size(baseVector,1))
% assert that multiples for each baseVector can be neatly cut up by
% unitSize (e.g. you can't have 10 multiples with unitSize of 6, because 2
% units of those would be 12)
assert(all(mod(multiples,unitSize)==0),'check unitSize and multiples; they should fit')
%% generate newSequence until one is created that satisfies requirements
% % this nifty line creates a cell that contains as many elements as
% % baseVector, with each element multipied as often as necessary. Does not
% % work if unitSize ~= 1
% tmp = arrayfun(@(x) repmat(x,1,multiples(baseVector==x)),baseVector,'UniformOutput',false);
% nonShuffledSequence = [tmp{:}]';

% create cells with units of elements from baseVector of length unitSize.
% These units will later be shuffled and converted to array
unitSequence = {};
for iElement = 1:length(baseVector)
    if multiples(iElement,1)~=0
        for iUnit = 1:multiples(iElement,1)/unitSize(iElement,1) %do as many times as unitSize fits in multiples
            unitSequence = [unitSequence repmat(baseVector(iElement,1),1,unitSize(iElement,1))];
        end
    end
end

% initialise logicElement
logicElement = nan(sum(multiples),1);
noGood = true;
count = 0;
while noGood
    count = count+1;
%     announce(count)
    % assume this will be the right one; will be set back to true if found
    % to be true
    noGood = false;
    % create sequence by shuffling batches of size unitSize together.
    tmp = randswap(unitSequence);
    shuffledSequence = [tmp{:}]';
    % for each number, see if the streak length is satisfied
    for iElement = 1:length(baseVector)
        % get logical with 1 where element is, 0 otherwise
        logicElement = shuffledSequence == baseVector(iElement);
       % find all streak lengths. Assumes min streak length of 1
       % and max possible streak length of
       % multiples(iElement). streakLength(i) stores
       % whether or not a streak of length i was found
        streakLengthDist = nan(multiples(iElement),1);
        for iStreakLength = 1:multiples(iElement)
            % use regexp to find pattern. Will not be able to find if the
            % sequence is right at the start or at the end. Alternatively,
            % use the faster and simpler strfind. 
%             testMid = any(regexp(num2str(logicElement'),['0  (1  ){' num2str(iStreakLength) ',' num2str(iStreakLength) '}0']));
            testMid = ~isempty(strfind(logicElement',[0 ones(1,iStreakLength) 0]));
            testStart = all(logicElement(1:iStreakLength+1) == [ones(iStreakLength,1);0]);
            testEnd = all(logicElement(end-iStreakLength:end) == [0;ones(iStreakLength,1)]);
            streakLengthDist(iStreakLength,1) = testMid || testStart || testEnd;
            % check if conditions are not met for this particular
            % streaklength
            if streakLengthDist(iStreakLength,1) == 1 && (iStreakLength < streakLength(iElement,1) || iStreakLength > streakLength(iElement,2))
                noGood = true;
                break
            end
        end
        if noGood
            continue
        end
    end
    
end

newSequence = shuffledSequence;
end

