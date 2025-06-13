%% CAMERON WADE FYP
% compare_noise_removal_methods.m
% Applies various denoising methods and compares SNR using a synthetic noisy signal

numRuns = 100;
snrAll = zeros(numRuns, 5);  % columns: [orig, med, mean, li, pchip]

Fs = 44100; t = 0:1/Fs:2;

for run = 1:numRuns
    % Simulate sung/music-like signal with wideband harmonic content
    clean = 0.25*sin(2*pi*110*t) + 0.3*sin(2*pi*440*t) + ...
        0.2*sin(2*pi*660*t) + 0.2*sin(2*pi*880*t) + ...
        0.15*sin(2*pi*1760*t) + 0.1*sin(2*pi*3520*t) + ...
        0.07*sin(2*pi*7040*t) + 0.05*sin(2*pi*14080*t);

    % Noise generation:
    crackle_idx = randperm(length(clean), 6000);  % double density
    crackle = zeros(size(clean));
    crackle(crackle_idx) = 0.0075 * randn(size(crackle_idx));  % half energy

    pop_times = round(rand(1, 100) * (length(clean)-100));
    pop_durs = randi([5, 20], size(pop_times));
    pops = zeros(size(clean));
    for i = 1:length(pop_times)
        pops(pop_times(i):(pop_times(i)+pop_durs(i))) = 0.2 * randn(1, pop_durs(i)+1);
    end

    click_idx = randi([1 length(clean)], [1 80]);
    clicks = zeros(size(clean));
    clicks(click_idx) = sign(randn(1,80)) .* (0.25 + rand(1,80));  % half energy

    noise = crackle + pops + clicks;
    noisy = clean + noise;
    trueNoiseIdx = abs(noise) > 0.001;

    % Vectorised application of filters
    xStack = repmat(noisy, 5, 1);
    masks = repmat(trueNoiseIdx, 5, 1);
    valid = ~masks;
    idx = 1:length(noisy);

    % Median
    med = medfilt1(noisy, 11);
    xStack(2, masks(2,:)) = med(masks(2,:));
    % Mean
    mov = movmean(noisy, 11);
    xStack(3, masks(3,:)) = mov(masks(3,:));
    % Linear interp
    xStack(4, masks(4,:)) = interp1(idx(valid(4,:)), noisy(valid(4,:)), idx(masks(4,:)), 'linear', 'extrap');
    % PCHIP interp
    xStack(5, masks(5,:)) = interp1(idx(valid(5,:)), noisy(valid(5,:)), idx(masks(5,:)), 'pchip', 'extrap');

    % SNRs
    snrAll(run,1) = 10*log10(var(clean) / var(noisy - clean));
    for i = 2:5
        snrAll(run,i) = 10*log10(var(clean) / var(xStack(i,:) - clean));
    end

    if run == numRuns
        t = t(1:length(noisy));
        figure;
        plot(t(1:5000), noisy(1:5000)); hold on;
        plot(t(1:5000), clean(1:5000));
        title('Clean vs Noisy Signal Segment');
        legend('Noisy','Clean'); xlabel('Time (s)');

        fprintf("Clean\n");        soundsc(clean, Fs); pause(2.2);
        fprintf("Noisy\n");        soundsc(noisy, Fs); pause(2.2);
        fprintf("Cleaned yMed\n"); soundsc(xStack(2,:), Fs); pause(2.2);
        fprintf("Cleaned yMean\n");soundsc(xStack(3,:), Fs); pause(2.2);
        fprintf("Cleaned yLI\n");  soundsc(xStack(4,:), Fs); pause(2.2);
        fprintf("CleanedPCHIP\n"); soundsc(xStack(5,:), Fs); pause(2.2);
    end
end

% Average SNR over all runs
fprintf("\nAverage SNR over %d runs:\n", numRuns);
snrAvg = mean(snrAll);
fprintf("Original: %.2f\nMedian:   %.2f\nMean:     %.2f\nLinear:   %.2f\nPCHIP:    %.2f\n", ...
    snrAvg(1), snrAvg(2), snrAvg(3), snrAvg(4), snrAvg(5));

% Plot average SNR as bar graph
figure;
bar(snrAvg);
title('Average SNR Over 100 Runs'); ylabel('SNR (dB)');
set(gca, 'XTickLabel', {'Original','Median','Mean','Linear','PCHIP'});
grid on;
