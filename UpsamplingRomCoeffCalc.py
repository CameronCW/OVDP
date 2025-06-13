import numpy as np
import matplotlib.pyplot as plt

# Filter design parameters
num_phases = 16
num_taps = 8
upsample_ratio = 1.609
cutoff_ratio = 1 / upsample_ratio  # relative to upsampled Nyquist
window = np.hamming(num_taps)

# Design sinc filter
def sinc_lpf(tap, phase_offset, num_phases, cutoff):
    n = np.arange(num_taps) - (num_taps // 2) + phase_offset / num_phases
    sinc = np.sinc(n * cutoff)
    return sinc * window

# Generate polyphase filter bank
filter_bank = np.zeros((num_phases, num_taps))
for phase in range(num_phases):
    coeffs = sinc_lpf(num_taps, phase, num_phases, cutoff_ratio)
    coeffs /= np.sum(coeffs)  # normalize gain
    filter_bank[phase, :] = coeffs

# Scale to Q1.15 fixed-point format
fixed_point_coeffs = np.round(filter_bank * (2**15)).astype(int)

# Display one example filter
plt.figure(figsize=(10, 4))
for i in range(num_phases):
    plt.plot(fixed_point_coeffs[i], label=f'Phase {i}')
plt.title("Fixed-point Polyphase Coefficients (Q1.15)")
plt.xlabel("Tap")
plt.ylabel("Amplitude")
plt.grid(True)
plt.tight_layout()
plt.show()

fixed_point_coeffs
