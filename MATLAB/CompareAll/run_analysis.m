%% Cameron Wade FYP
% Master script to run noise detection and removal analysis end-to-end

% --- CONFIGURATION ---
filename = "C:\\Users\\camer\\OneDrive - Imperial College London\\Year 4\\FYP\\rawaudio.wav";
plotPlayback = false;              % true to hear playback after cleaning

% --- LOAD AND SLICE AUDIO ---
[x, Fs] = audioread(filename);
x = mean(x, 2);  % mono
x = x(1:min(length(x), 10*Fs));
t = (0:length(x)-1)/Fs;

% --- NOISE DETECTION ---
fprintf("Running noise detection...\n");
[detSTE, ~]  = detect_ste(x, 256, 128);      % Threshold: median*1.1
[detSF, ~]   = detect_spectral_flux(x, 256, 128); % Threshold: movmedian*1.1
[detMed, ~]  = detect_median_energy(x, 256, 128); % Threshold: medfilt1*1.1
[detAuto, ~] = detect_autocorrelation(x, 256, 128); % Threshold: movmedian*1.1
[detCQT, ~]  = detect_cqt(x, Fs, 256);       % Threshold: median*1.1

% --- COMBINE DETECTION MASK (aligned length)
minLen = min([length(detSTE), length(detSF), length(detMed), length(detAuto), length(detCQT)]);
detMask = detSTE(1:minLen) | detSF(1:minLen) | ...
          detMed(1:minLen) | detAuto(1:minLen) | detCQT(1:minLen);

% --- Map frame detections to sample index ---
detIdx = frame_indices(detMask, 256, 128, length(x));

% --- PLOT: Detected Pops Overlay on Waveform ---
figure;
plot(t, x); hold on;
plot(t(detIdx), x(detIdx), 'rx');
title('Original Audio with Detected Pops');
xlabel('Time (s)'); ylabel('Amplitude'); legend('Signal', 'Detected Noise');

% --- PLOT: Spectrogram with Detection Overlays ---
frameT = linspace(0, t(end), minLen);
figure;
spectrogram(x, hamming(1024), 512, 2048, Fs, 'yaxis'); hold on;
title('Spectrogram with All Detection Methods');
ylim([0 Fs/2000]); colorbar;

% Overlay individual detections with unique markers
scatter(frameT(detSTE(1:minLen)==1), 1.5*ones(sum(detSTE(1:minLen)),1), 8, 'r', 'filled');
scatter(frameT(detSF(1:minLen)==1),  2.0*ones(sum(detSF(1:minLen)),1), 8, 'g', 'filled');
scatter(frameT(detMed(1:minLen)==1), 2.5*ones(sum(detMed(1:minLen)),1), 8, 'b', 'filled');
scatter(frameT(detAuto(1:minLen)==1), 3.0*ones(sum(detAuto(1:minLen)),1), 8, 'k', 'filled');
scatter(frameT(detCQT(1:minLen)==1),  3.5*ones(sum(detCQT(1:minLen)),1), 8, 'm', 'filled');
legend('Spectrogram','STE','SF','Median','Autocorr','CQT');

% --- SNR BEFORE CLEANING ---
% SNR is estimated as ratio of signal variance outside detected regions to noise variance inside
snrBefore = estimate_snr(x, detIdx);

% --- APPLY DENOISING METHODS ---
yMed   = median_filter(x, detIdx);
yMean  = mean_filter(x, detIdx);
yLI    = linear_interp(x, detIdx);
yPCHIP = pchip_interp(x, detIdx);

% --- SNR AFTER CLEANING ---
snrMed   = estimate_snr(x, find_noise(yMed, x));
snrMean  = estimate_snr(x, find_noise(yMean, x));
snrLI    = estimate_snr(x, find_noise(yLI, x));
snrPCHIP = estimate_snr(x, find_noise(yPCHIP, x));

% --- PLOT RESULTS ---
figure;
bar([snrBefore, snrMed, snrMean, snrLI, snrPCHIP]);
title('SNR Comparison Before and After Noise Removal');
ylabel('SNR (dB)');
set(gca, 'XTickLabel', {'Original','Median','Mean','Linear','PCHIP'});
grid on;

% --- DISPLAY STATS ---
fprintf("\nSNR is calculated as signal variance outside detected pop regions divided by noise variance inside.\n");
fprintf("SNR Results (dB):\n");
fprintf("Original: %.2f\n", snrBefore);
fprintf("Median:   %.2f\n", snrMed);
fprintf("Mean:     %.2f\n", snrMean);
fprintf("Linear:   %.2f\n", snrLI);
fprintf("PCHIP:    %.2f\n", snrPCHIP);

% --- OPTIONAL PLAYBACK ---
if plotPlayback
    fprintf("Playing PCHIP cleaned audio...\n");
    soundsc(yPCHIP, Fs);
end


%% NOISE DETECTION
% detect_noise_methods.m
% Multi-method noise detection in audio with adaptive thresholds

function detect_noise_methods(filename, plotPlayback)
    if nargin < 2
        plotPlayback = false;
    end

    %% Setup
    [x, Fs] = audioread(filename);
    x = mean(x, 2); % mono
    t = (0:length(x)-1)/Fs;

    % Segment (optional, or set to full signal)
    maxSamples = min(length(x), 10*Fs);
    sampleRange = 1:maxSamples;
    x = x(sampleRange);
    t = t(sampleRange);

    %% Parameters
    frameLen = 256; hop = 128;
    nfft = 512;

    %% Detection methods
    [detSTE, steEnergy] = detect_ste(x, frameLen, hop);
    [detSF, sfFlux] = detect_spectral_flux(x, frameLen, hop);
    [detMed, ~] = detect_median_energy(x, frameLen, hop);
    [detAuto, ~] = detect_autocorrelation(x, frameLen, hop);
    [detCQT, ~] = detect_cqt(x, Fs, frameLen);

    %% Plot 1: Detection comparison
    figure;
    subplot(2,1,1); plot(t, x); title('Audio Signal'); xlabel('Time (s)'); ylabel('Amplitude');
    subplot(2,1,2); hold on;
    plot(detSTE, 'r'); plot(detSF, 'g'); plot(detMed, 'b');
    plot(detAuto, 'k'); plot(detCQT, 'm');
    legend('STE','Spectral Flux','Median Energy','Autocorrelation','CQT');
    title('Noise Detection Markers'); xlabel('Frame Index'); ylabel('Detection (1=True)');
    ylim([-0.1 1.1]);

    %% Plot 2: Spectrogram with markers
    figure;
    spectrogram(x, hamming(1024), 512, 2048, Fs, 'yaxis');
    title('Spectrogram with Detected Noise Regions');
    ylim([0 Fs/2000]);
    hold on;
    frameT = linspace(0, t(end), length(detSTE));
    scatter(frameT(detSTE==1), 0.5*ones(sum(detSTE),1), 10, 'r', 'filled');
    scatter(frameT(detSF==1), 1.0*ones(sum(detSF),1), 10, 'g', 'filled');
    scatter(frameT(detCQT==1), 1.5*ones(sum(detCQT),1), 10, 'm', 'filled');

    %% Playback if needed
    if plotPlayback
        soundsc(x, Fs);
    end
end

%% --- Subfunctions ---

function [detections, energy] = detect_ste(x, frameLen, hop)
    frames = buffer(x, frameLen, frameLen - hop, 'nodelay');
    energy = sum(frames.^2);
    threshold = medfilt1(energy, 11) * 1.1;
    detections = energy > threshold;
end

function [detections, flux] = detect_spectral_flux(x, frameLen, hop)
    S = abs(spectrogram(x, hamming(frameLen), frameLen-hop, 256));
    flux = sum(diff(S,1,2).^2,1);
    threshold = movmedian(flux, 11) * 1.1;
    detections = [0 (flux > threshold)];
end

function [detections, medEnergy] = detect_median_energy(x, frameLen, hop)
    [~, energy] = detect_ste(x, frameLen, hop);
    medEnergy = medfilt1(energy, 5);
    detections = energy > medEnergy * 1.1;
end

function [detections, autoEnergy] = detect_autocorrelation(x, frameLen, hop)
    frames = buffer(x, frameLen, frameLen-hop, 'nodelay');
    autoEnergy = zeros(1, size(frames, 2));
    for k = 1:size(frames,2)
        ac = xcorr(frames(:,k), 'coeff');
        autoEnergy(k) = sum(abs(ac));
    end
    threshold = movmedian(autoEnergy, 11)*1.1;
    detections = autoEnergy > threshold;
end

function [detections, energyCQT] = detect_cqt(x, Fs, frameLen)
    cqtX = cqt(x, 'SamplingFrequency', Fs, 'BinsPerOctave', 36, 'FrequencyLimits', [500 8000]);
    cqtMag = abs(cqtX.c);
    energyCQT = sum(cqtMag.^2, 1);
    medEnergy = medfilt1(energyCQT, 11);
    threshold = medEnergy * 1.1;
    detections = energyCQT > threshold;
end


%% NOISE REMOVAL

%% CAMERON WADE FYP
% remove_noise_methods.m
% Applies various denoising methods and compares SNR

function remove_noise_methods(filename, plotPlayback)
    if nargin < 2
        plotPlayback = false;
    end

    %% Load and prepare audio
    [x, Fs] = audioread(filename);
    x = mean(x,2); % mono
    x = x(1:min(10*Fs,end));
    t = (0:length(x)-1)/Fs;

    %% Detect pops using STE (as baseline mask)
    [detMask, ~] = detect_ste(x, 256, 128);
    detIdx = frame_indices(detMask, 256, 128, length(x));

    %% Original SNR estimate
    xNoisy = x;
    snrOriginal = estimate_snr(x, detIdx);

    %% Denoising Methods
    yMed = median_filter(x, detIdx);
    yMean = mean_filter(x, detIdx);
    yLI   = linear_interp(x, detIdx);
    yPCHIP = pchip_interp(x, detIdx);

    %% Re-run detection on denoised signals
    snrMed   = estimate_snr(x, find_noise(yMed, x));
    snrMean  = estimate_snr(x, find_noise(yMean, x));
    snrLI    = estimate_snr(x, find_noise(yLI, x));
    snrPCHIP = estimate_snr(x, find_noise(yPCHIP, x));

    %% Plot results
    methods = {'Original','Median','Mean','Linear Interp','PCHIP'};
    snrs = [snrOriginal, snrMed, snrMean, snrLI, snrPCHIP];

    figure;
    bar(snrs);
    title('SNR Comparison After Noise Removal');
    ylabel('SNR (dB)');
    set(gca, 'XTickLabel', methods);

    %% Optional Playback
    if plotPlayback
        fprintf('Playing PCHIP Interpolated Audio\n');
        soundsc(yPCHIP, Fs);
    end
end

%% --- Subfunctions ---

function y = median_filter(x, mask)
    y = x;
    med = medfilt1(x, 11);
    y(mask) = med(mask);
end

function y = mean_filter(x, mask)
    y = x;
    mov = movmean(x, 11);
    y(mask) = mov(mask);
end

function y = linear_interp(x, mask)
    y = x;
    idx = 1:length(x);
    valid = ~mask;
    y(mask) = interp1(idx(valid), x(valid), idx(mask), 'linear', 'extrap');
end

function y = pchip_interp(x, mask)
    y = x;
    idx = 1:length(x);
    valid = ~mask;
    y(mask) = interp1(idx(valid), x(valid), idx(mask), 'pchip', 'extrap');
end

function snrVal = estimate_snr(clean, noisyIdx)
    noiseEst = clean(noisyIdx);
    signalEst = clean(~noisyIdx);
    snrVal = 10 * log10(var(signalEst)/var(noiseEst));
end

function idx = frame_indices(mask, frameLen, hop, totalLen)
    idx = false(totalLen,1);
    for i = 1:length(mask)
        if mask(i)
            start = (i-1)*hop + 1;
            stop = min(start + frameLen - 1, totalLen);
            idx(start:stop) = true;
        end
    end
end

function noiseIdx = find_noise(yEst, xTrue)
    diff = yEst - xTrue;
    noiseIdx = abs(diff) > 0.01; % adjustable threshold
end

