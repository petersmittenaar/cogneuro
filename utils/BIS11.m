function BIS11(subject_string)

%% BIS-11 questionnaire
% Presents the Barratt Impulsiveness Scale (30 items) using the cogent graphics & cogent 2000 toolbox. 
% Scores are saved as:

% results.scores nth item corresponds to score (1-4) on questions{n}. So these are NOT reversed (which is done for calculation of individual factors)
% results.reversed_scores reversed scores
% results.second_order.attentional
% results.second_order.motor
% results.second_order.nonplanning
% results.first_order.attention
% results.first_order.motor
% results.first_order.self_control
% results.first_order.cognitive_complexity
% results.first_order.perseverance
% results.first_order.cognitive_instability
% 
% See http://onlinelibrary.wiley.com/doi/10.1002/1097-4679(199511)51:6%3C768::AID-JCLP2270510607%3E3.0.CO;2-1/abstract for original (not open access)
% See http://en.wikipedia.org/wiki/Barratt_Impulsiveness_Scale for more information
% 
% 
% This is saved in the user instructed directory as BIS11_yyyymmdd<user defined subject number>_<user defined initials>.mat
% 
% Peter Smittenaar
% www.petersmittenaar.com
% 2012


%% test if cgopen has been called already (useful if calling this script from a battery)

try
    foo = cgkeymap; %#ok<NASGU> %will throw an error if cgopen has not been called, and go to catch
    %cgopen has already been called: use initials and subject from
    %arguments
    independent = 0; %script not running on its own
catch %#ok<CTCH> %so if an error is thrown, i.e. no cogent window open
    clearvars -except subject_string
    clearvars -global
    independent = 1; %script running on its own
    display_type = 1; %0 windowed, 1 fullscreen
    resolution = 3; %3 = 1024x768
    
    config_display(display_type,resolution,[0 0 0],[0 0 0],font,font_size,0)
    start_cogent
end

%%

number_of_steps = 5; %MUST make this uneven: uneven number will allow for arrow to start in the middle, and middle response is not allowed
scale_x = 750;  %length of scale
scale_y = 5;    %width of scale
bar_x = 5;      %width of moving bar
bar_y = 50;     %height of moving bar
scale_location_y = -100;
response_location_y = -150;
instruction_locations = 260:-20:0-300; %vector with y coordinates for instruction text

font_size = 23;
font = 'Helvetica';
color = [1 1 1]; %color of the line. All text is in white by default

% save_dir = uigetdir([],'Select directory to save EHI results');
save_dir = ''; %current folder

questions = { ...
    'I plan tasks carefully.'
    'I do things without thinking.'
    'I make-up my mind quickly.'
    'I am happy-go-lucky.'
    'I don’t ''pay attention.”'
    'I have ''racing'' thoughts.'
    'I plan trips well ahead of time.'
    'I am self controlled.'
    'I concentrate easily.'
    'I save regularly.'
    'I ''squirm'' at plays or lectures.'
    'I am a careful thinker.'
    'I plan for job security.'
    'I say things without thinking.'
    'I like to think about complex problems.'
    'I change jobs.'
    'I act ''on impulse.'''
    'I get easily bored when solving thought problems.'
    'I act on the spur of the moment.'
    'I am a steady thinker.'
    'I change residences.'
    'I buy things on impulse.'
    'I can only think about one thing at a time.'
    'I change hobbies.'
    'I spend or charge more than I earn.'
    'I often have extraneous thoughts when thinking.'
    'I am more interested in the present than the future.'
    'I am restless at the theater or lectures.'
    'I like puzzles.'
    'I am future oriented.'
    };

responses = {'Rarely/Never';'Occasionally';'';'Often';'Almost Always/Always'};
      

instruction1 = 'DIRECTIONS: People differ in the ways they act and think in different situations.';
instruction2 = 'This is a test to measure some of the ways in which you act and think.';
instruction3 = 'Read each statement and select the appropriate option.';
instruction4 = 'Do not spend too much time on any statement.  Answer quickly and honestly.';



%%
cgpencol([1 1 1]);
cgfont(font,font_size);

%% show instructions
cgtext(instruction1,0,instruction_locations(1));
cgtext(instruction2,0,instruction_locations(2));
cgtext(instruction3,0,instruction_locations(3));
cgtext(instruction4,0,instruction_locations(4));

cgtext('press any key to start',0,instruction_locations(6));



cgflip([0 0 0]);
kp = 0;
wait(500)
while isempty(find(kp, 1)); %wait for keypress
    [~,kp] = cgkeymap;
end

scores = zeros(1,length(questions(:,1)));
coordinates = [0:scale_x / (number_of_steps-1): scale_x] - scale_x/2; %#ok<NBRAK>
%% go through every question

for i = 1:length(questions(:,1)); %for every question
    location = number_of_steps/2 + 0.5;
    
    %redraw instructions
    cgtext(instruction1,0,instruction_locations(1));
    cgtext(instruction2,0,instruction_locations(2));
    cgtext(instruction3,0,instruction_locations(3));
    cgtext(instruction4,0,instruction_locations(4));

    % draw possible answers
    for j = 1:size(responses,1);
        cgtext(responses{j,1},coordinates(j),response_location_y);
    end

    %draw scale
    cgpenwid(scale_y);
    cgpencol(color);
    cgdraw(-scale_x / 2,scale_location_y,scale_x / 2,scale_location_y);
    
    %draw question
    cgtext(questions{i},0,50+bar_y/2 + scale_location_y);

    %draw bar in right location
    cgpenwid(bar_x);
    cgpencol(color);
    cgdraw(coordinates(location),-bar_y / 2 + scale_location_y,coordinates(location),bar_y / 2 + scale_location_y);

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


            % draw possible answers
            for j = 1:size(responses,1);
                cgtext(responses{j,1},coordinates(j),response_location_y);
            end

            %draw scale
            cgpenwid(scale_y);
            cgpencol(color);
            cgdraw(-scale_x / 2,scale_location_y,scale_x / 2,scale_location_y);
            
            %draw question
            cgtext(questions{i},0,50+bar_y/2 + scale_location_y);

            %draw bar in right location
            cgpenwid(bar_x);
            cgpencol(color);
            cgdraw(coordinates(location),-bar_y / 2 + scale_location_y,coordinates(location),bar_y / 2 + scale_location_y);

            cgflip([0 0 0]);
            
        end

        
        
    end
    
    %% store the location
    if location == 1 || location == 2
        scores(i) = location;
    elseif location == 4 || location == 5
        scores(i) = location - 1;
    else
        error('something''s wrong, location should be 1, 2, 4 or 5!')
    end
    
    
end



%% calculate results
results.scores = scores;

%all items but 2 and 22 are reverse scored.
reverse = [4 3 2 1];
reversed_scores = scores;
reversed_scores([1 7 8 9 10 12 13 15 20 29 30]) = reverse(scores([1 7 8 9 10 12 13 15 20 29 30]));
results.reversed_scores = reversed_scores;

results.second_order.attentional = sum(reversed_scores([5 6 9 11 20 24 26 28]));
results.second_order.motor = sum(reversed_scores([2 3 4 16 17 19 21 22 23 25 30]));
results.second_order.nonplanning = sum(reversed_scores([1 7 8 10 12 13 14 15 18 27 29]));
results.first_order.attention = sum(reversed_scores([5 9 11 20 28]));
results.first_order.motor = sum(reversed_scores([2 3 4 17 19 22 25]));
results.first_order.self_control = sum(reversed_scores([1 7 8 12 13 14]));
results.first_order.cognitive_complexity = sum(reversed_scores([10 15 18 27 29]));
results.first_order.perseverance = sum(reversed_scores([16 21 23 30]));
results.first_order.cognitive_instability = sum(reversed_scores([6 24 26])); %#ok<STRNU>

save([save_dir 'BIS11_' subject_string '.mat'],'results');


cgtext('Thank you!',0,0);
cgflip([0 0 0]);
wait(3000);


if independent %if script is running on its own
    stop_cogent;
end

end