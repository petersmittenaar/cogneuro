function wr2_prac_in


%% start full practice phase

global params
%% instructions
cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg1 = 'Here''s one last practice block before we start.';
msg3 = 'Before each trial you get a hint. You should not press any buttons, just look at the hint. There are three possible hints:';
msg4 = 'Red crosses through left circles means: IF there is a stop signal on the following trial, it''ll always be on the LEFT';
msg5 = 'Red crosses through right circles means: IF there is a stop signal on the following trial, it''ll always be on the RIGHT';
msg6 = 'Red crosses through all circles means: IF there is a stop signal on the following trial, it could be either left OR right';
msg8 = 'It is important you use this signal to prepare to stop your response in case the stop signal comes up!';
msg9 = 'Good luck!';
msg10 = 'Examples of cues:';


cgmakesprite(301,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(301);
cgtext(msg1,0,params.text.instruction_location(1));
cgtext(msg3,0,params.text.instruction_location(3));
cgtext(msg4,0,params.text.instruction_location(5));
cgtext(msg5,0,params.text.instruction_location(6));
cgtext(msg6,0,params.text.instruction_location(7));
cgtext(msg8,0,params.text.instruction_location(10));
cgtext(msg9,0,params.text.instruction_location(11));
cgtext(msg10,0,params.text.instruction_location(13));

cgdrawsprite(120,params.stimulus.instruction_x,params.text.instruction_location(21),params.stimulus.instruction_size,params.stimulus.instruction_size);
cgdrawsprite(121,-params.stimulus.instruction_x,params.text.instruction_location(21),params.stimulus.instruction_size,params.stimulus.instruction_size);


wr2_wait_input(301);

%% run trials
trials = params.task.out.stopping_no_feedback.trials;
for trial_number = 1:size(trials,1)
    params.log(trial_number,1) = trial_number;
    params.log(trial_number,2) = trials(trial_number,1);
    params.log(trial_number,3) = trials(trial_number,2);
    params.log(trial_number,4) = trials(trial_number,3);
    if params.log(trial_number,3)~=0 %if it's actually a stop trial. Switch between ssd staircases depending on cued direction
        switch params.log(trial_number,2) %switch depending on cued stop side
            case 0 %no direction cued
                switch params.log(trial_number,3)
                    case 1 %left stop cue
                        params.log(trial_number,6) = params.task.ssd(1);
                        params.log(trial_number,7) = 1;
                    case 2 %right stop side
                        params.log(trial_number,6) = params.task.ssd(2);
                        params.log(trial_number,7) = 2;
                end
            case 1 %stop signal left
                params.log(trial_number,6) = params.task.ssd(3);
                params.log(trial_number,7) = 3;
            case 2 %stop signal right
                params.log(trial_number,6) = params.task.ssd(4);
                params.log(trial_number,7) = 4;
        end
    else %go trial
        params.log(trial_number,[6 7]) = 0; %no stop trial, so no ssd used
    end
    params.log(trial_number,13) = trials(trial_number,5);
    params.log(trial_number,14) = trials(trial_number,6);
    params.log(trial_number,24) = trials(trial_number,7);
    params.log(trial_number,16) = time;
    
    %% timebar
    disp(['0% ' repmat('#',1,trial_number) repmat('-',1,size(trials,1)-trial_number) ' 100%  Remaining: ' num2str((size(trials,1)-trial_number) * 6) ' seconds'])

    %% show ITI
    wr2_fixation(params.log(trial_number,13));
        
    %% show stop hint and reward on this trial
    wr2_single_trial_cues(trial_number);

    %% show fixation
    params.log(trial_number,18) = wr2_fixation(params.log(trial_number,14)); %saves premature response

    %% show go cues
    if params.log(trial_number,18) == 0 %if subject did not respond prematurely
        wr2_response(trial_number);
        cgflip(params.background)
        wr2_feedback(trial_number,0);
        
    elseif params.log(trial_number,18) == 1 %if subject responded before cue onset
        wr2_premature      
    end 



end



%% clear log

save(['logs\' params.user.subject '\' params.user.date '_' params.user.subject '_log_prac_in.mat'],'params');



end