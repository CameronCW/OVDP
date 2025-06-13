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
