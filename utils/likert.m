function score = likert(end_texts,question,steps,stim_fig,backgroundColor)
% present likert scale in cogent, which should already be running. 
% Arguments:
% end_texts [required]: can be 1, 2 or 3 elements: if two, it's the endpoints; if 3, it's from left to right in order, i.e. 2nd element in the middle, if 1, only in middle
% question [required]: one or multiple strings in a cell array. These strings are presented above the bar
% steps [required]: number of steps on the bar
% stim_fig [optional]: stim_fig the (relative/absolute) path to figure that is presented below the bar
% backgroundColor [optional]: background color. Otherwise defaults to grey

% Peter Smittenaar
% www.petersmittenaar.com
% 2013

if ~iscell(question)
    error('question must be a cellstr')
end
if ~exist('backgroundColor','var') %if not given
    backgroundColor = [.2 .2 .2];
end
cgflip(backgroundColor); %flip to set background color, such that on next flip background will be correct

%%
show_fig = ~isempty(stim_fig); %0 if not, 1 if so
number_of_steps = steps; %if even, arrow starts randomly left or right of middle
bar_loc_y = 50; %where the bar is on the screen
scale_x = 600;  %length of scale
scale_y = 5;    %width of scale
bar_x = 5;      %width of moving bar
bar_y = 50;     %height of moving bar
bar_text_y = 10; %where text is on the screen
text_distance_left = 0; %play around with this one. States where text will be relative to end of the scale. Depends on resolution used
text_distance_right = 0;
response_location_y = -50; %y of text under scale (response options)
instruction_locations = 200:-20:-100; %vector with y coordinates for instruction text
figure_y = -200;

font_size = 25;
font = 'Helvetica';
color = [1 1 1]; %color of the line. All text is in white by default
if show_fig
    cgloadbmp(9999,stim_fig,250,250);
end
%% show instructions
coordinates = [0:scale_x / (number_of_steps-1): scale_x] - scale_x/2;
switch mod(number_of_steps,2) %is 1 if odd
    case 1
        location = ceil(number_of_steps./2); %start in middle
    case 0 %even number of steps
        location = double(randn>0) + ceil(number_of_steps./2); %this will make bar start at lower end or upper end of the middle
end

%draw scale
cgpenwid(scale_y);
cgpencol(color);
cgdraw(-scale_x / 2,bar_loc_y,scale_x / 2,bar_loc_y);

%draw bar in right location
cgpenwid(bar_x);
cgpencol(color);
cgdraw(coordinates(location),(-bar_y / 2)+bar_loc_y,coordinates(location),(bar_y / 2)+bar_loc_y);

cgpencol([1 1 1]);
cgfont(font,font_size);
for i = 1:length(question)
    cgtext(question{i},0,instruction_locations(i));
end
switch length(end_texts)
    case 1
        cgtext(end_texts{1},0,bar_text_y);
    case 2
        cgtext(end_texts{1},(-scale_x / 2) - text_distance_left,bar_text_y);
        cgtext(end_texts{2},(scale_x / 2) + text_distance_right,bar_text_y);
    case 3
        cgtext(end_texts{1},(-scale_x / 2) - text_distance_left,bar_text_y);
        cgtext(end_texts{2},0,bar_text_y);
        cgtext(end_texts{3},(scale_x / 2) + text_distance_right,bar_text_y);
end
%draw figure
if show_fig
    cgdrawsprite(9999,0,figure_y);
end
cgflip(backgroundColor);

[~,kp] = cgkeymap;
kp(kp~=0)=0; %set all to 0, in case someone pressed enter in between
while kp(28) == 0 %while enter has not been pressed, and location is not allowed to be in the middle


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
        for i = 1:length(question)
            cgtext(question{i},0,instruction_locations(i));
        end

        coordinates = [0:scale_x / (number_of_steps-1): scale_x] - scale_x/2;

        %draw scale
        cgpenwid(scale_y);
        cgpencol(color);
        cgdraw(-scale_x / 2,bar_loc_y,scale_x / 2,bar_loc_y);

        %draw bar in right location
        cgpenwid(bar_x);
        cgpencol(color);
        cgdraw(coordinates(location),(-bar_y / 2)+bar_loc_y,coordinates(location),(bar_y / 2)+bar_loc_y);

        cgpencol([1 1 1]);
        cgfont(font,font_size);
        switch length(end_texts)
            case 1
                cgtext(end_texts{1},0,bar_text_y);
            case 2
                cgtext(end_texts{1},(-scale_x / 2) - text_distance_left,bar_text_y);
                cgtext(end_texts{2},(scale_x / 2) + text_distance_right,bar_text_y);
            case 3
                cgtext(end_texts{1},(-scale_x / 2) - text_distance_left,bar_text_y);
                cgtext(end_texts{2},0,bar_text_y);
                cgtext(end_texts{3},(scale_x / 2) + text_distance_right,bar_text_y);
        end
        %draw figure
        if show_fig
            cgdrawsprite(9999,0,figure_y);
        end
        cgflip(backgroundColor);
    end



end
    
%% store the location
score = location;


end