%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: LE 2 Ex 2
% Filename: Tipton_EGR635_LE2_ex2.m 
% Author: Natalie Tipton
% Class: EGR 635
% Date: 9/25/19
% Instructor: Dr. Rhodes
% Description: This script finds the cross correlation between EEG data
%   and a sinusoidal signal.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% Exercise 2 %%%%%%%%%%%%%%%%%%%

load('eeg_data.mat');                   % load in EEG data
fs = 100;                               % sampling frequency
N = length(eeg);
time = 0:1/fs:length(eeg)/fs;           % create time vector
time(end) = [];                         % eliminate extra data point

figure(1)
plot(time, eeg)                         % plot EEG data in new figure
title('EEG data')
xlabel('Time (s)')
ylabel('Amplitude (mV)')

sines = zeros(50, N);                   % allocate space for 50 sine waves

for hz = 1:50
    sines(hz,:) = sin(2*pi*time*hz);    % create sin waves with f=1-50 Hz
end

sines_add = [sines, fliplr(sines)];     % mirror data to add points at end
eeg = [eeg, fliplr(eeg)];

lags = 400;                             % number of lags
N = 801;                                % size of data

rxy = zeros(50,lags);                   % allocate space for cross correlation

for z = 1:50
    for m = 1:lags                              % loop through all lags
        for n = 1:N-1
            rxy(z,m) = rxy(z,m) + eeg(n) * sines_add(z, n+(m-1));    % calculate cross correlation
        end
        rxy(z,m) = rxy(z,m) / (N - (m-1));
    end
    rxy_max(z) = max(rxy(z, :));                        % find max values of Rxy
end

f = 1:50;                                   % create frequency vector
figure(2)                                   % new figure
plot(f, rxy_max)                            % plot maxes of Rxy against frequency
title('Maximum of Cross Correlation at Each Frequency') % label plot
xlabel('Frequency (Hz)')
ylabel('Amplitude')

freq = 0:(fs/1024):(1024-1)*(fs/1024);      % frequency vector for fft
eeg_fft = fft(eeg, 1024);                   % calculate fft with 1024 points

figure(3)
plot(freq, abs(eeg_fft))                         % plot fft against frequency
xlim([0 50])
title('FFT of EEG data')
xlabel('Frequency (Hz)')
ylabel('Amplitude')

    
