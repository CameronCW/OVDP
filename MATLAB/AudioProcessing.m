% Cameron Wade FYP
% Audio processing pop removal
filename = "C:\Users\camer\OneDrive - Imperial College London\Year 4\FYP\rawaudio.wav";
info = audioinfo(filename);
[y,Fs] = audioread(filename);
% player = audioplayer(Y,Fs);

%% Setup

fS = Fs;

% Signals
sampleRange = (4*Fs:7.5*Fs);

yLeft = y(:,1);
yRight = y(:,2);
ySlice = y(sampleRange,:);
yLeftSlice = ySlice(:,1);
yRightSlice = ySlice(:,2);





%% Filtering attempt
centerFreq = 880;  % Center frequency of notch (880 Hz)
bandwidth = 70;    % Bandwidth (70 Hz)
    % Create the notch filter
d = designfilt('bandstopiir', 'FilterOrder', 2, ...
               'HalfPowerFrequency1', centerFreq - bandwidth / 2, ...
               'HalfPowerFrequency2', centerFreq + bandwidth / 2, ...
               'DesignMethod', 'butter', 'SampleRate', Fs);

fvtool(d); % Plot the frequency response of filter


    % Apply the filter
y_filtered = filter(d, ySlice);


%% Autocorrelation calculation
    % PreRequisite Needs yLeft for single channel
    %TODO set the threshold as 0.15
    %loop through different thresholds

% Compute Autocorrelation
[acor, lag] = xcorr(yLeftSlice, 'coeff');  

% Plot the Autocorrelation
figure;
plot(lag / Fs, acor);
xlabel('Lag (s)');
ylabel('Autocorrelation');
title('Autocorrelation of Audio Signal');

threshold = 0.05;  % Adjust based on noise level
spikes = find(abs(acor) > threshold);

yFilteredLeft  = medfilt1(yLeftSlice , 5);  % Apply a median filter
yFilteredRight = medfilt1(yRightSlice, 5);
yFiltered = cat(2,yFilteredLeft,yFilteredRight);   % yFiltered = size of length,2


    % before after comparison
t = (0:length(yLeftSlice)-1) / Fs;
figure
subplot(2,1,1);
plot(t, yLeftSlice);
title('Original Audio with Pops');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, yFilteredLeft);
title('Filtered Audio (Pops Removed)');
xlabel('Time (s)');
ylabel('Amplitude');


%% Play recordings

% fprintf("playing recorded")
% recObj = audioplayer(y,Fs); 
% play(recObj);
% 
% pause(length(y) / Fs);
% 
% fprintf("playing filtered");
% 
% filtered_recObj = audioplayer(yFiltered,Fs);
% play(filtered_recObj);


%% White noise test
nSamples = length(y);
whiteNoise = 0.5 * randn(nSamples, 1);  % Amplitude scaled to [-0.5, 0.5]
whiteFiltered = filter(d,whiteNoise);

%% PLOT
    %setup
nfft = 4096;   % Adjust for frequency resolution
window = 2048; % Trade-off between time and frequency resolution
overlap = 1024;
multiplier = 1;


fvtool(d); % Plot the frequency response of filter

%plot single FFT of signal, white noise, signal filtered and white noise
%filtered

% fplot() %what was I going to plot?

% Compute magnitude and normalize it
magnitude = abs(y) / nSamples;
f = zeros(1, floor(nSamples/2));
magnitude = magnitude(1:floor(nSamples/2));  % Positive frequencies only
f = f(1:floor(nSamples/2));  % Positive frequencies only

% Plot the magnitude of the FFT
% figure;
plot(f, magnitude);
title('Magnitude Spectrum of White Noise');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
% ylim([0 20000]);


%% PLOT SIGNALS

fS = Fs;

figure
subplot(3,1,1); 
plotSpectrogram(whiteFiltered, fS, 'WhiteFiltered');

% %plot white noise filtered
% [s, f, t] = spectrogram(whiteFiltered, 8*window, 8*overlap, 8*nfft, Fs);
% imagesc(t, f, abs(s));
% axis xy;
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% title('Spectrogram');
% colorbar;
% ylim([0 20000]); % Limit display to 20 kHz
% 



yFilteredLeft = highpass(yLeft, 20, fS);
subplot(3,1,2); 
plotSpectrogram(yLeft, fS, 'highPass');


% figure
% plot(abs(fft(yLeft)))
% xlim([1 22050]) % Check if high frequencies exist


% window1 = 1024; % Window size
% overlap1 = window1 / 2; % 50% overlap
% nfft1 = 2048; % FFT points
% fS = Fs;
% 
% spectrogram(yFilteredLeft, window1, overlap1, nfft1, fS, 'yaxis');
% colorbar;
% title('Spectrogram of Audio Signal attempt 2');
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% ylim([20 20000]); % Limit display to 20 kHz


subplot(3,1,3); 
plotSpectrogram(yFilteredLeft, fS, 'filtered');


%plot signal filtered

% s = spectrogram(yLeft);
% spectrogram(yLeft,'yaxis');
% 
% 
% [s, f, t] = spectrogram(yLeft, 8*window, 8*overlap, 8*nfft, Fs);
% imagesc(t, f, abs(s));
% axis xy;
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% title('Spectrogram');
% colorbar;
% ylim([0 20000]); % Limit display to 20 kHz



%% Play recordings - SLICE

% sampleRange = (4*Fs:7.5*Fs);
% ySlice = y(sampleRange,2);


fprintf("playing recorded\n")
% recObj = audioplayer(y,Fs); 
recObj = audioplayer(ySlice,Fs); 
play(recObj);

pause(length(ySlice) / Fs);

% recObj = audioplayer(y,Fs); 
% play(recObj);
% pause(length(ySlice) / Fs);

fprintf("playing filtered");

filtered_recObj = audioplayer(y_filtered,Fs);
play(filtered_recObj);



%% PlotSpectrogram
function plotSpectrogram(x, fs,Title)
        %figure
        %subplot(2,1,1); 
        % ax = gca; %for current axis in figure
        %plotSpectrogram(x, fs, 'Spectrogram');
    x = mean(x, 2); % mono
    window = hamming(1024);
    noverlap = 512;
    nfft = 2048;
    spectrogram(x, window, noverlap, nfft, fs, 'yaxis');
    title(Title);
    ylim([0 fs/2000]); % kHz scale
    colorbar;
end