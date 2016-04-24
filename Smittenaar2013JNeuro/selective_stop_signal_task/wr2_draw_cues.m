function wr2_draw_cues(layout)
%wr2_DRAW_CUES Draws 4 circles. Can take either a 1 (pinkies), 2 (index) or
%a 2x2 matrix representing the 4 squares with 0s for empty circles, 1s for
%full circles, 2 for stop signal

global params

%% input checking

if numel(layout) == 1 %if single number
    switch layout
        case 1 %ring, means top 2 should be filled
            cues = [1 1;0 0];
        case 2 %index fingers
            cues = [0 0;1 1];
    end
elseif size(layout) == [2 2] %#ok<BDSCA>
    cues = layout;
else
    error('either input 1 (middle), 2 (index) or a 2x2 matrix');
end

%% draw cues

sprites = [102 101 111]; %101 is go, 102 is nogo, 111 is stop
cues = cues + 1; %to make them compatible with sprites

cgdrawsprite(sprites(cues(1,1)),-params.stimulus.cues,params.stimulus.cues); %left top
cgdrawsprite(sprites(cues(1,2)),params.stimulus.cues,params.stimulus.cues); %right top
cgdrawsprite(sprites(cues(2,1)),-params.stimulus.cues,-params.stimulus.cues); %left bottom
cgdrawsprite(sprites(cues(2,2)),params.stimulus.cues,-params.stimulus.cues); %right bottom

cgflip(params.background);



end

