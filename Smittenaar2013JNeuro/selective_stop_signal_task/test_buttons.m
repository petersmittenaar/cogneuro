config_serial(1)
config_display(0,3,[0 0 0])
start_cogent

cgkeymap
button = 0;
while button ~= 16 %while not q pressed
    ks = cgkeymap;
    button = find(ks,1);
    
    if isempty(button)
        button = 0;
    else
        disp(button);
        wait(300)
    end
end

stop_cogent
