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
