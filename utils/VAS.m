clc
clear all

number_of_steps = 11; %always make this uneven: uneven number will allow for arrow to start in the middle
scale_x = 600;  %length of scale
scale_y = 5;    %width of scale
bar_x = 5;      %width of moving bar
bar_y = 50;     %length of moving bar
text_distance_left = 100; %play around with this one. States where text will be relative to end of the scale. Depends on resolution used
text_distance_right = 100;

font_size = 20;
font = 'Helvetica';
color = [1 1 1]; %color of the line. All text is in white by default

display_type = 1; %0 windowed, 1 fullscreen
resolution = [1024 768];

initials = input('Subject initials: ','s');
subject = input('subject ID: ', 's');  

%fill out your pairs here
opposites = { ...
    'ALERT' 'DROWSY'; ...
    'CALM' 'EXCITED'; ...
    'STRONG' 'FEEBLE'; ...
    'MUZZY' 'CLEAR HEADED'; ...
    'WELL COORDINATED' 'CLUMSY'; ...
    'LETHARGIC' 'ENERGETIC'; ...
    'CONTENTED' 'DISCONTENTED'; ...
    'TROUBLED' 'TRANQUIL'; ...
    'MENTALLY SLOW' 'QUICK WITTED'; ...
    'TENSE' 'RELAXED'; ...
    'ATTENTIVE' 'DREAMY'; ...
    'INCOMPETENT' 'PROFICIENT'; ...
    'HAPPY' 'SAD'; ...
    'ANTAGONISTIC' 'FRIENDLY'; ...
    'INTERESTED' 'BORED'; ...
    'WITHDRAWN' 'SOCIABLE'; ...
    };

instruction = 'Please move the bar using the arrow keys and press enter to confirm. Press key to continue';

cgloadlib
cgopen(resolution(1),resolution(2),32,0,display_type); %resolution 3 is 1024 x 768, 5 is 1280 x 1024

cgpencol([1 1 1]);
cgfont(font,font_size);

%% show instructions
cgtext(instruction,0,0);
cgflip([0 0 0]);
kp = 0;
wait(500)
while isempty(find(kp, 1)); %wait for keypress
    [ks,kp] = cgkeymap;
end

scores = zeros(1,length(opposites(:,1)));

%% go through every pair

for i = 1:length(opposites(:,1));

    %draw scale
    cgpenwid(scale_y);
    cgpencol(color);
    cgdraw(-scale_x / 2,0,scale_x / 2,0);
    
    %draw bar
    cgpenwid(bar_x);
    cgpencol(color);
    cgdraw(0,-bar_y / 2,0,bar_y / 2);
    
    cgpencol([1 1 1]);
    cgfont(font,font_size);
    cgtext(opposites{i,1},(-scale_x / 2) - text_distance_left,0);
    cgtext(opposites{i,2},(scale_x / 2) + text_distance_right,0);
    cgflip([0 0 0]);
    
    coordinates = [0:scale_x / (number_of_steps-1): scale_x] - scale_x/2;
    location = number_of_steps/2 + 0.5;
    
    [ks,kp] = cgkeymap;
    ks(:) = 0;
    
    while kp(28) == 0
        
        
        %draw scale
        cgpenwid(scale_y);
        cgpencol(color);
        cgdraw(-scale_x / 2,0,scale_x / 2,0);

        %draw bar i nright location
        cgpenwid(bar_x);
        cgpencol(color);
        cgdraw(coordinates(location),-bar_y / 2,coordinates(location),bar_y / 2);

        cgpencol([1 1 1]);
        cgfont(font,font_size);
        cgtext(opposites{i,1},(-scale_x / 2) - text_distance_left,0);
        cgtext(opposites{i,2},(scale_x / 2) + text_distance_right,0);
        
        [ks,kp] = cgkeymap;
        if kp(75) == 1
            location = location - 1;
        elseif kp(77) == 1
            location = location + 1;
        end
        
        if location < 1
            location = 1;
        elseif location > 11
            location = 11;
        end
        
        cgflip([0 0 0]);
        
        if find(kp) %wait a little bit so cursor doesn't overshoot
            wait(80);
        end
        
    end
    
    %%store the location
    scores(i) = location - 1;
    
    
end


save([initials '_' subject'],'scores');


cgshut