function wr2_initialise
% initialises variables and cogent for pilot 1 of reward rate task
warning('off','MATLAB:dispatcher:InexactCaseMatch'); %to suppress cogent warnings for Cogstd
cd(mfilefolder);

%% trial variables

global params;
params.debug.mail = 0;

params.background = [0.2 0.2 0.2];

params.trial.response_duration = 1000; %how long subject has to respond
params.trial.feedback_duration = 1000; %for practice phase, how long they get feedback

%%

params.user.repeat = input('Repeat settings? 1=yes, enter=no    :');
if params.user.repeat==1 %if repeat settings, load last_params and implement settings
    old = load('logs\last_params');
    params.user.subject = old.params.user.subject;
    params.user.session = old.params.user.session;
    params.user.questionnaires = old.params.user.questionnaires;
    params.task.ssd = old.params.task.ssd; %loads last SSD from previous session
    disp('Same settings as last run....')
    disp(params.user);
    disp(params.task.ssd);
else %ask for details
    params.user.subject = input('Subject id (initials + dob): ','s'); %this will be used for logging
    params.user.session = input('Practice outside (1), full session outside (2), exp inside scanner (3), experiment outside 1 (4), experiment outside 2 (5), practice in (6), half experiment out (7): '); %ask what session this is
    params.user.questionnaires = input('Questionnaires at the end? (1=yes, 0 = no): ');
    params.task.ssd = input('Please provide 4 SSD (enter for [100 100 100 100]) as 1x4 vector in square brackets: ');
    if isempty(params.task.ssd)
        params.task.ssd = [100 100 100 100];
    end
end

params.user.date = datestr(now,'yyyymmdd_HHMM');

%% make folder for subject
if ~exist(['logs\' params.user.subject],'dir')
    mkdir(['logs\' params.user.subject]);
end

% make network folder
params.user.network_name = ['peter_wr2_' datestr(now,'yyyymmdd')];
try
    if ~exist(['\\asia\deleteddaily\' params.user.network_name],'dir')
        mkdir(['\\asia\deleteddaily\' params.user.network_name]);
    end
catch err
    disp (err)
end

%% 70/30, longer ITI
params.task.out.response = load('walks/prac_out_response.mat');
params.task.out.stopping = load('walks/prac_out_stopping.mat');
cd walks
switch params.user.session
    case {3,6} %if an EPI session, practice in scanner
        params.task.in.exp.trials = generate_trials_experiment_with_noStop(100);
    case {2,4,5,7} %if outside session with full experiment
        params.task.in.exp.trials = generate_trials_experiment_with_noStop(400);
    case 1 %screen
        params.task.out.screen.trials = generate_trials_experiment_with_noStop(100);
end
params.task.out.full.trials = generate_trials_experiment_with_noStop(100);
cd ..
   

%%


params.task.asynchronous = 70; %how many ms are two button pressed allowed to be apart
params.task.ssd_update = 50; %ms to update SSD after correct/incorrect stop

params.task.break_duration = 20; %break duration in seconds
params.task.break_frequency = 100; %every x trials there's a break

params.text.font_size = 20;
params.text.font = 'Helvetica';
params.text.color = [1 1 1];
params.text.instruction_location = 260:-20:0-300;
params.stimulus.instruction_x = 210;   
params.stimulus.instruction_y = 210;   
params.stimulus.instruction_size = 350;

params.resolution = [1024 768]; 
params.resolution_number = 3; %1=640x480, 2=800x600, 3=1024x768, 4=1152x864, 5=1280x1024, 6=1600x1200
params.scanner.port = 1; %parallel port


if params.user.session == 1 || params.user.session == 2  %outside scanner
    params.keys = [17 45 51 25];
    params.display_type = 1; %1 fullscreen, 0 windowed, 2 fullscreen (alternative screen)

elseif params.user.session == 4 || params.user.session == 5 || params.user.session == 7 %outside scanner
    params.keys = [17 45 51 25];
    params.display_type = 1; %1 fullscreen, 0 windowed, 2 fullscreen (alternative screen)

elseif params.user.session == 6 %practice in scanner, without EPI
    params.keys = [8 7 2 3]; %button box keys left to right
    params.display_type = 2; %1 fullscreen, 0 windowed, 2 fullscreen (alternative screen)

elseif params.user.session == 3 %if in the scanner with EPI
    params.keys = [8 7 2 3]; %button box keys left to right
    params.display_type = 2; %1 fullscreen, 0 windowed, 2 fullscreen (alternative screen)

    params.scanner.post_exp_volumes = 5;
    params.scanner.sequence = input('Sequence id (1) 3mm, (2) 1.5mm, (3) 2.3mm, (0) other: '); %1 for 3mm, 2 for 1.5mm, 0 for anything else
    switch params.scanner.sequence
        case 1 %3mm
            params.scanner.dummies = 5;
            params.scanner.vTR = 70*48; %volume TR in ms
            params.scanner.slices = 48; %number of slices coming in through pulse counter per volume
        case 2 %1.5mm
            params.scanner.dummies = 0;
            params.scanner.vTR = 76*60; %volume TR in ms
            params.scanner.slices = 60; %number of slices coming in through pulse counter per volume
        case 3 %2.3mm
            params.scanner.dummies = 0;
            params.scanner.vTR = 74*40; %volume TR in ms
            params.scanner.slices = 40; %number of slices coming in through pulse counter per volume
        otherwise
            params.scanner.dummies = input('dummies: ');
            params.scanner.vTR = input('vTR (ms): ');
            params.scanner.slices = input('slices: ');
    end
    params.scanner.total_slices = params.scanner.slices * (ceil(600*1000/params.scanner.vTR) + params.scanner.dummies + params.scanner.post_exp_volumes);
    disp(['Total number of volumes: ' num2str(params.scanner.total_slices / params.scanner.slices) ]);
end






%% continue

params.stimulus.circle_size = 200;
params.stimulus.cues = [120 120]; %x deviation and y deviation from centre, resp. 

%% start cogent
% cgloadlib;
% cgopen(params.resolution(1),params.resolution(2),32,0,params.display_type); 

% config_serial(params.scanner.port)
config_display(params.display_type,params.resolution_number,params.background,params.background,params.text.font,params.text.font_size,0)
start_cogent

%% load sprites
cgloadbmp(101,'stimuli\go.bmp',params.stimulus.circle_size, params.stimulus.circle_size); %go stimulus
cgloadbmp(102,'stimuli\nogo.bmp',params.stimulus.circle_size, params.stimulus.circle_size); %nogo stimulus
cgloadbmp(111,'stimuli\stop.bmp',params.stimulus.circle_size, params.stimulus.circle_size); %stop stimulus
cgloadbmp(112,'stimuli\stop_transparant.bmp',params.stimulus.circle_size, params.stimulus.circle_size); %stop stimulus for anticipation
cgloadbmp(120,'stimuli\noninformative_cue.bmp',params.stimulus.instruction_size,params.stimulus.instruction_size); %non-informative example during instruction
cgloadbmp(121,'stimuli\informative_cue_left.bmp',params.stimulus.instruction_size,params.stimulus.instruction_size); %left
cgloadbmp(122,'stimuli\informative_cue_right.bmp',params.stimulus.instruction_size,params.stimulus.instruction_size); %right
cgloadbmp(123,'stimuli\no_stop.bmp',params.stimulus.instruction_size,params.stimulus.instruction_size); %no stop




end