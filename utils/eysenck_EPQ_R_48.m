function eysenck_EPQ_R_48(subject_string)

%% Short-scale EPQ-R
% Presents the Eysenck short-scale EPQ-R (48 items) using the cogent graphics & cogent 2000 toolbox. Scores
% are saved as:
% results.scores nth item corresponds to yes (1) or no (0) on questions{n}.
% results.scale.p p scale score
% results.scale.e
% results.scale.n
% results.scale.l
% 
% See http://www.pbarrett.net/publications/EPQR_1985_paper.pdf for original
% paper and scoring
% 
% 
% This is saved in the user instructed directory as EPQR_yyyymmdd<user defined subject number>_<user defined initials>.mat
% 
% Peter Smittenaar
% www.petersmittenaar.com
% 2012

%%

number_of_steps = 3; %MUST make this uneven: uneven number will allow for arrow to start in the middle, and middle response is not allowed
scale_x = 300;  %length of scale
scale_y = 5;    %width of scale
bar_x = 5;      %width of moving bar
bar_y = 50;     %height of moving bar
response_location_y = -50;
instruction_locations = 260:-20:0-300; %vector with y coordinates for instruction text

font_size = 25;
font = 'Helvetica';
color = [1 1 1]; %color of the line. All text is in white by default


% save_dir = uigetdir([],'Select directory to save EHI results');
save_dir = ''; %current folder

questions = { ...
    'Does your mood often go up and down?'
    'Do you take much notice of what people think?'
    'Are you a talkative person?'
    'If you say you will do something, do you always keep your promise no matter how inconvenient it might be?'
    'Do you ever feel ‘just miserable’ for no reason?'
    'Would being in debt worry you?'
    'Are you rather lively?'
    'Were you ever greedy by helping yourself to more than your share of anything?'
    'Are you an irritable person?'
    'Would you take drugs which may have strange or dangerous effects?'
    'Do you enjoy meeting new people?'
    'Have you ever blamed someone for doing something you knew was really your fault?'
    'Are your feelings easily hurt?'
    'Do you prefer to go your own way rather than act by the rules?'
    'Can you usually let yourself go and enjoy yourself at a lively party?'
    'Are all your habits good and desirable ones?'
    'Do you often feel ''fed-up''?'
    'Do good manners and cleanliness matter much to you?'
    'Do you usually take the initiative in making new friends?'
    'Have you ever taken anything (even a pin or button) that belonged to someone else?'
    'Would you call yourself a nervous person?'
    'Do you think marriage is old-fashioned and should be done away with?'
    'Can you easily get some life into a rather dull party?'
    'Have you ever broken or lost something belonging to someone else?'
    'Are you a worrier?'
    'Do you enjoy co-operating with others?'
    'Do you tend to keep in the background on social occasions?'
    'Does it worry you if you know there are mistakes in your work?'
    'Have you ever said anything bad or nasty about anyone?'
    'Would you call yourself tense or ''highly-strung''?'
    'Do you think people spend too much time safeguarding their future with savings and insurances?'
    'Do you like mixing with people?'
    'As a child were you ever cheeky to your parents?'
    'Do you worry too long after an embarrassing experience?'
    'Do you try not to be rude to people?'
    'Do you like plenty of bustle and excitement around you?'
    'Have you ever cheated at a game?'
    'Do you suffer from ''nerves''?'
    'Would you like other people to be afraid of you?'
    'Have you ever taken advantage of someone?'
    'Are you mostly quiet when you are with other people?'
    'Do you often feel lonely?'
    'Is it better to follow society''s rules than go your own way?'
    'Do other people think of you as being very lively?'
    'Do you always practice what you preach?'
    'Are you often troubled about feelings of guilt?'
    'Do you sometimes put off until tomorrow what you ought to do today?'
    'Can you get a party going?'
    };

responses = {'YES';'';'NO'};

instruction1 = 'Please answer each question by moving the line to the ''YES'' or the ''NO'' choice and pressing enter.';
instruction2 = 'There are no right or wrong answers, and no trick questions. Work quickly and do not think too';
instruction3 = 'long about the exact meaning of the questions.';

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
cgtext('press any key to start',0,instruction_locations(5));

cgflip([0 0 0]);
kp = 0;
wait(500)
while isempty(find(kp, 1)); %wait for keypress
    [~,kp] = cgkeymap;
end

scores = zeros(1,length(questions(:,1)));
coordinates = [0:scale_x / (number_of_steps-1): scale_x] - scale_x/2; %#ok<NBRAK>
%% go through every activity

for i = 1:length(questions(:,1)); %for every activity
    location = number_of_steps/2 + 0.5;
    
    %redraw instructions
    cgtext(instruction1,0,instruction_locations(1));
    cgtext(instruction2,0,instruction_locations(2));
    cgtext(instruction3,0,instruction_locations(3));


    % draw possible answers
    for j = 1:size(responses,1);
        cgtext(responses{j,1},coordinates(j),response_location_y);
    end

    %draw scale
    cgpenwid(scale_y);
    cgpencol(color);
    cgdraw(-scale_x / 2,0,scale_x / 2,0);
    
    %draw question
    cgtext(questions{i},0,50+bar_y/2);

    %draw bar i nright location
    cgpenwid(bar_x);
    cgpencol(color);
    cgdraw(coordinates(location),-bar_y / 2,coordinates(location),bar_y / 2);

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


            % draw possible answers
            for j = 1:size(responses,1);
                cgtext(responses{j,1},coordinates(j),response_location_y);
            end

            %draw scale
            cgpenwid(scale_y);
            cgpencol(color);
            cgdraw(-scale_x / 2,0,scale_x / 2,0);
            
            %draw question
            cgtext(questions{i},0,50+bar_y/2);

            %draw bar in right location
            cgpenwid(bar_x);
            cgpencol(color);
            cgdraw(coordinates(location),-bar_y / 2,coordinates(location),bar_y / 2);

            cgflip([0 0 0]);
            
        end

        
        
    end
    
    %% store the location
    if location == 1 %if yes
        scores(i) = 1;
    elseif location == 3 %if no
        scores(i) = 0;
    else
        error('something wrong with matching scale location to ''yes'' and ''no'' answers')
    end
    
    
end



%% calculate results

%figure out scores. Some questions are scored if YES is given, others if NO
%is given.
results.scores = scores;
results.scale.p = sum(scores([10 14 22 31 39]) == 1) + sum(scores([2 6 18 26 28 35 43])==0);
results.scale.e = sum(scores([3 7 11 15 19 23 32 36 44 48]) == 1) + sum(scores([27 41])==0);
results.scale.n = sum(scores([1 5 9 13 17 21 25 30 34 38 42 46]) == 1);
results.scale.l = sum(scores([4 16 45]) == 1) + sum(scores([8 12 20 24 29 33 37 40 47])==0); %#ok<STRNU>

save([save_dir 'EPQR_' subject_string '.mat'],'results');

cgtext('Thank you!',0,0);
cgflip([0 0 0]);
wait(3000);

if independent %if script is running on its own
    stop_cogent;
end

end