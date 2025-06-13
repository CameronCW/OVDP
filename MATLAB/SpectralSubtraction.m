% CAMERON WADE
% FYP - Spectral Subtraction Based Denoising with Automatic Noise Profile

clear; close all; clc;

%% --- PARAMETERS ---
filename = "C:\Users\camer\OneDrive - Imperial College London\Year 4\FYP\Testing\2hour\AnalogueDrivers_noVertical_noProcessing.wav"; % Good silent section but make sure not the part with no signal
segmentStart = 50;  % [s] segment to evaluate before/after cleaning
segmentEnd = 60;    % [s]
noiseWinSec = 5;    % duration of quiet segment to use as noise model

% Spectrogram params
window = hamming(513);  % matches number of STFT bins: nfft/2 + 1
noverlap = 512;
nfft = 1024;

%% --- LOAD AUDIO ---
[y, Fs] = audioread(filename); % stereo
if size(y,2) == 1
    y = [y, y]; % mono to stereo
end

%% --- IMPROVED AUTOMATIC NOISE SEGMENT DETECTION ---
%   completely silent sections ignored
frameLength = round(noiseWinSec * Fs);
stepSize = round(0.5 * Fs); % 50% overlap
totalSamples = size(y,1);
minRMS = inf;
quietStartIdx = -1;

minDbRMS = -60;  % dBFS minimum to avoid true silence
minAbsRMS = 10^((minDbRMS)/20);  % convert dB to linear RMS threshold

for i = 1:stepSize:(totalSamples - frameLength)
    seg = y(i:i+frameLength-1, :);
    segRMS = mean(rms(seg, 1)); % mean RMS over channels
    if all(segRMS > minAbsRMS) && mean(segRMS) < minRMS
        minRMS = mean(segRMS);
        quietStartIdx = i;
    end
end

if quietStartIdx < 0
    error('No suitable noise segment found — all candidates are too silent.');
end

quietSegment = y(quietStartIdx:quietStartIdx+frameLength-1, :);
quietTime = (quietStartIdx / Fs);
fprintf('Detected quiet-but-not-silent segment at %.2f - %.2f s (%.2f dB RMS)\n', ...
        quietTime, quietTime + noiseWinSec, 20*log10(minRMS));

%% --- EXTRACT SEGMENT TO CLEAN ---
segmentSamples = round(segmentStart * Fs) : round(segmentEnd * Fs);
ySegment = y(segmentSamples, :);  % segment of interest

%% --- COMPUTE NOISE PROFILE ---
[SnL, ~, ~] = spectrogram(quietSegment(:,1), window, noverlap, nfft, Fs);
[SnR, ~, ~] = spectrogram(quietSegment(:,2), window, noverlap, nfft, Fs);
noisePowerL = mean(abs(SnL).^2, 2);
noisePowerR = mean(abs(SnR).^2, 2);

%% --- SEGMENT SPECTROGRAM + SUBTRACTION ---
[SfL, f, t] = spectrogram(ySegment(:,1), window, noverlap, nfft, Fs);
[SfR, ~, ~] = spectrogram(ySegment(:,2), window, noverlap, nfft, Fs);

magL = abs(SfL); phaseL = angle(SfL);
magR = abs(SfR); phaseR = angle(SfR);

cleanMagL = max(magL.^2 - noisePowerL, 0);
cleanMagR = max(magR.^2 - noisePowerR, 0);

cleanSpecL = sqrt(cleanMagL) .* exp(1i * phaseL);
cleanSpecR = sqrt(cleanMagR) .* exp(1i * phaseR);

%% --- RECONSTRUCT CLEAN AUDIO ---
if size(cleanSpecL, 2) >= 2
    yCleanL = istft(cleanSpecL, Fs, 'Window', window, 'OverlapLength', noverlap, 'FFTLength', nfft);
    yCleanR = istft(cleanSpecR, Fs, 'Window', window, 'OverlapLength', noverlap, 'FFTLength', nfft);
else
    warning('Not enough STFT frames for ISTFT. Skipping inverse transform.');
    yCleanL = ySegment(:,1);
    yCleanR = ySegment(:,2);
end

minLen = min([length(yCleanL), length(ySegment)]);
ySegment = ySegment(1:minLen, :);
yClean = [yCleanL(1:minLen), yCleanR(1:minLen)];

%% --- SNR EVALUATION ON SEGMENT ---
origSeg = ySegment;
cleanSeg = yClean;
noiseSeg = origSeg - cleanSeg;

snrL = 10*log10(var(origSeg(:,1)) / var(noiseSeg(:,1)));
snrR = 10*log10(var(origSeg(:,2)) / var(noiseSeg(:,2)));

fprintf('SNR Left Channel: %.2f dB\n', snrL);
fprintf('SNR Right Channel: %.2f dB\n', snrR);

%% --- PLOT: Spectrograms ---
figure;
subplot(2,1,1);
spectrogram(mean(ySegment,2), window, noverlap, nfft, Fs, 'yaxis');
title('Original Audio Segment Spectrogram'); ylim([0 Fs/2000]);
subplot(2,1,2);
spectrogram(mean(yClean,2), window, noverlap, nfft, Fs, 'yaxis');
title('Cleaned Audio Segment Spectrogram'); ylim([0 Fs/2000]);

%% --- PLOT: Waveform and Quiet Region ---
tFull = (0:length(y)-1)/Fs;
figure;
plot(tFull, y(:,1)); hold on;
region = [quietStartIdx, quietStartIdx+frameLength-1] / Fs;
area(region([1 2 2 1]), [min(y(:,1)) min(y(:,1)) max(y(:,1)) max(y(:,1))], ...
     'FaceColor', [1 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
title('Waveform with Detected Quiet Segment'); xlabel('Time (s)'); ylabel('Amplitude');

%% --- PLAYBACK ---
fprintf('Playing Quiet segment\n');
playAudio(quietSegment,Fs);

fprintf('Playing original segment\n');
playAudio(origSeg,Fs);
% playAudio(origSeg(segmentStart*Fs:segmentEnd*Fs,2),Fs);
% soundsc(origSeg, Fs);
% pause(segmentEnd - segmentStart + 1);

fprintf('Playing cleaned segment\n');
playAudio(cleanSeg,Fs);
% playAudio(cleanSeg(segmentStart*Fs:segmentEnd*Fs,2),Fs);
% soundsc(cleanSeg, Fs);
% pause(segmentEnd - segmentStart + 1);

%% --- DEBUG ---
fprintf('=== DEBUG ===\n');
fprintf('Signal samples in segment: %d\n', size(ySegment,1));
fprintf('cleanSpecL: %d freq bins × %d frames\n', size(cleanSpecL,1), size(cleanSpecL,2));
fprintf('Window length: %d\n', length(window));
fprintf('Remaining non-zero bins: %.1f%%\n', ...
    100 * sum(cleanMagL(:) > 0) / numel(cleanMagL));
    fprintf('ISTFT can proceed? %d\n', size(cleanSpecL,2) >= 2);


%% Play audio
function playAudio(x,fs)
    recObj = audioplayer(x,fs); 
    play(recObj);
    pause(length(x) / fs);
end