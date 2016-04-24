function wr2_premature
%p2_PREMATURE if subjects pressed button during anticipation
%   Detailed explanation goes here

global params;

cgpencol([1 0 0]);
cgfont(params.text.font,50);
cgtext('too early!',0,0);

cgflip(params.background)
wait(params.trial.feedback_duration);

end

