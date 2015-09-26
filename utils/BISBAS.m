function BISBAS(subject_string)

%% BIS/BAS questionnaire
% Presents the Behavioral Inhibition System (BIS) / Behavioral Approach System (BAS) questionnaire using the cogent graphics & cogent 2000 toolbox. 
% Scores are saved as:

% results.scores nth item corresponds to score (1-4) on questions{n}. So these are NOT reversed (which is done for calculation of individual factors)
% results.reversed_scores reversed scores (all except q2 and q22)
% results.BAS.drive
% results.BAS.fun_seeking
% results.BAS.reward_responsiveness
% results.BIS
% 
% See http://psycnet.apa.org/journals/psp/67/2/319/ for original (not open access)
% See http://www.mendeley.com/research/behavioral-inhibition-behavioral-activation-affective-responses-impending-reward-punishment-bisbas-scales-5/ for original paper
% See http://www.psy.miami.edu/faculty/ccarver/sclBISBAS.html for example and explanation
% 
% 
% This is saved in the user instructed directory as BISBAS_yyyymmdd<user defined subject number>_<user defined initials>.mat
% 
% Peter Smittenaar
% www.petersmittenaar.com
% 2012

%%

number_of_steps = 5; %MUST make this uneven: uneven number will allow for arrow to start in the middle, and middle response is not allowed
scale_x = 600;  %length of scale
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
    'A person''s family is the most important thing in life.'
    'Even if something bad is about to happen to me, I rarely experience fear or nervousness.'
    'I go out of my way to get things I want.'
    'When I''m doing well at something I love to keep at it.'
    'I''m always willing to try something new if I think it will be fun.'
    'How I dress is important to me.'
    'When I get something I want, I feel excited and energized.'
    'Criticism or scolding hurts me quite a bit.'
    'When I want something I usually go all-out to get it.'
    'I will often do things for no other reason than that they might be fun.'
    'It''s hard for me to find the time to do things such as get a haircut.'
    'If I see a chance to get something I want I move on it right away.'
    'I feel pretty worried or upset when I think or know somebody is angry at me.'
    'When I see an opportunity for something I like I get excited right away.'
    'I often act on the spur of the moment.'
    'If I think something unpleasant is going to happen I usually get pretty "worked up."'
    'I often wonder why people act the way they do.'
    'When good things happen to me, it affects me strongly.'
    'I feel worried when I think I have done poorly at something important.'
    'I crave excitement and new sensations.'
    'When I go after something I use a "no holds barred" approach.'
    'I have very few fears compared to my friends.'
    'It would excite me to win a contest.'
    'I worry about making mistakes.'
    };

responses = {'1';'2';'';'3';'4'};

instruction1 = 'Each item of this questionnaire is a statement that a person may either agree with or disagree with.';
instruction2 = 'For each item, indicate how much you agree or disagree with what the item says.';
instruction3 = 'Please be as accurate and honest as you can be.  Respond to each item as if it were the only item.';
instruction4 = 'That is, don''t worry about being "consistent" in your responses.  Choose from the following four response options:';
instruction5 = '1 = very true for me';
instruction6 = '2 = somewhat true for me';
instruction7 = '3 = somewhat false for me';
instruction8 = '4 = very false for me';


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
cgtext(instruction5,0,instruction_locations(6));
cgtext(instruction6,0,instruction_locations(7));
cgtext(instruction7,0,instruction_locations(8));
cgtext(instruction8,0,instruction_locations(9));
cgtext('press any key to start',0,instruction_locations(11));



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
    cgtext(instruction5,0,instruction_locations(6));
    cgtext(instruction6,0,instruction_locations(7));
    cgtext(instruction7,0,instruction_locations(8));
    cgtext(instruction8,0,instruction_locations(9));

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
            cgtext(instruction5,0,instruction_locations(6));
            cgtext(instruction6,0,instruction_locations(7));
            cgtext(instruction7,0,instruction_locations(8));
            cgtext(instruction8,0,instruction_locations(9));

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
reversed_scores([1 3:21 23 24]) = reverse(scores([1 3:21 23 24]));
results.reversed_scores = reversed_scores;

results.BAS.drive = sum(reversed_scores([3 9 12 21]));
results.BAS.fun_seeking = sum(reversed_scores([5 10 15 20]));
results.BAS.reward_responsiveness = sum(reversed_scores([4 7 14 18 23]));
results.BIS = sum(reversed_scores([2 8 13 16 19 22 24]));

save([save_dir 'BISBAS_' subject_string '.mat'],'results');


cgtext('Thank you!',0,0);
cgflip([0 0 0]);
wait(3000);


if independent %if script is running on its own
    stop_cogent;
end

end