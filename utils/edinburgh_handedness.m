function edinburgh_handedness(subject_string)

%% Edinburgh Handedness Inventory (EHI)
% Presents the EHI (10 items) using the cogent graphics & cogent 2000 toolbox. Scores
% are saved as:
% results.scores nth item i corresponds to responses{i} for activity activities{n}
% results.laterality_index calculated as 100*(right - left)/(left + right)
% 
% See http://web.psy.ku.dk/Anders_Gade/Readings/Oldfield1971.pdf for original paper
% See http://www.cse.yorku.ca/course_archive/2006-07/W/4441/EdinburghInventory.html for example of questionnaire and calculation
% 
% 
% This is saved in the user instructed directory as EHI_yyyymmdd<user defined subject number>_<user defined initials>.mat
% 
% Peter Smittenaar
% www.petersmittenaar.com
% 2012

if ~exist('subject_string','var')
    subject_string = input('subject id: ','s');
end
save_dir = pwd; %current folder
%%
number_of_steps = 7; %MUST make this uneven: uneven number will allow for arrow to start in the middle, and middle response is not allowed
scale_x = 600;  %length of scale
scale_y = 5;    %width of scale
bar_x = 5;      %width of moving bar
bar_y = 50;     %height of moving bar
text_distance_left = 100; %play around with this one. States where text will be relative to end of the scale. Depends on resolution used
text_distance_right = 100;
response_location_y = -50; %y of text under scale (response options)
instruction_locations = 260:-20:0-300; %vector with y coordinates for instruction text

font_size = 20;
font = 'Helvetica';
color = [1 1 1]; %color of the line. All text is in white by default

if ~exist(save_dir,'dir')
    mkdir(save_dir)
end

activities = { ...
    'Writing'; ...
    'Drawing'; ...
    'Throwing'; ...
    'Scissors'; ...
    'Toothbrush'; ...
    'Knife (without fork)'; ...
    'Spoon'; ...
    'Broom (upper hand)'; ...
    'Striking match (match)'; ...
    'Opening box (lid)'; ...
    };

responses = {'++';'+';'indifferent';'';'no experience';'+';'++'};

instruction1 = 'Please indicate your preferences in the use of hands in the following activities by moving the bar to a + on the left or right.';
instruction2 = 'Where the preference is so strong that you would never try to use the other hand, unless absolutely forced to, enter ++.';
instruction3 = 'If in any case you are really indifferent, move the cursor to ''indifferent''. Some of the activities listed below require the use of both hands.';
instruction4 = 'In these cases, the part of the task, or object, for which hand preference is wanted is indicated in parentheses.';
instruction5 = 'Please try and answer all of the questions, and only enter ''no experience'' if you have no experience at all with the object or task.';
instruction6 = 'Use the arrows keys to move, and press enter to confirm.';

%% test if cgopen has been called already (useful if calling this script from a battery)
try
    foo = cgkeymap; %#ok<NASGU> %will throw an error if cgopen has not been called, and go to catch
    %cgopen has already been called: use initials and subject from
    %arguments
    independent = 0; %script not running on its own
catch %#ok<CTCH> %so if an error is thrown, i.e. no cogent window open
    independent = 1; %script running on its own
    
    display_type = 0; %0 windowed, 1 fullscreen
    resolution = 3;
    
    config_serial(1)
    config_display(display_type,resolution,[0 0 0],[0 0 0],font,font_size,0)
    start_cogent
end
%%
cgpencol([1 1 1]);
cgfont(font,font_size);

%% show instructions
cgtext(instruction1,0,instruction_locations(1));
cgtext(instruction2,0,instruction_locations(2));
cgtext(instruction3,0,instruction_locations(3));
cgtext(instruction4,0,instruction_locations(4));
cgtext(instruction5,0,instruction_locations(5));
cgtext(instruction6,0,instruction_locations(6));
cgtext('press any key to start',0,instruction_locations(8));

cgflip([0 0 0]);
kp = 0;
wait(500)
while isempty(find(kp, 1)); %wait for keypress
    [~,kp] = cgkeymap;
end

scores = zeros(1,length(activities(:,1)));
coordinates = [0:scale_x / (number_of_steps-1): scale_x] - scale_x/2;
%% go through every activity

for i = 1:length(activities(:,1)); %for every activity
    location = number_of_steps/2 + 0.5;
    
    %redraw instructions
    cgtext(instruction1,0,instruction_locations(1));
    cgtext(instruction2,0,instruction_locations(2));
    cgtext(instruction3,0,instruction_locations(3));
    cgtext(instruction4,0,instruction_locations(4));
    cgtext(instruction5,0,instruction_locations(5));
    cgtext(instruction6,0,instruction_locations(6));

    % draw possible answers
    for j = 1:size(responses,1);
        cgtext(responses{j,1},coordinates(j),response_location_y);
    end

    %draw scale
    cgpenwid(scale_y);
    cgpencol(color);
    cgdraw(-scale_x / 2,0,scale_x / 2,0);
    
    %draw activity
    cgtext(activities{i},0,50+bar_y/2);

    %draw bar i nright location
    cgpenwid(bar_x);
    cgpencol(color);
    cgdraw(coordinates(location),-bar_y / 2,coordinates(location),bar_y / 2);

    cgpencol([1 1 1]);
    cgfont(font,font_size);
    cgtext('left',(-scale_x / 2) - text_distance_left,0);
    cgtext('right',(scale_x / 2) + text_distance_right,0);
    cgflip([0 0 0]);
    
    [~,kp] = cgkeymap;
    
    while kp(28) == 0 || location == number_of_steps/2 + 0.5 %while enter has not been pressed, and location is not allowed to be in the middle
        %check for response and move location
        [~,kp] = cgkeymap;
        if kp(75) == 1
            location = location - 1;
        elseif kp(77) == 1
            location = location + 1;
        end
        
        %make sure the vertical line stays on the scale
        if location < 1
            location = 1;
        elseif location > number_of_steps
            location = number_of_steps;
        end
        
        if find(kp) %if a button has been pressed redraw everything with new location
            %redraw instructions
            cgtext(instruction1,0,instruction_locations(1));
            cgtext(instruction2,0,instruction_locations(2));
            cgtext(instruction3,0,instruction_locations(3));
            cgtext(instruction4,0,instruction_locations(4));
            cgtext(instruction5,0,instruction_locations(5));
            cgtext(instruction6,0,instruction_locations(6));

            % draw possible answers
            for j = 1:size(responses,1);
                cgtext(responses{j,1},coordinates(j),response_location_y);
            end

            %draw scale
            cgpenwid(scale_y);
            cgpencol(color);
            cgdraw(-scale_x / 2,0,scale_x / 2,0);
            
            %draw activity
            cgtext(activities{i},0,50+bar_y/2);

            %draw bar in right location
            cgpenwid(bar_x);
            cgpencol(color);
            cgdraw(coordinates(location),-bar_y / 2,coordinates(location),bar_y / 2);

            cgpencol([1 1 1]);
            cgfont(font,font_size);
            cgtext('left',(-scale_x / 2) - text_distance_left,0);
            cgtext('right',(scale_x / 2) + text_distance_right,0);
            cgflip([0 0 0]);
            
        end        
    end    
    %% store the location
    scores(i) = location;    
end
%% calculate laterality index
total_left = sum(scores == 1)*2 + sum(scores == 2) + sum(scores == 3); %++ count double, + and indifferent count as 1
total_right = sum(scores == 7)*2 + sum(scores == 6) + sum(scores == 3); %++ count double, + and indifferent count as 1
difference = total_right - total_left;
cum_total = total_left + total_right;
li = 100*difference/cum_total;


results.scores = scores;
results.laterality_index = li; %#ok<STRNU>
save(fullfile(save_dir,['EHI_' subject_string '.mat']),'results');

cgtext('Thank you!',0,0);
cgflip([0 0 0]);
wait(3000);

if independent %if script is running on its own
    stop_cogent;
end

end