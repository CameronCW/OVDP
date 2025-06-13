% Cameron Wade FYP
% Audio processing tests
filename = "C:\Users\camer\OneDrive - Imperial College London\Year 4\FYP\rawaudio.wav";
info = audioinfo(filename);
[y,Fs] = audioread(filename);
% player = audioplayer(Y,Fs);

yLeft = y(:,1);
yRight = y(:,2);


%% CALC FFT 
    %setup
% nfft = (2048:2048:4096);   % Adjust for frequency resolution
% window = (1:2) .* nfft; % Trade-off between time and frequency resolution
% overlap = (0.5:0.1:0.8) .* ' window
% multiplier = 1;

nfft = 2048:2048:4096;   % Adjust for frequency resolution
window = (1:2)' .* nfft; % Ensure correct dimensions for combinations
overlap = (0.5:0.1:0.8)' .* window; % Element-wise multiplication
multiplier = 1;

% Generate all combinations
[nfft_grid, window_grid, overlap_grid] = ndgrid(nfft, window, overlap);
combinations = [nfft_grid(:), window_grid(:), overlap_grid(:)];


%% PLOT
rows = ceil(sqrt(num_plots));  
cols = ceil(num_plots / rows);  

figure;
for i = 1:num_plots
    subplot(rows, cols, i);
    spectrogram(x, combinations(i,2), combinations(i,3), combinations(i,1), fs, 'yaxis');
    title(sprintf('NFFT: %d, Win: %d, Ov: %d', combinations(i,1), combinations(i,2), combinations(i,3)));
end

sgtitle('Spectrogram Variations'); % Super title for the figure



%% Filtering attempt
centerFreq = 880;  % Center frequency of notch (880 Hz)
bandwidth = 70;    % Bandwidth (70 Hz)
    % Create the notch filter
d = designfilt('bandstopiir', 'FilterOrder', 2, ...
               'HalfPowerFrequency1', centerFreq - bandwidth / 2, ...
               'HalfPowerFrequency2', centerFreq + bandwidth / 2, ...
               'DesignMethod', 'butter', 'SampleRate', Fs);

    % Apply the filter
y_filtered = filter(d, y);

fvtool(d); % Plot the frequency response of filter

%%
%plot single FFT of signal, white noise, signal filtered and white noise
%filtered

% fplot() %what was I going to plot?

% Compute magnitude and normalize it
magnitude = abs(y) / nSamples;
f = zeros(1, floor(nSamples/2));
magnitude = magnitude(1:floor(nSamples/2));  % Positive frequencies only
f = f(1:floor(nSamples/2));  % Positive frequencies only

% Plot the magnitude of the FFT
% figure;
plot(f, magnitude);
title('Magnitude Spectrum of White Noise');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
% ylim([0 20000]);
