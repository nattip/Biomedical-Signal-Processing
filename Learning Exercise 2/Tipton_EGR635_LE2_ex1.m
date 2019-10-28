%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: LE 2 Ex 1
% Filename: Tipton_EGR635_LE2_Ex1.m
% Author: Natalie Tipton
% Class: EGR 635
% Date: 9/25/19
% Instructor: Dr. Rhodes
% Description: This script finds the autocorrelation of random, normal
%   noise and of a sinusoidal signal.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% Exercise 1 %%%%%%%%%%%%%%%%%%%

N = 10000;              % size of signal
X = randn(1,N);         % create random gaussian signal
lags = 3000;            % number of lags
t_lags = 1:3000;

X_add = [X, fliplr(X)];
rxx = zeros(1, lags);    % allocate size of rxx

for m = 1:lags                              % loop through all lags
    for n = 1:N-1
        rxx(m) = rxx(m) + X_add(n) * X_add(n+(m-1));         % calculate auto correlation
    end
    rxx(m) = rxx(m) / (N - (m-1));
end

rxx = rxx / max(rxx);

figure(1)
plot(t_lags,rxx)                                           % plot autocorrelation
title('Autocorrelation of random, normal noise')    % label plot
xlabel('Lag Time (s)')                                  % label x axis
ylabel('Amplitude of Rxx')                          % label y axis

fs = 100;                   % sampling frequency of sinusoid
t = 0:1/fs:100;             % time vector for signal
Xsin = 2*sin(20*2*pi*t);    % create sinusoid signal w A=2, f=20
N = length(Xsin);

Xsin_add = [Xsin, fliplr(Xsin)];        % mirror data to add points at end

lag_time = 0:100/3000:100;              % create time vector
lag_time(end) = [];                     % delete extra time data point

rxx_sin = zeros(1, lags);               % allocate size for autocorrelation
    
for m = 1:lags                                      % loop through all lags
    for n = 1:N-1
        rxx_sin(m) = rxx_sin(m) + Xsin_add(n) * Xsin_add(n+(m-1));       % calculate rxx
    end
    rxx_sin(m) = rxx_sin(m) / (N - (m-1));
end

rxx_sin = rxx_sin / max(rxx_sin);       % normalize data

figure(2)
plot(lag_time, rxx_sin)                           % plot rxx
title('Autocorrelation of sinusoid')    % title plot  
xlabel('Lag Time (s)')                      % label x axis
ylabel('Amplitude of Rxx')              % label y axis