% Parameters
V_supply = 9;           % Supply voltage (V)
f_pwm = 13e3;           % PWM frequency (Hz)
T_pwm = 1/f_pwm;
R_coil = 12;            % Coil resistance (Ohms)
L_coil = 0.5e-3;        % Coil inductance (H)
f_mod = 15.7;           % Baseband modulation frequency (Hz)
sim_time = 0.1;         % Longer time to capture modulation

% Time vector
dt = T_pwm/100;
t = 0:dt:sim_time;
N = length(t);
Fs = 1/dt;

% Modulated duty cycle: sine wave from 0.2 to 0.8
baseband = 0.5 + 0.3 * sin(2*pi*f_mod*t);  % target signal
duty_cycle_t = baseband;

% PWM signal
pwm_signal = double(mod(t, T_pwm) < (duty_cycle_t .* T_pwm));

% H-bridge output (bipolar PWM)
hbridge_output = V_supply * pwm_signal .* (-1).^floor(t/T_pwm);

% Coil current simulation
i = zeros(1, N);
for k = 2:N
    di = (hbridge_output(k-1) - R_coil * i(k-1)) / L_coil * dt;
    i(k) = i(k-1) + di;
end

% % Low-pass filter to extract baseband current
% alpha = 0.02;
% i_lp = zeros(1, N);
% for k = 2:N
%     i_lp(k) = i_lp(k-1) + alpha * (i(k) - i_lp(k-1));
% end


% Ideal no-inductance baseband current
i_target = (V_supply * duty_cycle_t) / R_coil;


% Low-pass filter both actual and ideal signals (alpha IIR, optional)
alpha = 0.02;
i_lp = zeros(1, N);
i_target_lp = zeros(1, N);
for k = 2:N
    i_lp(k) = i_lp(k-1) + alpha * (i(k) - i_lp(k-1));
    i_target_lp(k) = i_target_lp(k-1) + alpha * (i_target(k) - i_target_lp(k-1));
end


% %alternate filter implementation (butterworth IIR)
% filter_order = 4;
% fc = 52; % 56 hz resonant?
% [b, a] = butter(filter_order, fc / (Fs/2));  % normalized cutoff
% 
% % Apply IIR filter (zero-phase)
% i_lp = filtfilt(b, a, i);  % actual filtered current
% i_target_lp = filtfilt(b, a, i_target);  % ideal filtered current


% RMS analysis
rms_target = rms(i_target);
rms_actual = rms(i_lp);
distortion_pct = 100 * abs(rms_actual - rms_target) / rms_target;


i_lowpass = lowpass(i,50,Fs);

% Plotting
figure(2);
subplot(3,1,1);
% plot(t, i_lp, 'b'); hold on; 
plot(t, i_lowpass, 'b'); hold on;
plot(t, i_target_lp, 'r--');
title('Recovered Baseband Current vs Ideal (Both Filtered)');
xlabel('Time (s)'); ylabel('Current (A)');
legend('Actual (Filtered)', 'Ideal (Filtered)');

subplot(3,1,2);
plot(t, i_lp - i_target_lp);
title('Error Signal (Nonlinearity)');
xlabel('Time (s)'); ylabel('Error (A)');

subplot(3,1,3);
plot(t, 100*(i_lp - i_target_lp)./max(abs(i_target_lp)));
title('Normalized Error (%)');
xlabel('Time (s)'); ylabel('Error (%)');


figure
plotSpectrogram(i_lp',Fs,"actual current spectrogram");

figure 
subplot(2,1,1); 
plotFourier(i,Fs,"FFT of i")
subplot(2,1,2); 
plotFourier(i_lp,Fs,"FFT of i_{LP}")


% %Test
% figure
% Fs = 1.3e6;         % Sampling frequency (Hz)
% f_test = 1e3;       % Test frequency (Hz)
% t = 0:1/Fs:0.01;    % 10 ms of data
% x_1khz = sin(2*pi*f_test*t);
% plotSpectrogram(x_1khz',Fs,"Test 1khz freq spectrogram");
% plotFourier(x_1khz',Fs,"Test 1khz fourier transform");
% 

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
%     ylim([0 20]); % kHz scale
    colorbar;
end


function plotFourier(x, fs, Title)
        %figure 
        %subplot(2,1,1); 
        %Title = "FFT of ...";
        %plotFourier(x_1khz,Fs,Title)
    N = length(x);
    X = fft(x);
    f = (0:N-1)*(fs/N);  % Frequency vector

    % Compute magnitude in dB (power spectrum)
    X_mag_dB = 20*log10(abs(X(1:N/2)));

    % Plot
    plot(f(1:N/2)/1e3, X_mag_dB);
    xlabel('Frequency (kHz)');
    ylabel('Magnitude (dB)');
    title(Title);
    %xlim([(-fs/2000)*0.05 fs/2000]); % 5% of reverse
    xlim([-0.1 40]);  % in kHz
    ylim([min(X_mag_dB(1,:)) max(X_mag_dB)])
    grid on;
end
