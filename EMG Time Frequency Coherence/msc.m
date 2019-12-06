function msc(x, y, fs, win_len, idx, label)

% This function creates a plot of the MSC in terms of time and frequency
% between two equal length signals.
%
% Inputs:
%           x = The first signal
%           y = The second signal
%           fs = Sampling frequency of both x and y
%           win_len = Window length to be used
%           idx = Which subject data is being analyzed for labelling
%           label = Tells what type of muscle pair to label images
%
% Outputs:
%           Image of the MSC between x and y
%           Plot of the median MSC for gamma, beta, and tremor bands

n = length(x);              % find length of input data
f_res = fs / win_len;       % calculate frequency resolution

overlap = win_len / 2;      % overlap in segments it half the window size
n_segs = 2 * ceil(n / win_len) - 1;     % calculate how many segments will result
[E, V] = dpss(win_len, 3.5);            % create 7 windows to apply to each seg

% Preallocating Variables
Sxx = zeros(1, win_len);
Syy = zeros(1, win_len);
Sxy = zeros(1, win_len);
start = 1;
 
for i = 1:n_segs
    if ((start+win_len)-1 > n)   % if not enough data to make full segment
        stop = n;   % stop segment at end of available data
    else
        stop = (start+win_len)-1; % else, stop segment at desired length
    end 
    
    x_data = x(start : stop)-mean(x(start : stop));     % segment and zero mean the x data
    y_data = y(start : stop)-mean(y(start : stop));     % segment and zero mean the y data
    
    for m = 1:size(V, 1)    % repeat for each window
        w = E(:, m)';    % set window to the the ith window
        
        if (length(w) > length(x_data))          %if last segment of data is not 600 points long
            % zero pad last segment of data to make it as long as window
            pad = zeros(1,length(w)-length(x_data));
            x_data = [x_data, pad];     
            y_data = [y_data, pad];     
        end
        x_windowed = w.*x_data;     % window x data with current window
        y_windowed = w.*y_data;     % window y data with current window
        
        % get frequency domain of windowed x and y
        X = fft(x_windowed,win_len);
        Y = fft(y_windowed,win_len);
        
        % Calculate auto and cross correlations of X and Y
        Sxx = Sxx + X.*conj(X);
        Syy = Syy + Y.*conj(Y);
        Sxy = Sxy + X.*conj(Y);
    end
    msc(:,i) = (abs(Sxy).^2)./(Sxx.*Syy);   % calculate msc for segment
    msc(:,i) = msc(:,i)./max(msc(:,i));     % normalize msc
    
    % reset auto and cross corrs to 0 for next segment calculations
    Sxx = zeros(1,win_len);
    Syy = zeros(1,win_len);
    Sxy = zeros(1,win_len);
    
    start = start+overlap;      % increament segment start
end

% find median MSC for gamma, beta, and tremor frequency bands ovr time
gamma_avg(:) = mean(msc(ceil(30/f_res-5) : ceil(60/f_res-5), :));
beta_avg(:) = mean(msc(ceil(15/f_res-5) : ceil(30/f_res-5), :));
tremor_avg(:) = mean(msc(ceil(8/f_res-3) : ceil(12/f_res-3), :));

% plot MSC by time and frequency
figure
imagesc([0 n], [10 500], msc(1:length(msc)/2,:))
colorbar
title({['MSC by time and frequency for subject ', num2str(idx)], label});
xlabel('Sample Number'); ylabel('Frequency (Hz)'); 
colorbar;

t = 1:size(msc,2);  % create time vector
var_msc = var(msc);

% plot median MSC for each frequency band over time
figure
subplot(3,1,1)
plot(t,gamma_avg);
% create and add a trendline to data
msc_coef = polyfit(t, gamma_avg, 1);
msc_x = linspace(min(t), max(t), 1000);
msc_y = polyval(msc_coef , msc_x);
hold on;
plot(msc_x, msc_y, 'r-', 'LineWidth', 2);
hold off
title({['MSC in gamma band over time for subject ', num2str(idx)], label});
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,2)
plot(t, beta_avg);
msc_coef = polyfit(t, beta_avg, 1);
msc_x = linspace(min(t), max(t), 1000);
msc_y = polyval(msc_coef , msc_x);
hold on;
plot(msc_x, msc_y, 'r-', 'LineWidth', 2);
hold off
title({['MSC in beta band over time for subject ', num2str(idx)], label});
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,3)
plot(t, tremor_avg)
msc_coef = polyfit(t, tremor_avg, 1);
msc_x = linspace(min(t), max(t), 1000);
msc_y = polyval(msc_coef , msc_x);
hold on;
plot(msc_x, msc_y, 'r-', 'LineWidth', 2);
hold off
title({['MSC in tremor band over time for subject ', num2str(idx)], label})
xlabel('Time (s)'); ylabel('Amplitude');
 

