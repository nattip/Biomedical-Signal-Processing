%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: LE 4 Exercise 3
% Filename: Tipton_EGR635_LE4_ex3.m 
% Author: Natalie Tipton
% Class: EGR 635
% Date: 10/23/19
% Instructor: Dr. Rhodes
% Description: This script finds the power spectrum of a signal using
%   Yule-Walker method and Eigen Decomposition Method. These are done
%   manually and then compared with the results from Matlab functions
%   pyulear and peig.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

fs = 1000;      % sampling frequency
N = 1024;       % number of data points
p = 17;

t = 0:1/fs:N/fs-1/fs;       % create time vector
f1 = 0 : (fs/2)/128: fs/2;       % create frequency vector
f2 = 0 : fs/N:(fs-fs/N)/2;

% create sine wave with four different frequencies
x = sin(2 * pi * t * 100) + sin(2 * pi * t * 240) +...
    sin(2 * pi * t * 280) + sin( 2 * pi * t * 400);

% add -12 dB white gaussian noise
x = awgn(x, -12);

variance = var(x);

autocorr = xcorr(x, p)';  % find autocorrelation of signal
R = toeplitz(autocorr(p+1:end-1));

R_inv = inv(R);             % take inverse of autocorrelation matrix
Ryy = autocorr(p+2:end);       % window autocorrelation of size of matrix

a = -R_inv * Ryy;            % find coefficients
a = [1;a];

yule_power = variance ./ fft(a,N);   % calculate power spectrum

% used to compare against manual versions
[x_pyulear, f_yule] = pyulear(x, p, 2^nextpow2(length(x)), fs);

% Decomposition
p = 8;
[X,R] = corrmtx(x,30);
[U, S, V] = svd(R, 0);  % singular value decomposition
lambda = diag(S);       % find lambda_k

for k = p:length(V)
    eigen_power(k,:) = abs(fft(V(:,k),N)).^2/lambda(k);    % calculate power
end

eig_pow = 1 ./ sum(eigen_power);

% used to compare against manual versions
[x_peig, f_peig] = peig(x, p, N, fs);

%plot
figure(1)
plot(lambda);
title('Scree Plot');
xlabel('Component Number'); ylabel('Eigen Value');

figure(2)
subplot (2,1,1)
plot(f2,abs(yule_power(1:length(f2))));
title('Power Spectrum determined manually with Yule-Walker, order = 17')
xlabel('frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(f_yule,x_pyulear);
title('Power Spectrum determined with pyulear, order = 17')
xlabel('frequency (Hz)'); ylabel('Amplitude');

figure(3)
subplot(2,1,1)
plot(f_peig,eig_pow(1:length(f_peig)))
title('Power Spectrum determined manually with Eigen Decomposition, order = 35')
xlabel('frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(f_peig,x_peig)
title('Power Spectrum determined with peig, p = 9')
xlabel('frequency (Hz)'); ylabel('Amplitude');






