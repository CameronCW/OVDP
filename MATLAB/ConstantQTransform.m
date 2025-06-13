% Cameron Wade FYP
% Pop Detection Using Constant-Q Transform (CQT)
% Median Filtering vs Linear Interpolation vs PCHIP Interpolation vs Wavelet Denoising

clear; close all; clc;

%% --- PARAMETERS (Adjustable) ---
filename = "C:\Users\camer\OneDrive - Imperial College London\Year 4\FYP\rawaudio.wav";

% Detection parameters (TUNED)
detectFmin = 1000;             % Min freq (Hz) for CQT analysis
applyHighpass = true;          % Apply highpass for detection only?
highpassCutoff = 800;          % Highpass filter cutoff (Hz)

frameLen = 128;                % Frame length for pop marking (shorter for better localization)
thresholdMultiplier = 1.05;    % Sensitivity: lower = more sensitive
medianFilterOrder = 5;         % Median filter order for suppression
interpolationMethod = 'linear'; % 'linear' or 'pchip'

% CQT parameters
binsPerOctave = 48;             % CQT bins per octave

% Spectrogram parameters
scaler = 4; % 2^{-scaler}

windowLen = 256 * 2^(-scaler);   % STFT window length
noverlap = 128 * 2^(-scaler);    % Overlap for STFT
nfft = 512 * 2^(-scaler);        % NFFT for STFT

% Sample range (seconds to focus)
startTime = 4;  % seconds
endTime   = 9;  % seconds

%% --- LOAD AUDIO ---

info = audioinfo(filename);
[y, Fs] = audioread(filename); % Stereo audio

% Derived parameters
sampleRange = (startTime * Fs : endTime * Fs);
fmax = Fs / 2;  % Nyquist
numOctaves = ceil(log2(fmax / detectFmin)); % Dynamically calculate

% Original signals
yLeft = y(:,1);
yRight = y(:,2);

xLeftSliceOriginal = yLeft(sampleRange);
xRightSliceOriginal = yRight(sampleRange);

% Highpass-filtered version for detection
if applyHighpass
    yLeftDetect = highpass(yLeft, highpassCutoff, Fs);
    yRightDetect = highpass(yRight, highpassCutoff, Fs);
else
    yLeftDetect = yLeft;
    yRightDetect = yRight;
end

xLeftSliceDetect = yLeftDetect(sampleRange);
xRightSliceDetect = yRightDetect(sampleRange);

% Mono mix for detection
xMonoSliceDetect = mean([xLeftSliceDetect, xRightSliceDetect], 2);

%% --- CQT Pop Detection ---

cqtX = cqt(xMonoSliceDetect, 'SamplingFrequency', Fs, ...
                'BinsPerOctave', binsPerOctave, ...
                'FrequencyLimits', [detectFmin, fmax]);

% Energy over time
cqtMag = abs(cqtX.c);
energyCQT = sum(cqtMag.^2, 1);  % Power spectrum

% Median energy and threshold
medEnergy = medfilt1(energyCQT, 11);
threshold = thresholdMultiplier * medEnergy;

% Pop detection
popIdx = find(energyCQT > threshold);
hop = frameLen / 2;

popSamples = false(size(xMonoSliceDetect));

for idx = popIdx
    startSample = (idx - 1) * hop + 1;
    stopSample = min(startSample + frameLen - 1, length(xMonoSliceDetect));
    popSamples(startSample:stopSample) = true;
end

fprintf('Detected %d pop regions.\n', sum(popSamples));

%% --- Pop Removal ---

% Preallocate
xLeftMedianFiltered = xLeftSliceOriginal;
xRightMedianFiltered = xRightSliceOriginal;
xLeftInterpFiltered = xLeftSliceOriginal;
xRightInterpFiltered = xRightSliceOriginal;
xLeftPchipFiltered = xLeftSliceOriginal;
xRightPchipFiltered = xRightSliceOriginal;

% Median filter intermediate signals
intermediate1 = medfilt1(xLeftSliceOriginal, medianFilterOrder);
intermediate2 = medfilt1(xRightSliceOriginal, medianFilterOrder);

% Replace pops with median filter
xLeftMedianFiltered(popSamples) = intermediate1(popSamples);
xRightMedianFiltered(popSamples) = intermediate2(popSamples);

% Linear interpolation replacement
popLocs = find(popSamples);
validLocs = find(~popSamples);

xLeftInterpFiltered(popLocs) = interp1(validLocs, xLeftSliceOriginal(validLocs), popLocs, interpolationMethod, 'extrap');
xRightInterpFiltered(popLocs) = interp1(validLocs, xRightSliceOriginal(validLocs), popLocs, interpolationMethod, 'extrap');

% PCHIP interpolation replacement
xLeftPchipFiltered(popLocs) = interp1(validLocs, xLeftSliceOriginal(validLocs), popLocs, 'pchip', 'extrap');
xRightPchipFiltered(popLocs) = interp1(validLocs, xRightSliceOriginal(validLocs), popLocs, 'pchip', 'extrap');

% Wavelet denoising (only pop regions)
[xLeftWaveletFiltered, xRightWaveletFiltered] = waveletDenoiseSelective(xLeftSliceOriginal, xRightSliceOriginal, popSamples);

% Combine into stereo
yMedianFiltered = [xLeftMedianFiltered, xRightMedianFiltered];
yInterpFiltered = [xLeftInterpFiltered, xRightInterpFiltered];
yPchipFiltered = [xLeftPchipFiltered, xRightPchipFiltered];
yWaveletFiltered = [xLeftWaveletFiltered, xRightWaveletFiltered];
originalStereo = [xLeftSliceOriginal, xRightSliceOriginal];

%% --- Plot Energy vs Threshold ---

figure;
plot(energyCQT, 'b'); hold on;
plot(threshold, 'r--');
legend('Energy (CQT)', 'Threshold');
title('CQT Energy vs Threshold for Pop Detection');
xlabel('Frame Index');
ylabel('Energy');
grid on;

%% --- Spectrograms ---

figure;
titles = {'Original', 'Median Filtered', 'Linear Interpolated', 'PCHIP Interpolated', 'Wavelet Denoised'};
signals = {originalStereo, yMedianFiltered, yInterpFiltered, yPchipFiltered, yWaveletFiltered};

for i = 1:length(signals)
    subplot(5,1,i);
    spectrogram(mean(signals{i},2), windowLen, noverlap, nfft, Fs, 'yaxis');
    title([titles{i}, ' Audio Spectrogram']);
    ylim([0 10]); colorbar;
end
sgtitle('Spectrogram Comparison of Different Pop Removal Methods');

%% --- Overlay: Pop Detection on Signal ---

figure;
t = (0:length(xMonoSliceDetect)-1) / Fs;
plot(t, mean([xLeftSliceOriginal, xRightSliceOriginal], 2)); hold on;
plot(t(popSamples), mean([xLeftSliceOriginal(popSamples), xRightSliceOriginal(popSamples)], 2), 'rx');
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Audio with Detected Pops Overlay');
legend('Original Signal', 'Detected Pops');
grid on;

%% --- Playback for Comparison ---

fprintf("Playing Original Slice\n"); playAudio(originalStereo, Fs);
fprintf("Playing Median Filtered Audio\n"); playAudio(yMedianFiltered, Fs);
fprintf("Playing Linear Interpolated Audio\n"); playAudio(yInterpFiltered, Fs);
fprintf("Playing PCHIP Interpolated Audio\n"); playAudio(yPchipFiltered, Fs);
fprintf("Playing Wavelet Denoised Audio\n"); playAudio(yWaveletFiltered, Fs);

%% --- SNR Calculation ---

snrMedian = calcSNR(originalStereo, yMedianFiltered);
snrInterp = calcSNR(originalStereo, yInterpFiltered);
snrPchip = calcSNR(originalStereo, yPchipFiltered);
snrWavelet = calcSNR(originalStereo, yWaveletFiltered);

fprintf('SNR (Median Filtered): %.2f dB\n', snrMedian);
fprintf('SNR (Linear Interpolation): %.2f dB\n', snrInterp);
fprintf('SNR (PCHIP Interpolation): %.2f dB\n', snrPchip);
fprintf('SNR (Wavelet Denoised): %.2f dB\n', snrWavelet);

%% --- FUNCTIONS ---

function playAudio(x, Fs)
    player = audioplayer(x, Fs);
    playblocking(player);
end

function snrValue = calcSNR(clean, denoised)
    noise = clean - denoised;
    snrValue = 10 * log10( var(clean(:)) / var(noise(:)) );
end

function [leftDenoised, rightDenoised] = waveletDenoiseSelective(left, right, popSamples)
    % Denoise only the pop regions
    wavelet = 'db4';  % Daubechies 4
    levelL = min(5, wmaxlev(length(left), wavelet));
    levelR = min(5, wmaxlev(length(right), wavelet));

    [cL, lL] = wavedec(left, levelL, wavelet);
    sigmaL = median(abs(cL)) / 0.6745;
    thrL = sigmaL * sqrt(2 * log(length(cL)));
    denC_L = wthresh(cL, 's', thrL);
    leftDenoisedFull = waverec(denC_L, lL, wavelet);

    [cR, lR] = wavedec(right, levelR, wavelet);
    sigmaR = median(abs(cR)) / 0.6745;
    thrR = sigmaR * sqrt(2 * log(length(cR)));
    denC_R = wthresh(cR, 's', thrR);
    rightDenoisedFull = waverec(denC_R, lR, wavelet);

    % Only replace pop regions
    leftDenoised = left;
    rightDenoised = right;
    leftDenoised(popSamples) = leftDenoisedFull(popSamples);
    rightDenoised(popSamples) = rightDenoisedFull(popSamples);
end
