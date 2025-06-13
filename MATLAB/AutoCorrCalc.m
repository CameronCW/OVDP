%% AutoCorreltion calculator

%% Setup

filename = "C:\Users\camer\OneDrive - Imperial College London\Year 4\FYP\rawaudio.wav";
info = audioinfo(filename);
[y,fS] = audioread(filename);
% player = audioplayer(Y,fS);


Fs = fS;

% Signals
sampleRange = (4*fS:7.5*fS);

yLeft = y(:,1);
yRight = y(:,2);
ySlice = y(sampleRange,:);
yLeftSlice = ySlice(:,1);
yRightSlice = ySlice(:,2);

% player = audioplayer(Y,fS);


%% Calc autocorrelation
% For large spiking across all frequencies, then the autocorrelation value
% will change quickly , if these can be detected, those values can be
% suppressed


x = yLeft;


frameLen = 256; hop = 128;
nFrames = floor((length(x) - frameLen) / hop);
autoEnergy = zeros(1, nFrames);
timeAxis = zeros(1, nFrames);

for k = 1:nFrames
    startIdx = (k-1)*hop + 1;
    frame = x(startIdx : startIdx + frameLen - 1);
    r = xcorr(frame, 'coeff');           % Normalized autocorr
    autoEnergy(k) = sum(r.^2);           % Total autocorrelation energy
    timeAxis(k) = (startIdx + frameLen/2) / fS;  % Time in seconds
end



% Detect low autocorr frames
threshold = movmedian(autoEnergy, 11) * 0.7;  % or std-based
% popFramesAuto = find(autoEnergy < threshold);
popFramesAuto = find(autoEnergy > threshold);

% popFrames = find(autoEnergy < threshold);
popFrames = find(autoEnergy > threshold);
popTimes = timeAxis(popFrames);

% Now calculate the positions in the audio file
popSamplesAuto = false(size(x));

for idx = popFramesAuto
    startSample = (idx - 1) * hop + 1;
    endSample = min(startSample + frameLen - 1, length(x));
    popSamplesAuto(startSample:endSample) = true;
end

%Local moving average
xClean = x;
smoothed = movmean(x, 9, 'Endpoints', 'shrink');
xClean(popSamplesAuto) = smoothed(popSamplesAuto);

%Linear interpolation
valid = ~popSamplesAuto;
xCleanLI = x;
xCleanLI(popSamplesAuto) = interp1(find(valid), x(valid), find(popSamplesAuto), 'linear', 'extrap');


%% PLOT

% Plot autocorrelation energy and threshold
figure(1);
plot(timeAxis, autoEnergy, 'b'); hold on;
plot(timeAxis, threshold, 'r--');  % show threshold
stem(popTimes, threshold(popFrames), 'k', 'Marker', 'none');  % highlight pop points
xlabel('Time (s)');
ylabel('Autocorrelation Energy');
title('Short-Time Autocorrelation Energy with Pop Detections');
legend('Autocorr Energy', 'Threshold', 'Detected Pops');
grid on;

%Plot Spectrogram

figure(2)
subplot(3,1,1); 
plotSpectrogram(x, fS, 'input');

subplot(3,1,2); 
plotSpectrogram(xClean, fS, 'cleaned');

subplot(3,1,3); 
plotSpectrogram(xCleanLI, fS, 'cleaned Lin Interp');



%% Compare
fprintf("play original signal");
playAudio(x(sampleRange),fS)
fprintf("play cleaned signal");
playAudio(xClean(sampleRange),fS);
fprintf("play cleaned Lin Interp signal");
playAudio(xCleanLI(sampleRange),fS);

fprintf("finished");

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

%% Play audio
function playAudio(x,fs)
    recObj = audioplayer(x,fs); 
    play(recObj);
    pause(length(x) / fs);
end