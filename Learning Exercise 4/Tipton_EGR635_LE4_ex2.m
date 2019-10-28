%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: LE 4 Exercise 2
% Filename: Tipton_EGR635_LE4_ex2.m 
% Author: Natalie Tipton
% Class: EGR 635
% Date: 10/23/19
% Instructor: Dr. Rhodes
% Description: This script filters ECG data using low pass butterworth,
%   Chebyshev Type I, Chebyshev Type 2, and Elliptical filters. The 
%   filtered data as well as the power of that filtered data is plotted.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

% load data
rest = load('ECG_Flow_Subject2_Rest.txt')';             
exercise = load('ECG_Flow_Subject2_Exercise.txt')';

% separate out ecg data
rest = rest(3, :) - mean(rest(3, :));              
exercise = exercise(3, :) - mean(exercise(3, :));

% find length of data
n_rest = length(rest);
n_exercise = length(exercise);

% constants
fs = 400;
N = 2048;

% create fime and frequency vectors for raw data, power, and filters
t_rest = 0 : 1/fs: n_rest/fs - 1/fs;
t_exercise = 0 : 1/fs: n_exercise/fs - 1/fs;
f = 0 : fs/N : fs/2 - fs/N;
f2 = 0:fs/N:fs-fs/N;
t2 = 0 : 1/fs : N/fs - 1/fs;

% calculate power of raw data
rest_pow = abs(fft(rest, N) .^ 2);
exercise_pow = abs(fft(exercise, N) .^ 2);

% declare cutoff frequency in rad*pi/sample and order of filter
cutoff_1 = 0.075; order_1 = 8;
cutoff_2 = 0.075; order_2 = 8; rp_2 = 3;
cutoff_3 = 0.075; order_3 = 8; rs_3 = 60;
cutoff_4 = 0.075; order_4 = 8; rp_4 = 3; rs_4 = 60;

% create filter coefficients
[b1, a1] = butter(order_1, cutoff_1);
[b2, a2] = cheby1(order_2, rp_2, cutoff_2);
[b3, a3] = cheby2(order_3, rs_3, cutoff_3);
[b4, a4] = ellip(order_4, rp_4, rs_4, cutoff_4);

% find frequency response of the filters
filter1_f = freqz(b1, a1, N);
filter2_f = freqz(b2, a2, N);
filter3_f = freqz(b3, a3, N);
filter4_f = freqz(b4, a4, N);

% find time response of the filters
filter1 = ifft(filter1_f, N);
filter2 = ifft(filter2_f, N);
filter3 = ifft(filter3_f, N);
filter4 = ifft(filter4_f, N);

% plot frequency and time response of filters
figure
subplot(2,1,1)
plot(f2,abs(filter1_f))
title({'Frequency Response of Filter 1', 'Low Pass Butterworth, fc = 15 Hz, order = 8'});
xlabel('Frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(t2, filter1)
title({'Impulse Response of Filter 1', 'Low Pass Butterworth, fc = 15 Hz, order = 8'});
xlabel('Time (s)'); ylabel('Amplitude');

figure
subplot(2,1,1)
plot(f2,abs(filter2_f))
title({'Frequency Response of Filter 2', 'Low Pass Chebyshev Type I, fc = 15 Hz, order = 8, rp = 3'});
xlabel('Frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(t2, filter2)
title({'Impulse Response of Filter 2', 'Low Pass Chebyshev Type I, fc = 15 Hz, order = 8, rp = 3'});
xlabel('Time (s)'); ylabel('Amplitude');

figure
subplot(2,1,1)
plot(f2,abs(filter3_f))
title({'Frequency Response of Filter 3', 'Low Pass Chebyshev Type II, fc = 15 Hz, order = 8, rs = 60'});
xlabel('Frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(t2, filter3)
title({'Impulse Response of Filter 3', 'Low Pass Chebyshev Type II, fc = 15 Hz, order = 8, rs = 60'});
xlabel('Time (s)'); ylabel('Amplitude');

figure
subplot(2,1,1)
plot(f2,abs(filter4_f))
title({'Frequency Response of Filter 4', 'Low Pass Elliptical, fc = 15 Hz, order = 8, rp = 3, rs = 60'});
xlabel('Frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(t2, filter4)
title({'Impulse Response of Filter 4', 'Low Pass Elliptical, fc = 15 Hz, order = 8, rp = 3, rs = 60'});
xlabel('Time (s)'); ylabel('Amplitude');

% resting data filtering

% filter rest data
rest_filt1 = filtfilt(b1,a1, rest);
rest_filt2 = filtfilt(b2,a2, rest);
rest_filt3 = filtfilt(b3,a3, rest);
rest_filt4 = filtfilt(b4,a4, rest);

% find power spectrum of filtered data
rest_filt1_pow = periodogram(rest_filt1, window, N);
rest_filt2_pow = periodogram(rest_filt2, window, N);
rest_filt3_pow = periodogram(rest_filt3, window, N);
rest_filt4_pow = periodogram(rest_filt4, window, N);

% plot resting results (filtered data and power)
figure
subplot(2,1,1)
plot(t_rest, rest)
title('Raw ECG Resting Data');
xlabel('time(s)'); ylabel('Amplitude (mV)');
subplot(2,1,2)
plot(t_rest, rest_filt1)
title({'Filtered resting data', 'Low Pass Butterworth, fc = 15 Hz, order = 8'});
xlabel('time(s)'); ylabel('Amplitude (mV)');

figure
subplot(2,1,1)
plot(f, rest_pow(1:N/2))
title('Raw ECG Resting Power');
xlabel('frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(f, rest_filt1_pow(1:N/2))
title({'Filtered resting data power', 'Low Pass Butterworth, fc = 15 Hz, order = 8'});
xlabel('frequency (Hz)'); ylabel('Amplitude');

figure
subplot(2,1,1)
plot(t_rest, rest)
title('Raw ECG Resting Data');
xlabel('time(s)'); ylabel('Amplitude (mV)');
subplot(2,1,2)
plot(t_rest, rest_filt2)
title({'Filtered resting data', 'Low Pass Chebyshev Type I, fc = 15 Hz, order = 8, rp = 3'});
xlabel('time(s)'); ylabel('Amplitude (mV)');

figure
subplot(2,1,1)
plot(f, rest_pow(1:N/2))
title('Raw ECG Resting Power');
xlabel('frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(f, rest_filt2_pow(1:N/2))
title({'Filtered resting data power', 'Low Pass Chebyshev Type I, fc = 15 Hz, order = 8, rp = 3'});
xlabel('frequency (Hz)'); ylabel('Amplitude');

figure
subplot(2,1,1)
plot(t_rest, rest)
title('Raw ECG Resting Data');
xlabel('time(s)'); ylabel('Amplitude (mV)');
subplot(2,1,2)
plot(t_rest, rest_filt3)
title({'Filtered resting data', 'Low Pass Chebyshev Type II, fc = 15 Hz, order = 8, rs = 60'});
xlabel('time(s)'); ylabel('Amplitude (mV)');

figure
subplot(2,1,1)
plot(f, rest_pow(1:N/2))
title('Raw ECG Resting Power');
xlabel('frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(f, rest_filt3_pow(1:N/2))
title({'Filtered resting data power', 'Low Pass Chebyshev Type II, fc = 15 Hz, order = 8, rs = 60'});
xlabel('frequency (Hz)'); ylabel('Amplitude');

figure
subplot(2,1,1)
plot(t_rest, rest)
title('Raw ECG Resting Data');
xlabel('time(s)'); ylabel('Amplitude (mV)');
subplot(2,1,2)
plot(t_rest, rest_filt4)
title({'Filtered resting data', 'Low Pass Elliptical, fc = 15 Hz, order = 8, rp = 3, rs = 60'});
xlabel('time(s)'); ylabel('Amplitude (mV)');

figure
subplot(2,1,1)
plot(f, rest_pow(1:N/2))
title('Raw ECG Resting Power');
xlabel('frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(f, rest_filt4_pow(1:N/2))
title({'Filtered resting data power', 'Low Pass Elliptical, fc = 15 Hz, order = 8, rp = 3, rs = 60'});
xlabel('frequency (Hz)'); ylabel('Amplitude');


% exercise data filtering

% filter exercise data
exercise_filt1 = filtfilt(b1,a1, exercise);
exercise_filt2 = filtfilt(b2,a2, exercise);
exercise_filt3 = filtfilt(b3,a3, exercise);
exercise_filt4 = filtfilt(b4,a4, exercise);

% find power spectrum of filtered data
exercise_filt1_pow = periodogram(exercise_filt1, window, N);
exercise_filt2_pow = periodogram(exercise_filt2, window, N);
exercise_filt3_pow = periodogram(exercise_filt3, window, N);
exercise_filt4_pow = periodogram(exercise_filt4, window, N);

% plot exercising results (filtered data and power)
figure
subplot(2,1,1)
plot(t_exercise, exercise)
title('Raw ECG exercising Data');
xlabel('time(s)'); ylabel('Amplitude (mV)');
subplot(2,1,2)
plot(t_exercise, exercise_filt1)
title({'Filtered exercise data', 'Low Pass Butterworth, fc = 15 Hz, order = 8'});
xlabel('time(s)'); ylabel('Amplitude (mV)');

figure
subplot(2,1,1)
plot(f, exercise_pow(1:N/2))
title('Raw ECG exercising Power');
xlabel('frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(f, exercise_filt1_pow(1:N/2))
title({'Filtered exercise data power', 'Low Pass Butterworth, fc = 15 Hz, order = 8'});
xlabel('frequency (Hz)'); ylabel('Amplitude');

figure
subplot(2,1,1)
plot(t_exercise, exercise)
title('Raw ECG exercising Data');
xlabel('time(s)'); ylabel('Amplitude (mV)');
subplot(2,1,2)
plot(t_exercise, exercise_filt2)
title({'Filtered exercise data', 'Low Pass Chebyshev Type I, fc = 15 Hz, order = 8, rp = 3'});
xlabel('time(s)'); ylabel('Amplitude (mV)');

figure
subplot(2,1,1)
plot(f, exercise_pow(1:N/2))
title('Raw ECG exercising Power');
xlabel('frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(f, exercise_filt2_pow(1:N/2))
title({'Filtered exercise data power', 'Low Pass Chebyshev Type I, fc = 15 Hz, order = 8, rp = 3'});
xlabel('frequency (Hz)'); ylabel('Amplitude');

figure
subplot(2,1,1)
plot(t_exercise, exercise)
title('Raw ECG exercising Data');
xlabel('time(s)'); ylabel('Amplitude (mV)');
subplot(2,1,2)
plot(t_exercise, exercise_filt3)
title({'Filtered exercise data', 'Low Pass Chebyshev Type II, fc = 15 Hz, order = 8, rs = 60'});
xlabel('time(s)'); ylabel('Amplitude (mV)');

figure
subplot(2,1,1)
plot(f, exercise_pow(1:N/2))
title('Raw ECG exercising Power');
xlabel('frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(f, exercise_filt3_pow(1:N/2))
title({'Filtered exercise data power', 'Low Pass Chebyshev Type II, fc = 15 Hz, order = 8, rs = 60'});
xlabel('frequency (Hz)'); ylabel('Amplitude');

figure
subplot(2,1,1)
plot(t_exercise, exercise)
title('Raw ECG exercising Data');
xlabel('time(s)'); ylabel('Amplitude (mV)');
subplot(2,1,2)
plot(t_exercise, exercise_filt4)
title({'Filtered exercise data', 'Low Pass Elliptical, fc = 15 Hz, order = 8, rp = 3, rs = 60'});
xlabel('time(s)'); ylabel('Amplitude (mV)');

figure
subplot(2,1,1)
plot(f, exercise_pow(1:N/2))
title('Raw ECG exercising Power');
xlabel('frequency (Hz)'); ylabel('Amplitude');
subplot(2,1,2)
plot(f, exercise_filt4_pow(1:N/2))
title({'Filtered exercise data power', 'Low Pass Elliptical, fc = 15 Hz, order = 8, rp = 3, rs = 60'});
xlabel('frequency (Hz)'); ylabel('Amplitude');





