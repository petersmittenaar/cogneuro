function wr2_experiment
%wr2_EXPERIMENT Main experiment part

%%
global params;

trials = params.task.in.exp.trials;

if params.user.session == 3 %if a scanner session
    waitslice(params.scanner.port,params.scanner.dummies*params.scanner.slices); %waits for dummy slices to have passed
end

for trial_number = 1:size(trials,1)

    params.log(trial_number,1) = trial_number;
    params.log(trial_number,2) = trials(trial_number,1);
    params.log(trial_number,3) = trials(trial_number,2);
    params.log(trial_number,4) = trials(trial_number,3);
    if params.log(trial_number,3)~=0 %if it's actually a stop trial. Switch between ssd staircases depending on cued direction
        switch params.log(trial_number,2) %switch depending on cued stop side
            case 0 %no direction cued
                switch params.log(trial_number,3) %based on stop signal
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
    if params.user.session == 3
        [slices,times] = getslice(params.scanner.port);
        params.log(trial_number,25) = slices(end);
        params.log(trial_number,26) = times(end);
    end

    %% display progress bar
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
    
    if mod(trial_number,params.task.break_frequency) == 0 && trial_number ~= size(trials,1) % if it's break time. (mod(103,100) = 3, mod(200,100) = 0)
        %% send email to alert task is almost done. Takes about 2 seconds 
        if params.debug.mail == 1 && trial_number + params.task.break_frequency >= size(trials,1) 
       
            try %I use try because internet connection might not be there, might lead to problems?
                send_mail_message('petersmittenaar',['subject ' num2str(params.user.subject) ' starting last break now'],'');
            catch err;
                disp(err);
            end
        end
        wr2_break
    end
end
    
    
%% save log

save(['logs\' params.user.subject '\' params.user.date '_' params.user.subject '_session' num2str(params.user.session) '_log_exp.mat'],'params');





end



