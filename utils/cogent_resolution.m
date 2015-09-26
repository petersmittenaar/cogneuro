function out = cogent_resolution( in )
%COGENT_RESOLUTION Takes either a resolution ID (in cogent terms) or a
%resolution expressed in pixels, and returns the other.
% For example, you can give a value of 3, and the script returns a vector
% of [1024 768]. Or you give [1024 768] and the script returns 3. 
% screen resolution:
% 1=640x480
% 2=800x600
% 3=1024x768
% 4=1152x864
% 5=1280x1024
% 6=1600x1200
% 
% as used in:
% config_display( mode, resolution, background, foreground, 
%   fontname, fontsize, nbuffers, nbits, scale);

res = [
    1 640 480
    2 800 600
    3 1024 768
    4 1152 864
    5 1280 1024
    6 1600 1200
    ];

if length(in) == 1
    out = res(in,2:3);
elseif length(in) == 2
    out = res(res(:,2)==in(1) & res(:,3)==in(2),1);
else
    error('invalid input')
end

end

