%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: LE 4 Exercise 4
% Filename: Tipton_EGR635_LE4_ex4.m 
% Author: Natalie Tipton
% Class: EGR 635
% Date: 10/23/19
% Instructor: Dr. Rhodes
% Description: This script plots the power spectrum of a test sinusoid
%   containing f = 100, 240, 280, and 400 plus white gaussian noise
%   at -12 dB. Power spectrums were found using Welch's Periodogram,
%   Yule-Walker, and Eigen Decomposition.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs = 1000;  % sampling frequency
N = 1024;   % number of points
n = 129;     % number of points in AR groups
p = 5;      % p as determined by trial and error

t = 0:1/fs:N/fs-1/fs;   % create time vector
f = 0 : (fs/2)/128: fs/2;       % create frequency vector

% create test signal
x = sin(2 * pi * t * 100) + sin(2 * pi * t * 240) +...
    sin(2 * pi * t * 280) + sin( 2 * pi * t * 400);

noise = randn(1, 1024);     % create noise to add to test signal

% low pass filter the noise with butterworth, fc = 5 Hz, order = 8
b = butter(8, 0.025, 'low');
noise = filter(b,1,noise);

% compile test signal and noise
x = x + noise;

% find power spectrum using welch's periodogram
X_pwelch = pwelch(x);

% find power spectrum using Yule-Walker method as different orders
X_pyulear_17 = pyulear(x, 17);
X_pyulear_25 = pyulear(x, 25);
X_pyulear_35 = pyulear(x, 35);

% find power spectrum using Eigen Decomposition
X_peig = peig(x, 5);

[X, R] = corrmtx(x, 30);  % correlation matrix with 30 lags
[U, S, V] = svd(R, 0);  % singular value decomposition
lambda = diag(S);       % find lambda_k

% plot power spectra
figure(1)
plot(f,X_pwelch)
title('Power Spectrum using Welchs Periodogram');
xlabel('frequency (Hz)'); ylabel('Amplitude');

figure(2)
subplot(3,1,1)
plot(f,X_pyulear_17)
title('Power Spectrum using Yule-Walker, order = 17');
xlabel('frequency (Hz)'); ylabel('Amplitude');
subplot(3,1,2)
plot(f,X_pyulear_25)
title('Power Spectrum using Yule-Walker, order = 25');
xlabel('frequency (Hz)'); ylabel('Amplitude');
subplot(3,1,3)
plot(f,X_pyulear_35)
title('Power Spectrum using Yule-Walker, order = 35');
xlabel('frequency (Hz)'); ylabel('Amplitude');

figure(4)
plot(lambda)
title('Scree Plot')
xlabel('Component Number'); ylabel('Eigen Value');

figure(5)
plot(f,X_peig)
title('Power Spectrum using Eigen Decomposition, order = 35');
xlabel('frequency (Hz)'); ylabel('Amplitude');


