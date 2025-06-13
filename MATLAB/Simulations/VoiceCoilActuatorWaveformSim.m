% Parameters
V_supply = 9;          % Supply voltage (V)
f_pwm = 13e3;          % PWM frequency (Hz)
T_pwm = 1/f_pwm;       % PWM period (s)
R_coil = 12;           % Coil resistance (Ohms)
L_coil = 0.5e-3;       % Coil inductance (H)
duty_cycle = 0.5;      % PWM duty cycle (0 to 1)
sim_time = 2e-3;       % Simulation time (s)

% Time vector for simulation
dt = T_pwm/100;  
t = 0:dt:sim_time;
N = length(t);
Fs = 1/dt;

% PWM signal
pwm_signal = double(mod(t, T_pwm) < duty_cycle * T_pwm);

% H-bridge output: alternating polarity per cycle
hbridge_output = V_supply * pwm_signal .* (-1).^floor(t/T_pwm);

% Simulate coil current
i = zeros(1, N);
for k = 2:N
    di = (hbridge_output(k-1) - R_coil * i(k-1)) / L_coil * dt;
    i(k) = i(k-1) + di;
end

% % Low-pass filter (adjust alpha for cutoff ~ Fc = alpha * Fs / (2*pi))
% alpha = 0.02;  % Filter strength: lower = smoother
% i_lp = zeros(1, N);
% for k = 2:N
%     i_lp(k) = i_lp(k-1) + alpha * (i(k) - i_lp(k-1));
% end

% Low-pass filter
fc = f_pwm;  % cutoff frequency (Hz)
[b, a] = butter(4, fc / (Fs/2));
% Apply zero-phase filter to PWM signal
i_lp= filtfilt(b, a, i);

% Nonlinearity as difference between actual and smoothed current
nonlinearity = i - i_lp;

% Plot actual vs low-pass filtered current
figure;
subplot(3,1,1);
plot(t*1e3, i, 'b'); hold on;
plot(t*1e3, i_lp, 'r--');
title('Actual Coil Current vs Low-Pass Filtered Reference');
xlabel('Time (ms)'); ylabel('Current (A)');
legend('Actual','Low-Pass Reference');

subplot(3,1,2);
plot(t*1e3, nonlinearity);
title('Nonlinearity (Error Signal)');
xlabel('Time (ms)'); ylabel('Error (A)');

subplot(3,1,3);
plot(t*1e3, 100 * nonlinearity ./ max(abs(i_lp)));
title('Normalized Nonlinearity (%)');
xlabel('Time (ms)'); ylabel('Error (%)');

% Optional: show input PWM and voltage
figure;
subplot(3,1,1); plot(t*1e3, pwm_signal); ylabel('PWM Signal'); ylim([-0.1 1.1]);
subplot(3,1,2); plot(t*1e3, hbridge_output); ylabel('H-Bridge Voltage (V)');
subplot(3,1,3); plot(t*1e3, i); ylabel('Coil Current (A)'); xlabel('Time (ms)');
