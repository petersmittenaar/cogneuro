function wr2_exp_instruction

global params

%% instructions
cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg1 = 'Here is a reminder for the experiment.';
msg4 = 'Red crosses through left circles means: IF there is a stop signal on the following trial, it''ll always be on the LEFT';
msg5 = 'Red crosses through right circles means: IF there is a stop signal on the following trial, it''ll always be on the RIGHT';
msg6 = 'Red crosses through all circles means: IF there is a stop signal on the following trial, it could be either left OR right';
msg7 = 'No red crosses (all circles white) means: there will NEVER be a stop signal on this trial';
msg8 = 'It is important you use this signal to prepare to stop your response in case the stop signal comes up!';
msg10 = 'Press a button to see examples';


cgmakesprite(301,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(301);
cgtext(msg1,0,params.text.instruction_location(1));
cgtext(msg4,0,params.text.instruction_location(5));
cgtext(msg5,0,params.text.instruction_location(6));
cgtext(msg6,0,params.text.instruction_location(7));
cgtext(msg7,0,params.text.instruction_location(8));
cgtext(msg8,0,params.text.instruction_location(10));
cgtext(msg10,0,params.text.instruction_location(13));

wr2_wait_input(301);

%show hints
cgmakesprite(302,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(302);
cgdrawsprite(120,-params.stimulus.instruction_x,params.stimulus.instruction_y,params.stimulus.instruction_size,params.stimulus.instruction_size);
cgdrawsprite(121,-params.stimulus.instruction_x,-params.stimulus.instruction_y,params.stimulus.instruction_size,params.stimulus.instruction_size);
cgdrawsprite(122,params.stimulus.instruction_x,-params.stimulus.instruction_y,params.stimulus.instruction_size,params.stimulus.instruction_size);
cgdrawsprite(123,params.stimulus.instruction_x,params.stimulus.instruction_y,params.stimulus.instruction_size,params.stimulus.instruction_size);

cgtext('Press a button to start the experiment',0,0);

wr2_wait_input(302);

end