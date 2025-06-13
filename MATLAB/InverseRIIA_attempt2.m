% Cameron Wade FYP
% Inverse RIAA

%% Setup

filename = "C:\Users\camer\OneDrive - Imperial College London\Year 4\FYP\rawaudio.wav";
info = audioinfo(filename);
[y,fS] = audioread(filename);
% player = audioplayer(Y,fS);


Fs = fS;

% Signals
sampleRange = (4*fS:7.5*fS);

yLeft = y(:,1);
yRight = y(:,2);
ySlice = y(sampleRange,:);
yLeftSlice = ySlice(:,1);
yRightSlice = ySlice(:,2);

% player = audioplayer(Y,fS);



%% RIAA Playback Filtering
    % 3rd order filter
    % Bass boost, treble cut

% Create the RIAA playback using a Biquad
    % IIR + Lower implementation cost
        % + Lower latency
        % + Analogue equivalent
        % - Non linear phase near cutoff

T = 1/Fs;

w1 = 2*pi/75e-6;
w2 = 2*pi/318e-6;
w3 = 2*pi/3180e-6;

num = [1, -w2, 0];
den = conv([1, -w1], [1, -w3]);

[bz, az] = bilinear(num, den, Fs);
fvtool(bz, az);




%% Plot
figure;
semilogx(w, 20*log10(abs(H)));
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Proper Inverse RIAA Playback Filter Response');
xlim([20 20000]);
grid on;

%% Compare
fprintf("play original signal");
playAudio(y(1*fS:5*fS),fS)


fprintf("play cleaned signal");
playAudio(filteredSig(1*fS:5*fS),fS);




%% FUNCTIONS

%% PlotSpectrogram
function plotSpectrogram(x, fs,Title)
        %figure
        %subplot(2,1,1); 
        % ax = gca; %for current axis in figure
        %plotSpectrogram(x, fs, 'Spectrogram');
    x = mean(x, 2); % mono
    window = hamming(1024);
    noverlap = 512;
    nfft = 2048;
    spectrogram(x, window, noverlap, nfft, fs, 'yaxis');
    title(Title);
    ylim([0 fs/2000]); % kHz scale
    colorbar;
end

%% Play audio
function playAudio(x,fs)
    recObj = audioplayer(x,fs); 
    play(recObj);
    pause(length(x) / fs);
end

%% RIAA Playback Function

function filteredSig = RIAAPlayback(x,fs)
            %filteredSig = RIAAPlayback(x,fs);

    T1 = 3180e-6; % 50 Hz   % bassF    = 1 / (2 * pi * T1); % f1 ~50 Hz
    T2 = 318e-6;  % 500 Hz  % centerF  = 1 / (2 * pi * T2); % f2 ~500 Hz
    T3 = 75e-6;   % 2122 Hz % trebleF  = 1 / (2 * pi * T3); % f3 ~2122 Hz
    
        % s-domain coefficients for analog transfer function
    num_s = [T2 1];
    den_s = conv([T1 1], [T3 1]);  % (sT1+1)(sT3+1)
    
        % Bilinear transform to digital (Tustin method)
    [bd, ad] = bilinear(num_s, den_s, fs);
    
    
        % Normalize gain at RIAA Reference point - 1kHz
    [~, idx] = min(abs(linspace(0, fs/2, 4096) - 1000));
    [H, ~] = freqz(bd, ad, 4096, fs);
    gainAt1kHz = abs(H(idx));
    bd = bd / gainAt1kHz; % scale numerator
    
        % Frequency response
    [H, w] = freqz(bd, ad, 4096, fs);

%     figure;
%     semilogx(w, 20*log10(abs(H)));
%     xlabel('Frequency (Hz)');
%     ylabel('Magnitude (dB)');
%     title('Proper Inverse RIAA Playback Filter Response');
%     xlim([20 20000]);
%     grid on;
    
    filteredSig = filter(bd, ad, x); % mono or apply per channel
end