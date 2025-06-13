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

%% Try multiple threshold multipliers and plot results
alphaVals = [0.2, 0.6, 0.7, 0.8, 0.85, 0.9, 0.95, 0.975, 1.0];  % Adjust as needed
nAlpha = numel(alphaVals);
xCleanAll = zeros(length(x), nAlpha);

for i = 1:nAlpha
    alpha = alphaVals(i);
    threshold_i = movmedian(autoEnergy, 11) * alpha;
    popFrames_i = find(autoEnergy > threshold_i);

    % Map frames to sample positions
    popMask_i = false(size(x));
    for idx = popFrames % suppression width greatly reduced from 256 to 10
        mid = (idx-1)*hop + round(frameLen/2);
%         win = 10;  % 10 samples around center]
        win = 50;  
        s = max(1, mid-win);
        e = min(length(x), mid+win);
        popMask(s:e) = true;
    end

    % Apply smoothing
    tempSmooth = movmean(x, 9, 'Endpoints', 'shrink');
    xClean_i = x;
    xClean_i(popMask_i) = tempSmooth(popMask_i);
    xCleanAll(:, i) = xClean_i;
end


%Linear interpolation
% valid = ~popSamplesAuto;
% xCleanLI = x;
% xCleanLI(popSamplesAuto) = interp1(find(valid), x(valid), find(popSamplesAuto), 'linear', 'extrap');

%% Plot all spectrograms in a figure
figure(3);
subplot(nAlpha+1, 1, 1);
plotSpectrogram(x, fS, 'Original');

for i = 1:nAlpha
    subplot(nAlpha+1, 1, i+1);
    label = sprintf('alpha = %.1f', alphaVals(i));
    plotSpectrogram(xCleanAll(:,i), fS, label);
end




%% Compare
fprintf("play original signal");
playAudio(x(sampleRange),fS)


for i = 1:nAlpha
    fprintf("Playing cleaned signal (alpha = %.1f)\n", alphaVals(i));
    playAudio(xCleanAll(sampleRange, i), fS);
    pause(1);  
end



fprintf("play cleaned signal");
playAudio(xClean(sampleRange),fS);
% fprintf("play cleaned Lin Interp signal");
% playAudio(xCleanLI(sampleRange),fS);

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