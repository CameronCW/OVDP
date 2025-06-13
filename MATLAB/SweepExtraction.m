% Cameron Wade FYP
% Audio sweep extraction to extract signal
filename = "C:\Users\camer\OneDrive - Imperial College London\Year 4\FYP\rawaudio.wav";
info = audioinfo(filename);
[y,Fs] = audioread(filename);
% player = audioplayer(Y,Fs);

yLeft = y(:,1);
yRight = y(:,2);

[y, Fs] = audioread(filename);  % Load noisy sweep
t = (0:length(y)-1) / Fs;  

% Generate reference chirp (assuming known parameters)
f0 = 440;  % Start frequency (Hz)
f1 = 14400;  % End frequency (Hz)
% T = t(end);  % Duration
T = 10*Fs;  % Duration
referenceSweep = chirp(t, f0, T, f1, 'logarithmic');

% Matched filter (cross-correlation)
 filteredSignal = xcorr(y, referenceSweep, 'normalized');
