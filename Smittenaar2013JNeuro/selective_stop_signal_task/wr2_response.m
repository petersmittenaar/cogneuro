function wr2_response( trial_number)
%p2_RESPONSE takes trial and phase, and shows response stimulus and records
%response

global params

%% draw the correct cues
wr2_draw_cues(params.log(trial_number,4));

%% start tracking responses
cgkeymap;
response_timer = time;
ss_flip = 0; %becomes 1 after ss is shown

while time-response_timer <= params.trial.response_duration %wait until 1 second has past
    ks = cgkeymap;
    button = find(ks); %could be multiple if pressed exactly at same time. Returns index of buttons pressed
    if ~isempty(button) %if a button was pressed
        
        task_buttons = find(ismember(params.keys,button)); %returns the numbers of the button pressed (1,2,3 or 4, or combination of those)
        %check if all buttons have already been logged as 'pressed' for
        %this trial
        for i = 1:length(task_buttons) %for every task button that is being pressed
            if params.log(trial_number,task_buttons(i)+7) == 0 %if this RT has not been logged yet, i.e. first time button is pressed
                params.log(trial_number,task_buttons(i)+7) = time-response_timer;
            end
        end
        
    end
    
    %% draw stop signal if needed
    if time-response_timer >= params.log(trial_number,6) && ss_flip == 0 && params.log(trial_number,3) ~= 0 %if ssd has passed, flip hasn't occured yet, AND this is actually a stop trial
        ss_flip = 1;
        stop_side = params.log(trial_number,3);
        finger = params.log(trial_number,4);
        if stop_side == 1 && finger == 1 cues = [2 1;0 0]; 
        elseif stop_side == 1 && finger == 2 cues = [0 0;2 1];
        elseif stop_side == 2 && finger == 1 cues = [1 2;0 0];
        elseif stop_side == 2 && finger == 2 cues = [0 0;1 2];
        end
        
        wr2_draw_cues(cues);
    end
        
end


end
