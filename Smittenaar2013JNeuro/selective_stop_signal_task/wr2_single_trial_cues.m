function wr2_single_trial_cues( trial_number )
%p2_SINGLE_TRIAL_CUES Takes trial number and the phase (i.e. prac or main)
%the subject is in, and shows a picture and reward expectation

global params;



%% draw cues
cgsetsprite(0);

switch params.log(trial_number,2)
    case 0 %neutral
        cgdrawsprite(112,-params.stimulus.cues,params.stimulus.cues); %left top
        cgdrawsprite(112,params.stimulus.cues,params.stimulus.cues); %right top
        cgdrawsprite(112,-params.stimulus.cues,-params.stimulus.cues); %left bottom
        cgdrawsprite(112,params.stimulus.cues,-params.stimulus.cues); %right bottom
    case 1 %left
        cgdrawsprite(112,-params.stimulus.cues,params.stimulus.cues); %left top
        cgdrawsprite(101,params.stimulus.cues,params.stimulus.cues); %right top
        cgdrawsprite(112,-params.stimulus.cues,-params.stimulus.cues); %left bottom
        cgdrawsprite(101,params.stimulus.cues,-params.stimulus.cues); %right bottom
    case 2 %right
        cgdrawsprite(101,-params.stimulus.cues,params.stimulus.cues); %left top
        cgdrawsprite(112,params.stimulus.cues,params.stimulus.cues); %right top
        cgdrawsprite(101,-params.stimulus.cues,-params.stimulus.cues); %left bottom
        cgdrawsprite(112,params.stimulus.cues,-params.stimulus.cues); %right bottom
    case 3 %no stop
        cgdrawsprite(101,-params.stimulus.cues,params.stimulus.cues); %left top
        cgdrawsprite(101,params.stimulus.cues,params.stimulus.cues); %right top
        cgdrawsprite(101,-params.stimulus.cues,-params.stimulus.cues); %left bottom
        cgdrawsprite(101,params.stimulus.cues,-params.stimulus.cues); %right bottom
end

cgflip(params.background);

wait(params.log(trial_number,24));

end

