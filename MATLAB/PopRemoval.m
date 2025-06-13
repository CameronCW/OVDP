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
% centerFreq = 880;  % Center frequency of notch (880 Hz)
% bandwidth = 70;    % Bandwidth (70 Hz)
%     % Create the notch filter
% d = designfilt('bandstopiir', 'FilterOrder', 2, ...
%                'HalfPowerFrequency1', centerFreq - bandwidth / 2, ...
%                'HalfPowerFrequency2', centerFreq + bandwidth / 2, ...
%                'DesignMethod', 'butter', 'SampleRate', Fs);
% 
%     % Apply the filter
% y_filtered = filter(d, y); 
% 

%% Autocorrelation calculation


% Compute Autocorrelation

[acor, lag] = xcorr(yLeft, 'coeff');  %only single channel however, repeat for both?

% Plot the Autocorrelation
figure;
plot(lag / Fs, acor);
xlabel('Lag (s)');
ylabel('Autocorrelation');
title('Autocorrelation of Audio Signal');

threshold = 0.05;  % Adjust based on noise level
spikes = find(abs(acor) > threshold);

yFilteredLeft  = medfilt1(yLeft , 5);  % Apply a median filter
yFilteredRight = medfilt1(yRight, 5);

yFiltered = cat(2,yFilteredLeft,yFilteredRight);   % yFiltered = size of length,2

t = (0:length(yLeft)-1) / Fs;

figure
subplot(2,1,1);
plot(t, y);
title('Original Audio with Pops');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, yFiltered);
title('Filtered Audio (Pops Removed)');
xlabel('Time (s)');
ylabel('Amplitude');


%% POP DETECTION AND PLOTTING (ALGORITHM EFFECTIVENESS ANALYSIS

% Compute short-term energy to detect pops
frameSize = 1024;  % Frame size for energy computation
numFrames = floor(length(yLeft) / frameSize);
energy = zeros(numFrames, 1);

for i = 1:numFrames
    frame = yLeft((i-1)*frameSize + 1 : i*frameSize);
    energy(i) = sum(frame.^2);  % Compute energy
end

% Set threshold (adjust based on noise level)
threshold = mean(energy) + 5 * std(energy);  
popIndices = find(energy > threshold);  % Find frames with noise pops
numPops = length(popIndices);  % Count pops

% Log the results
fprintf('Detected %d noise pops in the track.\n', numPops);

t = (0:numFrames-1) * (frameSize / Fs);  % Time vector for frames

figure;
plot(t, energy);
hold on;
scatter(t(popIndices), energy(popIndices), 'r', 'filled');  % Mark pops in red
title('Short-Term Energy and Detected Pops');
xlabel('Time (s)');
ylabel('Energy');
legend('Energy', 'Detected Pops');
hold off;


%% Play recordings

% fprintf("playing recorded\n")
% recObj = audioplayer(y,Fs); 
% play(recObj);
% 
% 
% pause(length(y) / Fs);
% 
% fprintf("playing filtered\n");
% 
% filtered_recObj = audioplayer(yFiltered,Fs);
% play(filtered_recObj);

%% PLOT
    %setup
nfft = 4096;   % Adjust for frequency resolution
window = 2048; % Trade-off between time and frequency resolution
overlap = 1024;
multiplier = 1;
nSamples = length(yFiltered);

% fvtool(d); % Plot the frequency response of filter (audioProcessing)

%plot single FFT of signal, white noise, signal filtered and white noise
%filtered

% fplot() %what was I going to plot?

% Compute magnitude and normalize it
magnitude = abs(y) / nSamples;
f = zeros(1, floor(nSamples/2));
magnitude = magnitude(1:floor(nSamples/2));  % Positive frequencies only
f = f(1:floor(nSamples/2));  % Positive frequencies only

% Plot the magnitude of the FFT
figure;
plot(f, magnitude);
title('Magnitude Spectrum of White Noise');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
ylim([0 20000]);


%% PLOT SIGNALS

%plot white noise filtered
[s, f, t] = spectrogram(whiteFiltered, 8*window, 8*overlap, 8*nfft, Fs);
imagesc(t, f, abs(s));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Spectrogram');
colorbar;
ylim([0 20000]); % Limit display to 20 kHz




%plot signal filtered

% s = spectrogram(yLeft);
% spectrogram(yLeft,'yaxis');


[s, f, t] = spectrogram(yLeft, 8*window, 8*overlap, 8*nfft, Fs);
imagesc(t, f, abs(s));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Spectrogram');
colorbar;
ylim([0 20000]); % Limit display to 20 kHz


