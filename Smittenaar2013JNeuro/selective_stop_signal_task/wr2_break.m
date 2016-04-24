function wr2_break
%p2_BREAK show a message onscreen and waits

global params

cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg1 = ['You now have a ' num2str(params.task.break_duration) ' second break'];
msg2 = 'Remember, try to use the hint before each trial to prepare to stop your response!';


cgsetsprite(0);
cgtext(msg1,0,params.text.instruction_location(3));
cgtext(msg2,0,params.text.instruction_location(5));

cgflip(params.background);

wait((params.task.break_duration) * 1000);


msg1 = 'get ready! Press a button to continue';
cgsetsprite(0);
cgtext(msg1,0,0);
cgflip(params.background);
kp = 0;
cgkeymap

while isempty(find(kp, 1)); %wait for keypress
    [~,kp] = cgkeymap;
end

end

