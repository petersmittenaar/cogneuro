%wr2_MASTER 

q
temp_dir = pwd;


wr2_initialise;

global params;

switch params.user.session %choose scripts to run depending on session
    case 1 %practice only, outside scanner
        wr2_practice;
        wr2_practice_screening; %does not clear params.log, so don't follow this up with experiment
    case 2 %full experiment, outside scanner
        wr2_practice;
        wr2_exp_instruction;
        wr2_experiment;
    case 3 %experiment in scanner
        wr2_exp_instruction;
        wr2_experiment;
    case 4 %experiment only outside, first session
        wr2_exp_instruction;
        wr2_experiment;
    case 5 %experiment only outside, second session
        wr2_exp_instruction;
        wr2_experiment;
    case 6 %practice in scanner
        wr2_exp_instruction;
        wr2_prac_in;
    case 7 %shortened version of experiment, including practice
        wr2_practice;
        wr2_exp_instruction;
        wr2_experiment;
end

%% wait until end of scanning
if params.user.session == 3 %if EPI
    waitslice(params.scanner.port,params.scanner.total_slices); %wait until total_slices is reached
    kp = 0;
    wait(500)
    cgkeymap
    while isempty(find(kp, 1)); %wait for keypress
        [~,kp] = cgkeymap;
    end
else
    wait(1000);
end


%% go to questionnaires if needed
if params.user.questionnaires
    wr2_introduce_questionnaires;
    cd(['logs\' params.user.subject])

%     BIS11(params.user.subject)
%     BISBAS(params.user.subject)
%     eysenck_EPQ_R_48(params.user.subject)
    Edinburgh_handedness(params.user.subject)
    
    cd('..\..')
end

%% copy data to network
try
    copyfile(['logs\' params.user.subject],['\\asia\deleteddaily\' params.user.network_name '\' params.user.subject])
catch %#ok<CTCH>
end

%% thank participant and instruct them what to do next
wr2_close;


%% close cogent
stop_cogent

cd(temp_dir);
clear temp_dir
