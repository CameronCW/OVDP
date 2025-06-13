% Cameron Wade FYP
% Adaptive Threshold

%% Setup

filename = "C:\Users\camer\OneDrive - Imperial College London\Year 4\FYP\rawaudio.wav";
info = audioinfo(filename);
% [y,Fs] = audioread(filename);
[x,Fs] = audioread(filename);
y = x( ceil(1.39264*Fs):end , : );  %remove blank part of track

% player = audioplayer(Y,Fs);

fS = Fs;

% Signals
sampleRange = (4*Fs:7.5*Fs);
sampleRange = (1:8*Fs);

yLeft = y(:,1);
yRight = y(:,2);
ySlice = y(sampleRange,:);
yLeftSlice = ySlice(:,1);
yRightSlice = ySlice(:,2);

% player = audioplayer(Y,Fs);


%% POP DETECTION AND PLOTTING (and ALGORITHM EFFECTIVENESS ANALYSIS?)
% pops produce spikes in energy over short durations, this can be measured
% with Short time energy (STE), calculated using a window function and
% energy sum. An adaptive threshold is used for when this is crossed.

%Tune values:
% alphaSTE    = 1.05; %range 1-2, lower for greater sensistivity
% alphaSF     = 1.05;
alphaSTE    = 1.1; %range 1-2, lower for greater sensistivity
alphaSF     = 1.1;

%SHORT TIME ENERGY
frameLen = 128; hop = 64;   %2.9ms frames with 50% overlap between frames
frames = [buffer(yLeft, frameLen, frameLen-hop, 'nodelay') buffer(yRight, frameLen, frameLen-hop, 'nodelay')];
% win = hamming(frameLen); % Smooths sharper bursts
win = ones(frameLen,1);  % rectangular window
energy = sum((frames .* win).^2);
    %Adaptive threshold
threshold = medfilt1(energy, 11) * alphaSTE;
popFramesSTE = find(energy > threshold);
    %find popFrames position in original audio
popSamplesSTE = false(size(y));  %mask
for idx = popFramesSTE'
    startSample = (idx - 1) * hop + 1;
    endSample = min(startSample + frameLen - 1, length(y));
    popSamplesSTE(startSample:endSample) = true;
end

% yCleanSTE(popSamplesSTE) = medfilt1(y, 11)(popSamplesSTE);
yCleanSTE = y;
temp = medfilt1(y, 11); % median filter (both channels), returns Nx2
yCleanSTE(popSamplesSTE) = temp(popSamplesSTE); % Replace only detected samples


%SPECTRAL FLUX
nfft = 512; hop = 128;
spec = [abs(spectrogram(yLeft, hamming(nfft), nfft-hop, nfft)) abs(spectrogram(yRight, hamming(nfft), nfft-hop, nfft))];
% flux = sum(diff(spec,1,2).^2, 1); %may not be spiked by broadband
S = [abs(spectrogram(yLeft, hamming(128), 64, 256)) abs(spectrogram(yRight, hamming(128), 64, 256))];
flux = sum(diff(S,1,2).^2,1);  % will spike on bursts (spectral flatness)

    % Adaptive threshold
threshold = movmedian(flux, 11) * alphaSF;
popFramesSF = find(flux > threshold);
    %find popFrames position in original audio
popSamplesSF = false(size(y));  %mask
for idx = popFramesSF'
    startSample = (idx - 1) * hop + 1;
    endSample = min(startSample + frameLen - 1, length(y));
    popSamplesSF(startSample:endSample) = true;
end

% yCleanSF(popSamplesSF) = medfilt1(y, 11)(popSamplesSF);
yCleanSF = y;
temp = medfilt1(y, 11); % median filter (both channels), returns Nx2
yCleanSF(popSamplesSF) = temp(popSamplesSF); % Replace only detected samples

yClean=y;
yClean(popSamplesSTE) = temp(popSamplesSTE); % Replace only detected samples
yClean(popSamplesSF) = temp(popSamplesSF); % Replace only detected samples
% match = popSamplesSTE && popSamplesSF;


%% Bandstop for the sampling frequency noise
f1 = 13500; f2 = 14000;

% Normalized frequencies
Wn = [f1 f2] / (fS/2);

% Design filter
[b, a] = butter(4, Wn, 'stop');  % 4th-order bandstop

% Apply
yFiltered = filter(b, a, yClean);


%% Compare results

fprintf("Original");
playAudio(y(sampleRange),fS);
fprintf("Cleaned");
playAudio(yClean(sampleRange),fS);
fprintf("filtered cleaned");
playAudio(yFiltered(sampleRange),fS);

%% PLOT

figure
subplot(3,1,1)
plotSpectrogram(y,fS,"SignalPlot");
subplot(3,1,2)
plotSpectrogram(yClean,fS,"SignalPlot");
subplot(3,1,3)
plotSpectrogram(yFiltered,fS,"SignalPlot");


% plot detections
markerSTE = double(popSamplesSTE);  % convert logical to double (0/1)
markerSF  = double(popSamplesSF);

% Optional: OR to combine detections
markerCombined = double(popSamplesSTE | popSamplesSF);

% Plot
figure;
plot(markerSTE, 'r'); hold on;
plot(markerSF, 'b');
plot(markerCombined, 'k');
legend('STE', 'SF', 'Combined');
xlabel('Sample Index');
ylabel('Pop Detection (1 = pop)');
title('Pop Detection Markers');
ylim([-0.1 1.1]);




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