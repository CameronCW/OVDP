%% CAMERON WADE FYP
% compare_noise_removal_methods.m
% Applies various denoising methods and compares SNR using synthetic noisy signal for both transient and baseband noise
figure(1)
clf
figure(2)
clf
figure(3)
clf

numRuns = 100;
removalMethods = {'Original','Median','Mean','Linear','PCHIP'};

snrAll = zeros(numRuns, length(removalMethods), 2); % 3rd dim: [1 = transient, 2 = baseband]
noiseStd = zeros(numRuns, 2);
tpAll = zeros(numRuns, length(removalMethods), 2);
fpAll = zeros(numRuns, length(removalMethods), 2);
fnAll = zeros(numRuns, length(removalMethods), 2);

Fs = 44100; t = 0:1/Fs:2;

for mode = 1:2
    useTransientNoise = (mode == 1);

    for run = 1:numRuns
        % Simulate wideband harmonic clean signal
        clean = 0.25*sin(2*pi*110*t) + 0.3*sin(2*pi*440*t) + ...
            0.2*sin(2*pi*660*t) + 0.2*sin(2*pi*880*t) + ...
            0.15*sin(2*pi*1760*t) + 0.1*sin(2*pi*3520*t) + ...
            0.07*sin(2*pi*7040*t) + 0.05*sin(2*pi*14080*t);

        % Generate noise
        if useTransientNoise
            crackle = zeros(size(clean));
            crackle_idx = randperm(length(clean), 400);
            crackle(crackle_idx) = 0.015 * randn(size(crackle_idx));
            pops = zeros(size(clean));
            pop_times = round(rand(1, 8) * (length(clean)-100));
            for i = 1:length(pop_times)
                dur = randi([10, 20]);
                pops(pop_times(i):(pop_times(i)+dur)) = 0.4 * randn(1, dur+1);
            end
            noise = crackle + pops;
        else
            broadband = 0.05 * randn(size(clean));
            rumble = 0.03 * sin(2*pi*60*t) + 0.02 * sin(2*pi*120*t);
            noise = broadband + rumble;
        end

        noisy = clean + noise;
        trueNoiseIdx = abs(noise) > tern(useTransientNoise, 0.001, 0.1);  % used to compare detection or cleaning performance
        noiseStd(run, mode) = std(noise);

        denoisedSignals = {
            noisy,
            median_filter(noisy, trueNoiseIdx),
            mean_filter(noisy, trueNoiseIdx),
            linear_interp(noisy, trueNoiseIdx),
            pchip_interp(noisy, trueNoiseIdx)
        };

        for m = 1:length(removalMethods)
            y = denoisedSignals{m};
            snrAll(run, m, mode) = 10 * log10(var(clean) / var(y - clean));
            if m > 1
                % Basic false positive/negative from mask
                predMask = abs(y - noisy) > 0.001;
                predMask = predMask(:);
                trueMask = trueNoiseIdx(:);
                tpAll(run, m, mode) = sum(predMask & trueMask);
                fpAll(run, m, mode) = sum(predMask & ~trueMask);
                fnAll(run, m, mode) = sum(~predMask & trueMask);
            end
        end

        if run == numRuns
            finalClean = clean;
            finalNoisy = noisy;
        end
    end

    % Plot final example segment
    t = t(1:length(noisy));
    figure(1); subplot(2,1,mode);
    plot(t(1:5000), finalNoisy(1:5000)); hold on;
    plot(t(1:5000), finalClean(1:5000));
    title(sprintf('Clean vs Noisy Signal Segment (%s Noise)', tern(mode==1, 'Transient', 'Baseband')));
    legend('Noisy','Clean'); xlabel('Time (s)');
end

% --- Summary Statistics and Plotting ---
methods = removalMethods';

for mode = 1:2
    label = tern(mode==1, 'Transient Noise', 'Baseband Noise');
    snrAvg = mean(snrAll(:,:,mode));
    snrStdDev = std(snrAll(:,:,mode));
    tpMean = [NaN; squeeze(mean(tpAll(:,2:end,mode), 1))'];
    fpMean = [NaN; squeeze(mean(fpAll(:,2:end,mode), 1))'];
    fnMean = [NaN; squeeze(mean(fnAll(:,2:end,mode), 1))'];

    fprintf('\n--- Denoising Results for %s ---\n', label);
    fprintf("\nAverage SNR over %d runs (±std dev):\n", numRuns);
    for i = 1:length(snrAvg)
        fprintf("%s: %.2f dB (±%.2f dB)\n", methods{i}, snrAvg(i), snrStdDev(i));
    end

    % Table output
    removalTable = table(methods, snrAvg', snrStdDev', tpMean, fpMean, fnMean, ...
        'VariableNames', {'Method','AvgSNR','SNR_StdDev','TruePos','FalsePos','FalseNeg'});
    disp(removalTable);
    disp(table(mean(noiseStd(:,mode)), std(noiseStd(:,mode)), 'VariableNames', {'MeanNoiseStd','StdNoiseStd'}));

    % SNR Plot
    figure(2); subplot(2,1,mode);
    bar(snrAvg); hold on;
    errorbar(1:length(snrAvg), snrAvg, snrStdDev, 'k.');
    title(sprintf('Average SNR Over 100 Runs (%s)', label));
    ylabel('SNR (dB)');
    set(gca, 'XTickLabel', removalMethods);
    grid on;

    % Middle segment plot
    t = (0:length(finalClean)-1)/Fs;
    tMidStart = round(length(finalClean)/2 - 0.15*Fs);
    tMidEnd = tMidStart + round(0.3*Fs) - 1;
    tMid = t(tMidStart:tMidEnd);

    figure(3); subplot(2,1,mode);
    plot(tMid, finalNoisy(tMidStart:tMidEnd)); hold on;
    plot(tMid, finalClean(tMidStart:tMidEnd));
    title(sprintf('Middle 0.3s Overlay (%s)', label));
    xlabel('Time (s)'); ylabel('Amplitude');
    legend('Noisy','Clean');
end

% --- UTILITY FUNCTIONS ---
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

function out = tern(cond, valTrue, valFalse)
    if cond
        out = valTrue;
    else
        out = valFalse;
    end
end
