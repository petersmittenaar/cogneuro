function fft_peter(signal,fs)
% fft_peter(signal,fs) takes your Nx1 vector 
% and plots the frequency spectrum. 
% If you give only 1 argument, every row corresponds to a timestep of 1 
% (so if you find a peak at bin 20 and 
% each timestep is 10 ms, it's 5 Hz signal). 
% If you give 2, then the second one should be sampling Hz (i.e. 1/time
% between samples in signal)
% 
% Adapted from http://dadorran.wordpress.com/2014/02/20/plotting-frequency-spectrum-using-matlab/
% 
% PS, 2014

assert(ismatrix(signal) && size(signal,2)==1 && size(signal,1)>1,'invalid input, rtfm')
if ~exist('fs','var'), fs = []; end
if isempty(fs), fs = 1; end

N=length(signal);
X_mags = abs(fft(signal));
bin_vals = [0 : N-1];
fax_Hz = bin_vals*fs/N;
N_2 = ceil(N/2);
figure
plot(fax_Hz(1:N_2), X_mags(1:N_2))
xlabel('Frequency (Hz)')
ylabel('Magnitude');
title('Single-sided Magnitude spectrum (Hertz)');
axis tight




end

