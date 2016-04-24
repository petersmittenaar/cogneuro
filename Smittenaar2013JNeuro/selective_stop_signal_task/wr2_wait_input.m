function button_pressed = wr2_wait_input( sprite_key,x,y )
%p2_WAIT_INPUT draws sprite with key sprite_key and returns button pressed
%   
if nargin == 1
    x = 0;
    y = 0;
end

global params
cgsetsprite(0);
cgdrawsprite(sprite_key,x,y);
cgflip(params.background);
kp = 0;
wait(500)
cgkeymap
while isempty(find(kp, 1)); %wait for keypress
    [~,kp] = cgkeymap;
end
button_pressed = find(kp,1);    
cgflip(params.background);

end

