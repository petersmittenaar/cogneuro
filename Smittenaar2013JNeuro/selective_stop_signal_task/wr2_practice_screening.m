function wr2_practice_screening


global params;



%% start full practice phase

% reset SSDs
params.task.ssd = [100 100 100 100];

%% instructions
cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg1 = 'Great. You now start the last practice block.';
msg2 = 'It is important that you:';
msg3 = '1) don''t wait for the red cross; respond as quick as you can';
msg4 = '2) use the hint to prepare and anticipate a stop in case a red cross appears';
msg5 = 'Press a button to start.';


cgmakesprite(301,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(301);
cgtext(msg1,0,params.text.instruction_location(1));
cgtext(msg2,0,params.text.instruction_location(2));
cgtext(msg3,0,params.text.instruction_location(3));
cgtext(msg4,0,params.text.instruction_location(4));
cgtext(msg5,0,params.text.instruction_location(6));

wr2_wait_input(301);

%% run trials
trials = params.task.out.screen.trials;
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
    
    %break
    if mod(trial_number,params.task.break_frequency) == 0 && trial_number ~= size(trials,1) % if it's break time. (mod(103,100) = 3, mod(200,100) = 0)
        wr2_break
    end


end



%% clear log

save(['logs\' params.user.subject '\' params.user.date '_' params.user.subject '_log_prac_screen.mat'],'params');


end

