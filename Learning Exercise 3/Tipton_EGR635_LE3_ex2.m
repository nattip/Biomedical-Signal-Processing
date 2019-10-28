%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: LE 3 Exercise 2
% Filename: Tipton_EGR635_LE3_ex2.m 
% Author: Natalie Tipton
% Class: EGR 635
% Date: 10/9/19
% Instructor: Dr. Rhodes
% Description: This script looks at the cross correlation between resting
%   blood flow and ecg data and the same data after exercise.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rest = load('ECG_Flow_Subject2_Rest.txt')';             % load data
exercise = load('ECG_Flow_Subject2_Exercise.txt')';

minLength = min(length(rest), length(exercise));        % make data same size

rest = rest(:, 1:minLength);
exercise = exercise(:, 1:minLength);


flow_rest = rest(2, :);             % separate out blood flow data
ecg_rest = rest(3, :);              % separate out ecg data

flow_exercise = exercise(2, :);
ecg_exercise = exercise(3, :);

fs = 400;                   % samplig frequency used = 400
N = length(flow_rest);      % Find length of data

t_corr = -N/fs:1/fs:N/fs;   % time vector for correlation results
t_data = 0:1/fs: N/fs;      % time vector for raw data
t_data(end) = [];           % remove extra data point at end so lengths are =

% eliminate edge effects with symmetric extension
flow_rest_pad = [flow_rest, fliplr(flow_rest)]; 
ecg_rest_pad = [ecg_rest, fliplr(ecg_rest)];
flow_exercise_pad = [flow_exercise, fliplr(flow_exercise)];
ecg_exercise_pad = [ecg_exercise, fliplr(ecg_exercise)];

% find cross correlations using m = N
Rxy_rest = xcorr(flow_rest_pad, ecg_rest_pad, N);
Rxy_exercise = xcorr(flow_exercise_pad, ecg_exercise_pad, N);

figure(1)
subplot(2,2,[1,2]); plot(t_corr,Rxy_rest)   % plot and label xcorr of resting data
title('Cross Correlation of resting blood flow and ECG');
xlabel('time (s)'); ylabel('Amplitude');
xlim([0 10])
subplot(2,2,3); plot(t_data, flow_rest);    % plot and label raw resting flow data
title('Raw rest blood flow data');
xlabel('time (s)'); ylabel('Amplitude (mV)');
xlim([0 10])
subplot(2,2,4); plot(t_data, ecg_rest);     % plot and label raw resting ecg data
title('Raw rest ECG data');
xlabel('time (s)'); ylabel('Amplitude (mV)');
xlim([0 10])

figure(2)
subplot(2,2, [1, 2]); plot(t_corr, Rxy_exercise);   % plot and label xcorr of exercise data
title('Cross Correlation of exercise blood flow and ECG');
xlabel('time (s)'); ylabel('Amplitude');
xlim([0 10])
subplot(2,2,3); plot(t_data, flow_exercise);        % plot and label raw exercise flow data
title('Raw exercise blood flow data');
xlabel('time (s)'); ylabel('Amplitude (mV)');
subplot(2,2,4); plot(t_data, ecg_exercise);         % plot and label raw exercise ecg data
title('Raw exercise ECG data');
xlabel('time (s)'); ylabel('Amplitude (mV)');
xlim([0 10])
