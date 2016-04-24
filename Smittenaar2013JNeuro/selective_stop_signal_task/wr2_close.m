function wr2_close

global params;

cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

switch params.user.session
    case {3,6} %if in scanner
        msg1 = 'Thanks! End of block';
        msg2 = '';
    otherwise
        msg1 = 'Thank you very much for participating.';
        msg2 = 'Please call the experimenter or, if he''s not outside, please walk upstairs to reception.';
end

cgtext(msg1,0,params.text.instruction_location(1));
cgtext(msg2,0,params.text.instruction_location(2));


cgflip(params.background);

% display for each of 4 staircases what the mean of last 6 values was
try %because sometimes doesn't work
    for i = 1:4
        ssds = params.log(params.log(:,7)==i,6);
        params.ssds(i,1) = mean(ssds(end-5:end));
    end

    disp(params.ssds);
    disp('current ssds:')
    disp(params.task.ssd);
catch err
    disp(err)
    disp('params.ssds did not store average values. Only available is params.ssd')
end

save('logs\last_params','params');

wait(2000); %wait a bit (so subject can't press button and go to white screen)

end

