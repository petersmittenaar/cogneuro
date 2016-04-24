function trials = generate_trials
%Column 
% 1: cue
% 2: given (0 = no, 1 = left, 2 = right, 4 = center
% 3: finger 
% 4: reward 
% 5: ITI 
% 6: response anticipation
% 7: cue duration



%% generate trial list

n=80; %how many trials in total
conds = [0 0 1 2]; % cued stop side (0 for non-informative, 1 for left, 2 for right, 3 for no-stop, 4 for both). Also represents ratio
go_stop = [7 3;7 3;7 3;7 3]; %indicates the relative ratio of go_stop trials. Number indicates number of trials in single set. ([1 1] will give same as [5 5])
stop_signal = [1 2 1 2]; %actual stop signal IN CASE a stop signal is given that trial. Same length as conds. left: 1; right: 2; none: 0, 4:center
iti = [2000 2000]; %uniform range of itis
anticipation = [1000 2000 3000];
fingers = [1 2]; %what fingers should get to respond (one set created for every finger)
trials_per_cond = sum(go_stop(1,:)); %sum of go_stop first row, indicating how many trials per condition
cue_duration = 1000;

single_set_n = trials_per_cond*length(conds); %initiates matrix for 1 finger
if mod(n,single_set_n*length(fingers)) ~= 0 %throw error if single_set can't be expanded into total number of trials n
    error('change total number of trials to fit with single_trial set')
end
single_set = zeros(single_set_n,6); %initiate single set for 2 fingers

for i = 1:length(conds) %runs through conds and creates trials for each to fill up a single set
    single_set((i-1)*trials_per_cond+1:i*trials_per_cond,1) = conds(i);
    single_set((i-1)*trials_per_cond+1:i*trials_per_cond,2) = [zeros(go_stop(i,1),1);repmat(stop_signal(i),go_stop(i,2),1)];
    single_set((i-1)*trials_per_cond+1:i*trials_per_cond,4) = 0;
end

%duplicate and add fingers
full_set = repmat(single_set,length(fingers),1); %replicate for as many fingers there are
for i = 1:length(fingers) %for every finger
    full_set(1+single_set_n*(i-1):single_set_n*i,3) = fingers(i);
end

full_set_n = size(full_set,1);

for i=1:(n/full_set_n)
    trials((1+full_set_n*(i-1)):(full_set_n+full_set_n*(i-1)),:) = randswap(full_set,1);
end

%add ITI and anticipation, continuous variable
trials(:,5) = randi(iti(2)-iti(1)+1,n,1)+(iti(1)-1);
% trials(:,6) = randi(anticipation(2)-anticipation(1)+1,n,1)+(anticipation(1)-1);

%add ITI, cue duration and anticipation, discrete distribution
trials(:,6) = anticipation(randi(length(anticipation),n,1));
trials(:,7) = cue_duration(randi(length(cue_duration),n,1));



%% generate stop trials
q
n=20; %how many trials in total
conds = [0]; % cued stop side (0 for non-informative, 1 for left, 2 for right, 3 for no-stop, 4 for both). Also represents ratio
go_stop = [6 4]; %indicates the relative ratio of go_stop trials. Number indicates number of trials in single set. ([1 1] will give same as [5 5])
stop_signal = [1]; %actual stop signal IN CASE a stop signal is given that trial. Same length as conds. left: 1; right: 2; none: 0, 4:center
iti = [2000 2000];
anticipation = [1000 2000 3000];
fingers = [1 2]; %what fingers should get to respond (one set created for every finger)
trials_per_cond = sum(go_stop(1,:)); %sum of go_stop first row, indicating how many trials per condition
cue_duration = [1000];

single_set_n = trials_per_cond*length(conds); %initiates matrix for 1 finger
if mod(n,single_set_n*length(fingers)) ~= 0 %throw error if single_set can't be expanded into total number of trials n
    error('change total number of trials to fit with single_trial set')
end
single_set = zeros(single_set_n,6); %initiate single set for 2 fingers

for i = 1:length(conds) %runs through conds and creates trials for each to fill up a single set
    single_set((i-1)*trials_per_cond+1:i*trials_per_cond,1) = conds(i);
    single_set((i-1)*trials_per_cond+1:i*trials_per_cond,2) = [zeros(go_stop(i,1),1);repmat(stop_signal(i),go_stop(i,2),1)];
    single_set((i-1)*trials_per_cond+1:i*trials_per_cond,4) = 0;
end

%duplicate and add fingers
full_set = repmat(single_set,length(fingers),1); %replicate for as many fingers there are
for i = 1:length(fingers) %for every finger
    full_set(1+single_set_n*(i-1):single_set_n*i,3) = fingers(i);
end

full_set_n = size(full_set,1);

for i=1:(n/full_set_n)
    trials((1+full_set_n*(i-1)):(full_set_n+full_set_n*(i-1)),:) = randswap(full_set,1);
end

%add ITI and anticipation, continuous variable
trials(:,5) = randi(iti(2)-iti(1)+1,n,1)+(iti(1)-1);
% trials(:,6) = randi(anticipation(2)-anticipation(1)+1,n,1)+(anticipation(1)-1);

%add ITI, cue duration and anticipation, discrete distribution
trials(:,6) = anticipation(randi(length(anticipation),n,1));
trials(:,7) = cue_duration(randi(length(cue_duration),n,1));

%randomly select half the 1s and turn them into 2s
ix = find(trials(:,2)==1);
ix = ix(randperm(length(ix)));
trials(ix(1:round(length(ix)/2)),2)=2;

%% response trials only
q
n = 10;
iti = [2000 2000];
anticipation = [0 0];

%leave first two columns open
trials = zeros(n,7);
trials(1:(n/2),3)=1; %pinky
trials((n/2+1):n,3)=2; %index finger
trials(:,5)=randi(iti(2)-iti(1)+1,n,1)+iti(1)-1; %iti

trials = randswap(trials);