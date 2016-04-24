function [premature] = wr2_fixation( duration )
%p2_FIXATION shows fixation, length depending on input phase. Returns
%duration of fixation. Also returns whether a response was made during
%fixation

global params




premature = 0;

cgpencol(params.text.color);
cgfont(params.text.font,50);
cgtext('+',0,0);
cgflip(params.background);

%if this is anticipation phase, clear keymap and check if there was a response during anticipation
cgkeymap;
wait(duration);
[~,kp]=cgkeymap;

if sum(find(kp)) > 0
    premature = 1;
end

cgkeymap

end

