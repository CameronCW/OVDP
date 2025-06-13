% --- PARAMETERS ---
V_supply = 9;
f_pwm = 13e3;
T_pwm = 1/f_pwm;
R = 12;
L = 0.5e-3;
BL = 23.1;
K = 15000;
f_res = 56;
M = K / (2*pi*f_res)^2;

f_mod = 15.7;
sim_time = 0.1;

% --- OPTIMIZED SAMPLING RATE ---
Fs = 65e3;         % 5x PWM freq is more than enough, even 26kHz is fine
dt = 1/Fs;
t = 0:dt:sim_time;
N = length(t);

% --- PWM & BASEBAND ---
baseband = 0.5 + 0.3 * sin(2*pi*f_mod*t);
duty = baseband;
pwm_signal = double(mod(t, T_pwm) < (duty * T_pwm));
hbridge_output = V_supply * pwm_signal .* (-1).^floor(t/T_pwm);

% --- TRANSFER FUNCTION: V_in -> I_coil ---
num = [M, 0, K];
den = [L*M, R*M, L*K + (BL)^2, R*K];
sys = tf(num, den);

% --- SIMULATE SYSTEM RESPONSE ---
i_actual = lsim(sys, hbridge_output, t);

% --- IDEAL BASEBAND CURRENT (NO RESONANCE, NO PWM) ---
i_ideal = (V_supply * baseband) / R;

% --- FILTER BOTH SIGNALS (2nd-ORDER BUTTERWORTH, fc > resonance) ---
filter_order = 2;
fc = 100; % Hz
[b,a] = butter(filter_order, fc/(Fs/2));
i_actual_filt = filtfilt(b, a, i_actual);
i_ideal_filt = filtfilt(b, a, i_ideal);

% --- PLOT RESULTS (plot limited time window for clarity) ---
plot_window = t < 0.04;  % plot just the first 40 ms to keep plot fast

figure;
subplot(3,1,1);
plot(t(plot_window), i_actual_filt(plot_window), 'b', t(plot_window), i_ideal_filt(plot_window), 'r--');
title('Filtered Actual vs Ideal Baseband Current');
xlabel('Time (s)'); ylabel('Current (A)');
legend('Actual (Filtered)', 'Ideal (Filtered)');

subplot(3,1,2);
plot(t(plot_window), i_actual_filt(plot_window) - i_ideal_filt(plot_window));
title('Error Signal (Actual - Ideal)');
xlabel('Time (s)'); ylabel('Error (A)');

subplot(3,1,3);
plot(t(plot_window), 100*(i_actual_filt(plot_window) - i_ideal_filt(plot_window))./max(abs(i_ideal_filt(plot_window))));
title('Normalized Error (%)');
xlabel('Time (s)'); ylabel('Error (%)');

% --- OPTIONAL: SPECTRUM (Tiny FFT) ---
% figure;
% N_fft = min(2^nextpow2(sum(plot_window)), 2^15); % 32768-point FFT
% f = (0:N_fft-1)*(Fs/N_fft)/1e3;
% I_fft = abs(fft(i_actual_filt(plot_window), N_fft));
% plot(f, 20*log10(I_fft/max(I_fft)));
% xlim([0, 0.3]); % up to 300 Hz
% xlabel('Frequency (kHz)');
% ylabel('Magnitude (dB)');
% title('Filtered Current Spectrum');
