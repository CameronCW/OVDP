% CAMERON WADE FYP
%% AutoCorrelation calculator with Dual Thresholding (3x3 Grid)

%% Setup
filename = "C:\Users\camer\OneDrive - Imperial College London\Year 4\FYP\rawaudio.wav";
info = audioinfo(filename);
[y,fS] = audioread(filename);
Fs = fS;

% Signals
sampleRange = (4*fS:7.5*fS);
yLeft = y(:,1);

%% Parameters
frameLen = 256; hop = 128;
threshFactors = [0.6 0.7 0.8];
upperFactors = [1.2 1.3 1.4];

x = yLeft;
nFrames = floor((length(x) - frameLen) / hop);
autoEnergy = zeros(1, nFrames);
timeAxis = zeros(1, nFrames);

for k = 1:nFrames
    startIdx = (k-1)*hop + 1;
    frame = x(startIdx : startIdx + frameLen - 1);
    r = xcorr(frame, 'coeff');
    autoEnergy(k) = sum(r.^2);
    timeAxis(k) = (startIdx + frameLen/2) / fS;
end

medAuto = movmedian(autoEnergy, 11);

% Preallocate audio versions
xCleanGrid = cell(3,3);
xCleanLIGrid = cell(3,3);
popMasks = cell(3,3);

figure(1); clf;
for i = 1:3
    for j = 1:3
        lowerThresh = threshFactors(i) * medAuto;
        upperThresh = upperFactors(j) * medAuto;

        % Pop detection
        popFrames = find(autoEnergy > upperThresh | autoEnergy < lowerThresh);
        popSamplesAuto = false(size(x));
        for idx = popFrames
            startSample = (idx - 1) * hop + 1;
            endSample = min(startSample + frameLen - 1, length(x));
            popSamplesAuto(startSample:endSample) = true;
        end

        % Smoothing
        smoothed = movmean(x, 9, 'Endpoints', 'shrink');
        xClean = x;
        xClean(popSamplesAuto) = smoothed(popSamplesAuto);
        xCleanGrid{i,j} = xClean;

        % Linear interpolation
        valid = ~popSamplesAuto;
        xLI = x;
        xLI(popSamplesAuto) = interp1(find(valid), x(valid), find(popSamplesAuto), 'linear', 'extrap');
        xCleanLIGrid{i,j} = xLI;

        % Store mask for playback and debug
        popMasks{i,j} = popSamplesAuto;

        % Plot
        subplot(3,3,(i-1)*3+j);
        plot(timeAxis, autoEnergy, 'b'); hold on;
        plot(timeAxis, lowerThresh, 'g--');
        plot(timeAxis, upperThresh, 'r--');
        stem(timeAxis(popFrames), autoEnergy(popFrames), 'k', 'Marker', 'none');
        title(sprintf('L=%.2f U=%.2f', threshFactors(i), upperFactors(j)));
        xlabel('Time (s)'); ylabel('Energy');
        grid on;
    end
end

figure(2);
subplot(3,1,1);
plotSpectrogram(x, fS, 'Original');
subplot(3,1,2);
plotSpectrogram(xCleanGrid{2,2}, fS, 'Cleaned MA (0.7/1.3)');
subplot(3,1,3);
plotSpectrogram(xCleanLIGrid{2,2}, fS, 'Cleaned LI (0.7/1.3)');

%% Playback 3x3
for i = 1:3
    for j = 1:3
        fprintf("\n--- Playback for L=%.2f, U=%.2f ---\n", threshFactors(i), upperFactors(j));
        fprintf("Original\n");
        playAudio(x(sampleRange), Fs);
        fprintf("Moving Average Cleaned\n");
        playAudio(xCleanGrid{i,j}(sampleRange), Fs);
        fprintf("Linear Interp Cleaned\n");
        playAudio(xCleanLIGrid{i,j}(sampleRange), Fs);
    end
end

%% PlotSpectrogram
function plotSpectrogram(x, fs, Title)
    x = mean(x, 2);
    window = hamming(1024);
    noverlap = 512;
    nfft = 2048;
    spectrogram(x, window, noverlap, nfft, fs, 'yaxis');
    title(Title);
    ylim([0 fs/2000]);
    colorbar;
end

%% Play audio
function playAudio(x,fs)
    recObj = audioplayer(x,fs); 
    playblocking(recObj);
end
