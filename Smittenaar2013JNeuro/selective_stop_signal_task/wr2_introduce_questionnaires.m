function wr2_introduce_questionnaires

global params

cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg1 = 'Thanks! That was the main experiment.';
msg2 = 'Now you will get a number of questionnaires to go through.';
msg3 = 'Just follow the instructions given on the screen.';
msg4 = 'The questionnaires are the last part of this experiment';
msg5 = 'Press any key to continue';

cgmakesprite(302,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(302);
cgtext(msg1,0,params.text.instruction_location(1));
cgtext(msg2,0,params.text.instruction_location(2));
cgtext(msg3,0,params.text.instruction_location(3));
cgtext(msg4,0,params.text.instruction_location(4));
cgtext(msg5,0,params.text.instruction_location(5));

wr2_wait_input(302);



end

