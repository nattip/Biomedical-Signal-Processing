%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: LE 3 Exercise 3
% Filename: Tipton_EGR635_LE3_ex3.m 
% Author: Natalie Tipton
% Class: EGR 635
% Date: 10/9/19
% Instructor: Dr. Rhodes
% Description: This script finds the PSD of resting and exercise ECG 
%   data using Blackman and Tukey, Modified Periodogram, and Welch's
%   periodogram methods. These PSDs are plotted against frequency.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rest = load('ECG_Flow_Subject2_Rest.txt')';             % load data
exercise = load('ECG_Flow_Subject2_Exercise.txt')';

minLength = min(length(rest), length(exercise));        % make data same size

rest = rest(:, 1:minLength);
exercise = exercise(:, 1:minLength);

ecg_rest = rest(3, :) - mean(rest(3, :));              % separate out ecg data
ecg_rest_pad = [ecg_rest, fliplr(ecg_rest)];
ecg_exercise = exercise(3, :) - mean(exercise(3, :));
ecg_exercise_pad = [ecg_exercise, fliplr(ecg_exercise)];

fs = 400;
N = length(ecg_rest);

%% Blackman and Tukey
freq = 0 : fs/N : (N-1) * (fs/N);       % create frequency vector
freq(end) = [];

% find autocorrelation of data
rxx_rest = xcorr(ecg_rest_pad, N/2-1);
rxx_exercise = xcorr(ecg_exercise_pad, N/2-1);

% create windows
rect_win = ones(1, N-1);
ham_win = hamming(N-1)';

% calculate PSD with both windows
Sxx_rest_rect_a = fft(rxx_rest .* rect_win);
Sxx_rest_ham_a = fft(rxx_rest .* ham_win);

Sxx_exercise_rect_a = fft(rxx_exercise .* rect_win);
Sxx_exercise_ham_a = fft(rxx_exercise .* ham_win);

figure(1)   % plot and label results
subplot(2,1,1); plot(freq, abs(Sxx_rest_rect_a))
title({'Sxx of resting data', 'Blackman and Tukey with rectangular window'});
xlabel('frequency (Hz)'); ylabel('Amplitude');
xlim([0 100])
subplot(2,1,2); plot(freq, abs(Sxx_rest_ham_a))
title({'Sxx of resting data', 'Blackman and Tukey with hamming window'});
xlabel('frequency (Hz)'); ylabel('Amplitude');
xlim([0 100])

figure(2)
subplot(2,1,1); plot(freq, abs(Sxx_exercise_rect_a))
title({'Sxx of exercise data', 'Blackman and Tukey with rectangular window'});
xlabel('frequency (Hz)'); ylabel('Amplitude');
xlim([0 100])
subplot(2,1,2); plot(freq, abs(Sxx_exercise_ham_a))
title({'Sxx of rexercise data', 'Blackman and Tukey with hamming window'});
xlabel('frequency (Hz)'); ylabel('Amplitude');
xlim([0 100])

%% Modified periodogram
freq = 0 : fs/N : (N-1) * (fs/N);   % create frequency vector

% create windows
rect_win = ones(1, N);
ham_win = hamming(N)';

% calculate PSD for both data sets with both windows
Sxx_rest_rect_b = (1/N).*((fft(rect_win.*ecg_rest).^2));
Sxx_rest_ham_b = (1/N).*((fft(ham_win.*ecg_rest).^2));
Sxx_exercise_rect_b =(1/N).*((fft(rect_win.*ecg_exercise).^2));
Sxx_exercise_ham_b = (1/N).*(fft(ham_win.*ecg_exercise).^2);

figure(3)   % plot and label
subplot(2,1,1); plot(freq, abs(Sxx_rest_rect_b));
title({'Sxx of resting data', 'Modified periodogram with rectangular window'});
xlabel('frequency (Hz)'); ylabel('Amplitude');
xlim([0 100])
subplot(2,1,2); plot(freq, abs(Sxx_rest_ham_b));
title({'Sxx of resting data', 'Modified periodogram with hamming window'});
xlabel('frequency (Hz)'); ylabel('Amplitude');
xlim([0 100])

figure(4)
subplot(2,1,1); plot(freq, abs(Sxx_exercise_rect_b))
title({'Sxx of exercise data', 'Modified periodogram with rectangular window'});
xlabel('frequency (Hz)'); ylabel('Amplitude');
xlim([0 100])
subplot(2,1,2); plot(freq, abs(Sxx_exercise_ham_b))
title({'Sxx of exercise data', 'Modified periodogram with hamming window'});
xlabel('frequency (Hz)'); ylabel('Amplitude');
xlim([0 100])

%% Welch Periodogram

rect_win = ones(1,256);     % create windows
ham_win = hamming(256)';

freq = 0 : fs/256: 255 * (fs / 256);       % create frequency vector

% revectorize data into overlapping vecotrs of size 256
y = buffer(1:numel(ecg_rest),256,128);
ecg_rest_reshape = ecg_rest(y(:,all(y)))';

y = buffer(1:numel(ecg_exercise),256,128);
ecg_exercise_reshape = ecg_exercise(y(:,all(y)))';

% calculate PSDs for each vector of both data sets
for i = 1:31
    Sxx_rest_rect_c(i,:) = (1/256).*((fft(rect_win.*ecg_rest_reshape(i,:)).^2));
    Sxx_rest_ham_c(i,:) = (1/256).*((fft(ham_win.*ecg_rest_reshape(i,:)).^2));
    Sxx_exercise_rect_c(i,:) = (1/256).*((fft(rect_win.*ecg_exercise_reshape(i,:)).^2));
    Sxx_exercise_ham_c(i,:) = (1/256).*((fft(ham_win.*ecg_exercise_reshape(i,:)).^2));
end

% complete ensemble averaging
Sxx_rest_rect_c = mean(Sxx_rest_rect_c(1:31,:));
Sxx_rest_ham_c = mean(Sxx_rest_ham_c(1:31,:));
Sxx_exercise_rect_c = mean(Sxx_exercise_rect_c(1:31,:));
Sxx_exercise_ham_c = mean(Sxx_exercise_ham_c(1:31,:));
       
figure(5)   % plot and label
subplot(2,1,1)
plot(freq, abs(Sxx_rest_rect_c))
title({'Sxx of rest data', 'Welchs periodogram with rectangular window'});
xlabel('frequency (Hz)'); ylabel('Amplitude');
xlim([0 100])
subplot(2,1,2)
plot(freq, abs(Sxx_rest_ham_c))
title({'Sxx of rest data', 'Welchs periodogram with hamming window'});
xlabel('frequency (Hz)'); ylabel('Amplitude');
xlim([0 100])

figure(6)
subplot(2,1,1)
plot(freq, abs(Sxx_exercise_rect_c))
title({'Sxx of exercise data', 'Welchs periodogram with rectangular window'});
xlabel('frequency (Hz)'); ylabel('Amplitude');
xlim([0 100])
subplot(2,1,2)
plot(freq, abs(Sxx_exercise_ham_c))
title({'Sxx of exercise data', 'Welchs periodogram with hamming window'});
xlabel('frequency (Hz)'); ylabel('Amplitude');
xlim([0 100])