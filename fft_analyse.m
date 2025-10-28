% --- Input Data ---
Fs = 500;  % sampling frequency in Hz

% --- Time and FFT Setup ---
N = length(f0);            % number of samples
dt = 1/Fs;                 % sampling period
t = (0:N-1) * dt;          % time vector

% --- Compute FFT ---
F = fft(f0);               % perform FFT
P2 = abs(F / N);           % two-sided spectrum
P1 = P2(1:N/2+1);          % single-sided spectrum
P1(2:end-1) = 2 * P1(2:end-1); % correct amplitude

% --- Frequency Vector ---
f = Fs * (0:(N/2)) / N;    % frequency axis in Hz

% --- Plot ---
figure;
plot(f, P1, 'LineWidth', 1.5);
title('Single-Sided Amplitude Spectrum of Force Input');
xlabel('Frequency (Hz)');
ylabel('|F(f)|');
grid on;
