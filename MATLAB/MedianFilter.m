% Cameron Wade FYP
% Median Filter

%% Setup

filename = "C:\Users\camer\OneDrive - Imperial College London\Year 4\FYP\rawaudio.wav";
info = audioinfo(filename);
[y,Fs] = audioread(filename);
% player = audioplayer(Y,Fs);


fS = Fs;

% Signals
sampleRange = (4*Fs:7.5*Fs);

yLeft = y(:,1);
yRight = y(:,2);
ySlice = y(sampleRange,:);
yLeftSlice = ySlice(:,1);
yRightSlice = ySlice(:,2);

% player = audioplayer(Y,Fs);





%% POP DETECTION AND PLOTTING (ALGORITHM EFFECTIVENESS ANALYSIS
    % Use of median Filter
    % median filters effectively soften data by taking median averages of
    % neighbouring samples, whilst maintaing 

% [x, fs] = audioread('audio.wav');
x = yLeft; fs = fS;
x = highpass(x, 1000, fs);
frameLen = 256; % at 44.1kHz → ~5.8ms
hop = 128;     % 50% overlap
frames = buffer(x, frameLen, frameLen-hop, 'nodelay');
energy = sum(frames.^2);
medEnergy = medfilt1(energy, 11);       % medEnergy is the median filter of energy
popIdx = find(energy > 1.5 * medEnergy); % increase sensitivity by decreasing the multiplier for medianEnergy
popTimes = (popIdx-1) * hop / fs; % in seconds %TODO FIXME

popSamples = false(size(x)); % logical mask over full signal

for idx = popIdx'
    startSample = (idx-1)*hop + 1;
    stopSample = min(startSample + frameLen - 1, length(x));
    popSamples(startSample:stopSample) = true;
end

% Now popSamples is a mask for where pops occur in x
xFiltered = x;
% xFiltered(popSamples) = movmean(x, 11)(popSamples); % or simple zeroing/interp


% yFilteredLeft  = medfilt1(yLeftSlice , 5);  % Apply a median filter
% yFilteredRight = medfilt1(yRightSlice, 5);
% yFiltered = cat(2,yFilteredLeft,yFilteredRight);   % yFiltered = size of length,2
figure;
title('Audio Energy with Pops');
xlabel('Time (s)');
ylabel('Amplitude');
plot(medEnergy);
hold on
plot( (energy / 1.5)*ones(length(medEnergy)) );

figure;
title('Audio Energy with Pops');
xlabel('Time (s)');
ylabel('Amplitude');
plot(x);
hold on;
plot(popIdx,x(popIdx), '-x');


%% PLOT

figure
plotSpectrogram(y,fS,"Original audio spectrogram");

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



%% Compare
% fprintf("play original signal");
% playAudio(x,fs)
fprintf("play cleaned signal");
playAudio(xClean(sampleRange),fs);




%% FUNCTIONS

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