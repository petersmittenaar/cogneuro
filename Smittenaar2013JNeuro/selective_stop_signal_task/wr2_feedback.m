function wr2_feedback(trial_number,feedback)
%p2_FEEDBACK presents feedback after outcome fixation period

global params

%% determine if response was correct

%determine what correct response pattern is
switch params.log(trial_number,4)
    case 1 %middle finger
        switch params.log(trial_number,3) %side stop signal
            case 0
                correct_pattern = [1 0 0 1];
            case 1
                correct_pattern = [0 0 0 1];
            case 2
                correct_pattern = [1 0 0 0];
        end
    case 2 %index finger
        switch params.log(trial_number,3) %side stop signal
            case 0
                correct_pattern = [0 1 1 0];
            case 1
                correct_pattern = [0 0 1 0];
            case 2
                correct_pattern = [0 1 0 0];
        end
end

response_pattern = params.log(trial_number,8:11)>0; %1x4 vector with 1s where subject responded
correct_pattern = logical(correct_pattern);
rts = params.log(trial_number,8:11);
if sum(rts) > 0 %if responses have been made
    params.log(trial_number,22) = min(rts(response_pattern)); %fastest RT
    params.log(trial_number,19) = find(params.log(trial_number,8:11) == params.log(trial_number,22),1); %record what finger was the fastest
end

%set a sprite to draw on in case feedback is actually shown
cgmakesprite(10,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(10);

if response_pattern == correct_pattern %if correct buttons were pressed
    params.log(trial_number,15) = 1;
    buttons = find(response_pattern == 1);
    if sum(response_pattern) == 2 %if two buttons were pressed, i.e. regular go trial, OR stop trial but with no stop
        if abs(params.log(trial_number,7+buttons(1))-params.log(trial_number,7+buttons(2)))<=params.task.asynchronous; %check if RTs were 50 or less ms apart
            params.log(trial_number,21) = 1;
            cgpencol([0 1 0]);cgfont(params.text.font,40);cgtext('great!',0,0);
            disp('correct');
        else %if responses were too far apart
            params.log(trial_number,21) = 5;
%             params.log(trial_number,15) = 0; %SHOULD BE ADDED, BUT WAS
%             NOT INCLUDED IN SCANNING. THIS MEANS ASYNCHRONOUS RESPONSES
%             ARE RECORDED AS CORRECT. this is corrected in analysis script
            cgpencol([1 0 0]);cgfont(params.text.font,40);cgtext('BUTTONS NOT PRESSED TOGETHER',0,0);
            disp('BUTTONS NOT PRESSED TOGETHER');
        end     
    else %correct stop
        params.task.ssd(params.log(trial_number,7)) = params.task.ssd(params.log(trial_number,7)) + params.task.ssd_update; %update ssd
        params.log(trial_number,21) = 1;
        cgpencol([0 1 0]);cgfont(params.text.font,40);cgtext('great!',0,0);
        disp('correct');

    end
    
else %if incorrect response
    params.log(trial_number,15) = 0;
    cgpencol([1 0 0]);cgfont(params.text.font,40);
    
    if sum(response_pattern) == 0 %if no button pressed 
        params.log(trial_number,21) = 4;
        cgtext('NO BUTTON PRESSED',0,0);
        disp('NO BUTTON PRESSED');
    elseif sum(correct_pattern) < 2 %if it's a stop trial
        params.log(trial_number,21) = 3; %no stop
        params.task.ssd(params.log(trial_number,7)) = params.task.ssd(params.log(trial_number,7)) - params.task.ssd_update; %update ssd
        cgtext('DIDN''T STOP',0,0);
        disp('DIDN''T STOP');
    elseif sum(response_pattern) == 1 && sum(correct_pattern) == 2 %1 button pressed where 2 should've been pressed
        params.log(trial_number,21) = 6; 
        cgtext('ONLY 1 BUTTON PRESSED',0,0);
        disp('ONLY 1 BUTTON PRESSED');
    elseif sum(response_pattern) >= sum(correct_pattern) %if correct number of buttons pressed, but wrong ones, or if more than requested number of button pressed 
        params.log(trial_number,21) = 7; 
        cgtext('WRONG BUTTON',0,0);
        disp('WRONG BUTTON');
    end
end

cgsetsprite(0);
if feedback == 1 %if feedback should be shown
    cgdrawsprite(10,0,0);
    cgflip(params.background);
    wait(params.trial.feedback_duration);
end

cgfreesprite(10);

%% correct SSDs below 0 and larger than 900
params.task.ssd(params.task.ssd < 0) = 0;
params.task.ssd(params.task.ssd > 900) = 900;



end

