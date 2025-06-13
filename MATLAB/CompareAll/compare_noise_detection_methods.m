%% CAMERON WADE FYP
% Detection evaluation with simulated removal and noise contribution using multiple detection methods

plotPlayback = true;  % Set to false to disable audio playback
numRuns = 100;
detectionMethods = {'STE','SF','MED','AUTO','CQT'};

% Preallocate results
snrAll = zeros(numRuns, length(detectionMethods), 2); % [runs x methods x noise types]
snrOrigAll = zeros(numRuns, 2);
tpAll = zeros(numRuns, length(detectionMethods), 2);
fpAll = zeros(numRuns, length(detectionMethods), 2);
fnAll = zeros(numRuns, length(detectionMethods), 2);

Fs = 44100; t = 0:1/Fs:2;
signalLen = length(t);

for mode = 1:2
    useTransientNoise = (mode == 1);

    for run = 1:numRuns
        clean = 0.3*sin(2*pi*220*t) + 0.25*sin(2*pi*440*t) + 0.2*sin(2*pi*880*t) + 0.1*sin(2*pi*1760*t);
        noise = zeros(size(clean));

        if useTransientNoise
            crackle = zeros(size(clean));
            crackle_idx = randperm(length(clean), 400);
            crackle(crackle_idx) = 0.015 * randn(size(crackle_idx));

            pops = zeros(size(clean));
            pop_times = round(rand(1, 6) * (length(clean)-100));
            for i = 1:length(pop_times)
                dur = randi([10, 20]);
                pops(pop_times(i):(pop_times(i)+dur)) = 0.4 * randn(1, dur+1);
            end
            noise = crackle + pops;
        else
            noise = 0.02 * randn(size(clean));
            mask = rand(size(clean)) < 0.05;
            noise = noise .* mask;
        end

        noisy = clean + noise;
        trueNoiseIdx = abs(noise) > 0.003;

        frameLen = 128; hop = 64;
        detList = {
            detect_ste(noisy, frameLen, hop),
            detect_spectral_flux(noisy, frameLen, hop),
            detect_median_energy(noisy, frameLen, hop),
            detect_autocorrelation(noisy, frameLen, hop),
            detect_cqt(noisy, Fs, frameLen)
        };

        for m = 1:length(detList)
            sampleMask = frame_indices(detList{m}, frameLen, hop, signalLen);
            clipLen = min([length(sampleMask), length(trueNoiseIdx)]);
            sampleMask = sampleMask(1:clipLen);
            trueNoise = trueNoiseIdx(1:clipLen);
            cleanClipped = clean(1:clipLen);
            noisyClipped = noisy(1:clipLen);

            sampleMask = sampleMask(:);
            trueNoise = trueNoise(:);
            tp = sum(sampleMask & trueNoise);
            fp = sum(sampleMask & ~trueNoise);
            fn = sum(~sampleMask & trueNoise);

            tpAll(run, m, mode) = tp;
            fpAll(run, m, mode) = fp;
            fnAll(run, m, mode) = fn;

            denoised = noisyClipped;
            denoised(sampleMask & trueNoise) = cleanClipped(sampleMask & trueNoise);
            tempMed = medfilt1(noisyClipped, 11);
            denoised(sampleMask & ~trueNoise) = tempMed(sampleMask & ~trueNoise);

            if m == 1
                snrOrigAll(run, mode) = 10 * log10(var(cleanClipped) / var(noisyClipped - cleanClipped));
            end
            snrAll(run, m, mode) = 10 * log10(var(cleanClipped) / var(denoised - cleanClipped));

            if run == numRuns
                switch m
                    case 1, finalSTE = sampleMask;
                    case 2, finalSF = sampleMask;
                    case 3, finalMED = sampleMask;
                    case 4, finalAUTO = sampleMask;
                    case 5, finalCQT = sampleMask;
                end
                finalClean = cleanClipped;
                finalNoisy = noisyClipped;
                finalTrue = trueNoise;
            end
        end
    end

    % TABLE OUTPUT
    methods = [{'Original'}, detectionMethods];
    snrSummary = [mean(snrOrigAll(:,mode)), mean(squeeze(snrAll(:,:,mode)), 1)];
    tpSummary = [mean(sum(tpAll(:,:,mode),1)), mean(tpAll(:,:,mode), 1)];
    fpSummary = [NaN, mean(fpAll(:,:,mode), 1)];
    fnSummary = [NaN, mean(fnAll(:,:,mode), 1)];

    if mode == 1
        label = 'Transient Noise';
    else
        label = 'Baseband Noise';
    end

    fprintf('\n--- Detection Results for %s ---\n', label);
    statsTable = table(methods', snrSummary', tpSummary', fpSummary', fnSummary', ...
        'VariableNames', {'Method','AvgSNR','TruePos','FalsePos','FalseNeg'});
    disp(statsTable);

    %% PLOTS
    tFull = (0:length(finalClean)-1)/Fs;
    frameT = linspace(0, tFull(end), length(finalSTE));
    subRow = mode;

    % Figure 1: Full overlay
    figure(1); subplot(2,1,subRow); cla;
    plot(tFull, finalNoisy); hold on;
    plot(tFull, finalClean);
    scatter(frameT(finalSTE), 0.4*ones(1,sum(finalSTE)), 10, 'r', 'filled');
    scatter(frameT(finalSF), 0.45*ones(1,sum(finalSF)), 10, 'g', 'filled');
    scatter(frameT(finalMED), 0.5*ones(1,sum(finalMED)), 10, 'b', 'filled');
    scatter(frameT(finalAUTO), 0.55*ones(1,sum(finalAUTO)), 10, 'm', 'filled');
    scatter(frameT(finalCQT), 0.6*ones(1,sum(finalCQT)), 10, 'c', 'filled');
    scatter(tFull(finalTrue), 0.65*ones(1,sum(finalTrue)), 10, 'k');
    title(sprintf('Overlay of Clean, Noisy, and Detection Markers (%s)', label));
    xlabel('Time (s)'); ylabel('Amplitude');
    legend('Noisy','Clean','STE','SF','MED','AUTO','CQT','True Noise');

    % Figure 2: Bar SNR
    figure(2); subplot(2,1,subRow); cla;
    snrAvg = mean(squeeze(snrAll(:,:,mode)), 1);
    bar([mean(snrOrigAll(:,mode)), snrAvg]);
    title(sprintf('Average SNR Over 100 Runs (%s)', label));
    ylabel('SNR (dB)');
    set(gca, 'XTickLabel', ['Original', detectionMethods]);
    grid on;

    % Figure 3: Middle zoom (0.15s)
    figure(3); subplot(2,1,subRow); cla;
    tMidStart = round(length(finalClean)/2 - 0.075*Fs);
    tMidEnd = tMidStart + round(0.15*Fs) - 1;
    tMid = tFull(tMidStart:tMidEnd);
    plot(tMid, finalNoisy(tMidStart:tMidEnd)); hold on;
    plot(tMid, finalClean(tMidStart:tMidEnd));
    scatter(tMid(finalSTE(tMidStart:tMidEnd)), 0.4*ones(1,sum(finalSTE(tMidStart:tMidEnd))), 10, 'r', 'filled');
    scatter(tMid(finalSF(tMidStart:tMidEnd)), 0.45*ones(1,sum(finalSF(tMidStart:tMidEnd))), 10, 'g', 'filled');
    scatter(tMid(finalMED(tMidStart:tMidEnd)), 0.5*ones(1,sum(finalMED(tMidStart:tMidEnd))), 10, 'b', 'filled');
    scatter(tMid(finalAUTO(tMidStart:tMidEnd)), 0.55*ones(1,sum(finalAUTO(tMidStart:tMidEnd))), 10, 'm', 'filled');
    scatter(tMid(finalCQT(tMidStart:tMidEnd)), 0.6*ones(1,sum(finalCQT(tMidStart:tMidEnd))), 10, 'c', 'filled');
    scatter(tMid(finalTrue(tMidStart:tMidEnd)), 0.65*ones(1,sum(finalTrue(tMidStart:tMidEnd))), 10, 'k');
    title(sprintf('Overlay (Middle 0.15s Segment) (%s)', label));
    xlabel('Time (s)'); ylabel('Amplitude');
    legend('Noisy','Clean','STE','SF','MED','AUTO','CQT','True Noise');
end


%% Optional Playback
if plotPlayback
    fprintf("Playing clean\n");    soundsc(finalClean, Fs); pause(2.2);
    fprintf("Playing noisy\n");    soundsc(finalNoisy, Fs); pause(2.2);
end

%% --- Subfunctions ---
function [detections] = detect_ste(x, frameLen, hop)
    frames = buffer(x, frameLen, frameLen - hop, 'nodelay');
    energy = sum(frames.^2);
    threshold = medfilt1(energy, 11) * 1.1;
    detections = energy > threshold;
end

function [detections] = detect_spectral_flux(x, frameLen, hop)
    S = abs(spectrogram(x, hamming(frameLen), frameLen-hop, 256));
    flux = sum(diff(S,1,2).^2,1);
    threshold = movmedian(flux, 11) * 1.1;
    detections = [0 (flux > threshold)];
end

function [detections] = detect_median_energy(x, frameLen, hop)
    frames = buffer(x, frameLen, frameLen - hop, 'nodelay');
    energy = sum(frames.^2);
    medEnergy = medfilt1(energy, 5);
    detections = energy > medEnergy * 1.1;
end

function [detections] = detect_autocorrelation(x, frameLen, hop)
    frames = buffer(x, frameLen, frameLen-hop, 'nodelay');
    autoEnergy = zeros(1, size(frames, 2));
    for k = 1:size(frames,2)
        ac = xcorr(frames(:,k), 'coeff');
        autoEnergy(k) = sum(abs(ac));
    end
    threshold = movmedian(autoEnergy, 11)*1.1;
    detections = autoEnergy > threshold;
end

function [detections] = detect_cqt(x, Fs, frameLen)
    cqtX = cqt(x, 'SamplingFrequency', Fs, 'BinsPerOctave', 24, 'FrequencyLimits', [500 8000]);
    cqtMag = abs(cqtX.c);
    energyCQT = sum(cqtMag.^2, 1);
    medEnergy = medfilt1(energyCQT, 11);
    threshold = medEnergy * 1.1;
    detections = energyCQT > threshold;
end

function y = median_filter(x, mask)
    y = x;
    med = medfilt1(x, 11);
    y(mask) = med(mask);
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
