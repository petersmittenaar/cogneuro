function wr2_practice
%wr2_practice go through practice trials


global params;

cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg1 = 'On every trial, you''ll see 4 circles appear on the screen.';
msg2 = 'The location of these circles corresponds to the 4 buttons on the keyboard.';
msg3 = '2 circles will be filled; press those buttons as fast as you can!';
msg4 = 'The filled circles will always represent either both your index (blue), or both your middle fingers (green)';
msg5 = 'Press a button to start';


cgmakesprite(301,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(301);
cgtext(msg1,0,params.text.instruction_location(1));
cgtext(msg2,0,params.text.instruction_location(2));
cgtext(msg3,0,params.text.instruction_location(3));
cgtext(msg4,0,params.text.instruction_location(4));
cgtext(msg5,0,params.text.instruction_location(5));
cgloadbmp(103,'stimuli/keyboard_circled_cues.bmp',800, 511);
cgdrawsprite(103,0,-120);

wr2_wait_input(301);

%% trials just responding
trials = params.task.out.response.trials;

%% run through them
params.task.prac.runs1 = 0; %counts how many blocks subject needs
success = 0;
while success ~= 1 %run through the 40 trials if subjects make too many mistakes
    params.task.prac.runs1 = params.task.prac.runs1 + 1;
    for trial_number = 1:size(trials,1)
        params.log(trial_number,1) = trial_number;
        params.log(trial_number,2) = trials(trial_number,1);
        params.log(trial_number,3) = trials(trial_number,2);
        params.log(trial_number,4) = trials(trial_number,3);
        params.log(trial_number,[6 7]) = 0; %no stop signal
        params.log(trial_number,13) = trials(trial_number,5);
        params.log(trial_number,14) = trials(trial_number,6);
        params.log(trial_number,16) = time;
        params.log(trial_number,24) = trials(trial_number,7);

        %% show ITI
        wr2_fixation(params.log(trial_number,13));
        %% anticipation
        params.log(trial_number,18) = wr2_fixation(params.log(trial_number,14)); %saves premature response

        %% show go cues
        if params.log(trial_number,18) == 0 %if subject did not respond prematurely
            wr2_response(trial_number);
            cgflip(params.background)
            wr2_feedback(trial_number,1);
        elseif params.log(trial_number,18) == 1 %if subject responded before cue onset
            wr2_premature      
        end 


    end
    if sum(params.log(:,21)==1) > 5
        success = 1;    
    end
    
    save(['logs\' params.user.subject '\' params.user.date '_' params.user.subject '_log_prac1_' num2str(params.task.prac.runs1) '.mat'],'params');

    params.log=[];
end





%% stop signal instructions (without hints)

cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg1 = 'Well done!';
msg2 = 'Now you''ll learn stopping. Every trial one of the filled circles';
msg3 = 'MIGHT get a red cross through it. This means that the corresponding finger should NOT';
msg4 = 'be pressed down. Try to stop your response, but still respond fast with your other finger!';
msg5 = 'It is very important that you don''t wait for the stop signal to appear.';
msg6 = 'You will not be able to stop everytime you need to, but that''s ok: it''s more important you respond fast!';


cgmakesprite(301,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(301);
cgtext(msg1,0,params.text.instruction_location(1));
cgtext(msg2,0,params.text.instruction_location(2));
cgtext(msg3,0,params.text.instruction_location(3));
cgtext(msg4,0,params.text.instruction_location(4));
cgtext(msg5,0,params.text.instruction_location(5));
cgtext(msg6,0,params.text.instruction_location(6));


wr2_wait_input(301);


trials = params.task.out.stopping.trials;
% params.task.prac.runs2 = 0; %counts how many blocks subject needs
% success = 0;
% while success ~= 1 %run through the trials if subjects make too many mistakes
%     params.task.prac.runs2 = params.task.prac.runs2 + 1;
    
    for trial_number = 1:size(trials,1)
        params.log(trial_number,1) = trial_number;
        params.log(trial_number,2) = trials(trial_number,1);
        params.log(trial_number,3) = trials(trial_number,2);
        params.log(trial_number,4) = trials(trial_number,3);
        if params.log(trial_number,3)~=0 %if it's actually a stop trial. Switch between ssd staircases depending on cued direction
            switch params.log(trial_number,2) %switch depending on cued stop side and actual stop
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

        %% show go cues
        if params.log(trial_number,18) == 0 %if subject did not respond prematurely
            wr2_response(trial_number);
            cgflip(params.background)
            wr2_feedback(trial_number,1);


        elseif params.log(trial_number,18) == 1 %if subject responded before cue onset
            wr2_premature      
        end 

        %break
        if mod(trial_number,params.task.break_frequency) == 0 && trial_number ~= size(trials,1) % if it's break time. (mod(103,100) = 3, mod(200,100) = 0)
            wr2_break
        end


    end

%     %% calculate how many stop trials were successful
%     ix = params.log(:,3) ~= 0;
%     correct_stop = numel(find(params.log(ix,21)==1))/sum(ix); %number between 0 and 1, with 1 being all stops correct
%     if correct_stop >= 0.33 %depends on number of stop trials
%         success = 1;
%     end
    

    save(['logs\' params.user.subject '\' params.user.date '_' params.user.subject '_log_prac2_run.mat'],'params');
    params.log=[]; %clear log for next round

% end







%% start full practice phase

% reset SSDs
params.task.ssd = [100 100 100 100];

%% instructions
cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg1 = 'Great. You''ll now get to practice the real deal.';
msg3 = 'Before each trial you get a hint. You should not press any buttons, just look at the hint. There are four possible hints:';
msg4 = 'Red crosses through left circles means: IF there is a stop signal on the following trial, it''ll always be on the LEFT';
msg5 = 'Red crosses through right circles means: IF there is a stop signal on the following trial, it''ll always be on the RIGHT';
msg6 = 'Red crosses through all circles means: IF there is a stop signal on the following trial, it could be either left OR right';
msg7 = 'No red crosses (all circles white) means: there will NEVER be a stop signal on this trial';
msg8 = 'It is important you use this signal to prepare to stop your response in case the stop signal comes up!';
msg9 = 'After a few minutes we will stop giving you feedback on correct and incorrect choices. Good luck!';
msg10 = 'Press a button to see examples';


cgmakesprite(301,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(301);
cgtext(msg1,0,params.text.instruction_location(1));
cgtext(msg3,0,params.text.instruction_location(3));
cgtext(msg4,0,params.text.instruction_location(5));
cgtext(msg5,0,params.text.instruction_location(6));
cgtext(msg6,0,params.text.instruction_location(7));
cgtext(msg7,0,params.text.instruction_location(8));
cgtext(msg8,0,params.text.instruction_location(10));
cgtext(msg9,0,params.text.instruction_location(11));
cgtext(msg10,0,params.text.instruction_location(13));

wr2_wait_input(301);

%show hints
cgmakesprite(302,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(302);
cgdrawsprite(120,-params.stimulus.instruction_x,params.stimulus.instruction_y,params.stimulus.instruction_size,params.stimulus.instruction_size);
cgdrawsprite(121,-params.stimulus.instruction_x,-params.stimulus.instruction_y,params.stimulus.instruction_size,params.stimulus.instruction_size);
cgdrawsprite(122,params.stimulus.instruction_x,-params.stimulus.instruction_y,params.stimulus.instruction_size,params.stimulus.instruction_size);
cgdrawsprite(123,params.stimulus.instruction_x,params.stimulus.instruction_y,params.stimulus.instruction_size,params.stimulus.instruction_size);

cgtext('Press a button if you understand the instructions',0,0);

wr2_wait_input(302);

%% run trials
trials = params.task.out.full.trials;
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
            case 3 %noStop cued
                params.log(trial_number,6) = 0;
                params.log(trial_number,7) = 0;
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
        if trial_number < size(trials,1)/2 %if less than half the trials have been practised
            wr2_feedback(trial_number,1);
        else
            wr2_feedback(trial_number,0);
        end
        
    elseif params.log(trial_number,18) == 1 %if subject responded before cue onset
        wr2_premature      
    end 
    
    %break
    if mod(trial_number,params.task.break_frequency) == 0 && trial_number ~= size(trials,1) % if it's break time. (mod(103,100) = 3, mod(200,100) = 0)
        wr2_break
    end


end



%% clear log

save(['logs\' params.user.subject '\' params.user.date '_' params.user.subject '_log_prac3.mat'],'params');

params.log = [];

end

