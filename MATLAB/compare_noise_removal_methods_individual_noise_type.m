%% CAMERON WADE FYP
% compare_noise_removal_methods_transient.m
% Evaluates multiple noise removal methods using simulated burst noise and compares SNR

plotPlayback = true;
numRuns = 100;
snrAll = zeros(numRuns, 5);  % [original, median, mean, linear, pchip]
tpAll = zeros(numRuns, 5);
fpAll = zeros(numRuns, 5);
fnAll = zeros(numRuns, 5);
noiseStds = zeros(numRuns, 1);

Fs = 44100; t = 0:1/Fs:2;

for run = 1:numRuns
    clean = 0.3*sin(2*pi*220*t) + 0.25*sin(2*pi*440*t) + ...
            0.2*sin(2*pi*880*t) + 0.1*sin(2*pi*1760*t);
    
%     % --- Simulate transient noise (pops and crackle) ---
%     crackle = zeros(size(clean));
%     crackle_idx = randperm(length(clean), 400);
%     crackle(crackle_idx) = 0.015 * randn(size(crackle_idx));
% 
%     pops = zeros(size(clean));
%     pop_times = round(rand(1, 6) * (length(clean)-100));
%     for i = 1:length(pop_times)
%         dur = randi([10, 20]);
%         pops(pop_times(i):(pop_times(i)+dur)) = 0.4 * randn(1, dur+1);
%     end

    % --- Simulate transient noise (more frequent, lower energy) ---
    % Crackle: very frequent, low-energy impulses
    crackle = zeros(size(clean));
    crackle_idx = randperm(length(clean), 10000);  % Increase number of events
    crackle(crackle_idx) = 0.003 * randn(size(crackle_idx));  % Lower energy
    
    % Pops: more frequent, shorter and lower amplitude
    pops = zeros(size(clean));
    pop_times = round(rand(1, 100) * (length(clean)-100));  % More pops
    for i = 1:length(pop_times)
        dur = randi([3, 10]);  % Shorter bursts
        pops(pop_times(i):(pop_times(i)+dur)) = 0.4 * randn(1, dur+1);  % same energy
    end





    noise = crackle + pops;
    noisy = clean + noise;
    trueNoiseIdx = abs(noise) > 0.003;

    yMed   = median_filter(noisy, trueNoiseIdx);
    yMean  = mean_filter(noisy, trueNoiseIdx);
    yLI    = linear_interp(noisy, trueNoiseIdx);
    yPCHIP = pchip_interp(noisy, trueNoiseIdx);

    snrOrig  = 10*log10(var(clean) / var(noisy - clean));
    snrMed   = 10*log10(var(clean) / var(yMed - clean));
    snrMean  = 10*log10(var(clean) / var(yMean - clean));
    snrLI    = 10*log10(var(clean) / var(yLI - clean));
    snrPCHIP = 10*log10(var(clean) / var(yPCHIP - clean));

    snrAll(run, :) = [snrOrig, snrMed, snrMean, snrLI, snrPCHIP];

    tpAll(run,:) = [NaN, sum(trueNoiseIdx), sum(trueNoiseIdx), sum(trueNoiseIdx), sum(trueNoiseIdx)];
    fpAll(run,:) = [NaN, 0, 0, 0, 0];
    fnAll(run,:) = [NaN, sum(~trueNoiseIdx & (yMed ~= clean)), ...
                         sum(~trueNoiseIdx & (yMean ~= clean)), ...
                         sum(~trueNoiseIdx & (yLI ~= clean)), ...
                         sum(~trueNoiseIdx & (yPCHIP ~= clean))];

    noiseStds(run) = std(noise);

    if run == numRuns
        figure(1); clf;
        plot(t(1:5000), noisy(1:5000)); hold on;
        plot(t(1:5000), clean(1:5000));
        title('Clean vs Noisy Signal Segment'); legend('Noisy','Clean');
        xlabel('Time (s)');

        if plotPlayback
            fprintf("Playing clean\n");    soundsc(clean, Fs); pause(2.2);
            fprintf("Playing noisy\n");    soundsc(noisy, Fs); pause(2.2);
            fprintf("Playing yMed\n");     soundsc(yMed, Fs);  pause(2.2);
            fprintf("Playing yMean\n");    soundsc(yMean, Fs); pause(2.2);
            fprintf("Playing yLI\n");      soundsc(yLI, Fs);   pause(2.2);
            fprintf("Playing yPCHIP\n");   soundsc(yPCHIP, Fs);pause(2.2);
        end
    end
end

% Display results
snrAvg = mean(snrAll);
snrStd = std(snrAll);

fprintf("\nAverage SNR over %d runs (± std dev):\n", numRuns);
fprintf("Original: %.2f (±%.2f)\n", snrAvg(1), snrStd(1));
fprintf("Median:   %.2f (±%.2f)\n", snrAvg(2), snrStd(2));
fprintf("Mean:     %.2f (±%.2f)\n", snrAvg(3), snrStd(3));
fprintf("Linear:   %.2f (±%.2f)\n", snrAvg(4), snrStd(4));
fprintf("PCHIP:    %.2f (±%.2f)\n", snrAvg(5), snrStd(5));

% Table output
methods = {'Original','Median','Mean','Linear','PCHIP'};
tableOut = table(methods', snrAvg', snrStd', ...
    mean(tpAll,1)', mean(fpAll,1)', mean(fnAll,1)', ...
    'VariableNames', {'Method','AvgSNR','SNR_StdDev','TruePos','FalsePos','FalseNeg'});
disp(tableOut);

% SNR Bar
figure(2); clf;
bar(snrAvg);
title('Average SNR Over 100 Runs'); ylabel('SNR (dB)');
set(gca, 'XTickLabel', methods); grid on;

%% --- UTILITY FUNCTIONS ---
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
