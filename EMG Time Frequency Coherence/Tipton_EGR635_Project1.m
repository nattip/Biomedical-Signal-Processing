%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Project 1
% Filename: Tipton_EGR635_Project1.m 
% Author: Natalie Tipton
% Class: EGR 635
% Date: 11/13/19
% Instructor: Dr. Rhodes
% Description: This algorithm looks at EMG data of the biceps, triceps, and
%   brachioradialis. Time domain statistics are taken, median frequency
%   analysis is performed on the power spectrum, and MSC over time is taken
%   for the antagonistic and synergistic muscle pairs.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all;

files = dir('CS0*.csv');   %open all .csv files in current folder w/ CS0 in name
[num_files,z] = size(files);    %determine number of files read

for x = 1:num_files         % run code for each data file
    if x > 1                % after first file, delete all variable values except cumulative ones
        clearvars -except coefs_tri coefs_bi coefs_brach x num_files files bi_p tri_p brach_p data bi_h tri_h brach_h;
    end
    
    %read in all images in directory
    data{x} = csvread(files(x).name);

    %use nth file in directory for current analysis
    data_time = data{1,x};

    fs = 1200;  % sampling frequency
    
    % read in data and determine length
    data_time = data_time(1:fs*90,:);  
    n = length(data_time);
    
    N = 2048;   % data points for fft
    
    t = 0:1/fs:n/fs-1/fs;   % time vector for raw data
    t_sec = 0:n/fs-1;       % time vector for each second
    f = 0:fs/N:fs-fs/N;     % frequency vector for power
    
    % separate bicep from raw data and find stats on it
    bi_time = data_time(:,6);
    min_bi = min(bi_time);
    max_bi = max(bi_time);
    mean_bi = mean(bi_time);
    var_bi = var(bi_time);
    
    % separate tricep from raw data and find stats on it
    tri_time = data_time(:,7);
    min_tri = min(tri_time);
    max_tri = max(tri_time);
    mean_tri = mean(tri_time);
    var_tri = var(tri_time);
    
    % separate brachioradialis from raw data and find stats on it
    brach_time = data_time(:,8);
    min_brach = min(brach_time);
    max_brach = max(brach_time);
    mean_brach = mean(brach_time);
    var_brach = var(brach_time);
    
    % split up each muscle's data into 1 second sections
    bi_split = reshape(bi_time,fs,[])';
    tri_split = reshape(tri_time,fs,[])';
    brach_split = reshape(brach_time,fs,[])';
    
    % plot the time-series of the EMG for each muscle segment
    figure
    subplot(3,1,1)
    plot(t,bi_time); title(['Bicep EMG for Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    subplot(3,1,2)
    plot(t,tri_time); title(['Tricep EMG for Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    subplot(3,1,3)
    plot(t,brach_time); title(['Brachioradialis EMG for Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    
    
    % find stats for each second of data for the muscles
    for i = 1:n/fs
        min_bi_split(i) = min(bi_split(i,:));
        max_bi_split(i) = max(bi_split(i,:));
        mean_bi_split(i) = mean(bi_split(i,:));
        var_bi_split(i) = var(bi_split(i,:));
        
        min_tri_split(i) = min(tri_split(i,:));
        max_tri_split(i) = max(tri_split(i,:));
        mean_tri_split(i) = mean(tri_split(i,:));
        var_tri_split(i) = var(tri_split(i,:));
        
        min_brach_split(i) = min(brach_split(i,:));
        max_brach_split(i) = max(brach_split(i,:));
        mean_brach_split(i) = mean(brach_split(i,:));
        var_brach_split(i) = var(brach_split(i,:));
    end
    
    % plot statistics over time for each muscle
    figure
    subplot(2,2,1)
    plot(t_sec,min_bi_split); title(['Minimum for each second of bicep signal Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    subplot(2,2,2)
    plot(t_sec,max_bi_split); title(['Maximum for each second of bicep signal Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    subplot(2,2,3)
    plot(t_sec,mean_bi_split); title(['Mean for each second of bicep signal Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    subplot(2,2,4)
    plot(t_sec,var_bi_split); title(['Variance for each second of bicep signal Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    
    figure
    subplot(2,2,1)
    plot(t_sec,min_tri_split); title(['Minimum for each second of tricep signal Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    subplot(2,2,2)
    plot(t_sec,max_tri_split); title(['Maximum for each second of tricep signal Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    subplot(2,2,3)
    plot(t_sec,mean_tri_split); title(['Mean for each second of tricep signal Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    subplot(2,2,4)
    plot(t_sec,var_tri_split); title(['Variance for each second of tricep signal Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    
    figure
    subplot(2,2,1)
    plot(t_sec,min_brach_split); title(['Minimum for each second of brachioradialis signal Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    subplot(2,2,2)
    plot(t_sec,max_brach_split); title(['Maximum for each second of brachioradialis signal Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    subplot(2,2,3)
    plot(t_sec,mean_brach_split); title(['Mean for each second of brachioradialis signal Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    subplot(2,2,4)
    plot(t_sec,var_brach_split); title(['Variance for each second of brachioradialis signal Subject ', num2str(x)]);
    xlabel('Time (s)'); ylabel('Amplitude (V)');
    
    % find power of each second of data
    bi_power = abs(fft(bi_split, N, 2)).^2;
    tri_power = abs(fft(tri_split, N, 2)).^2;
    brach_power = abs(fft(brach_split, N, 2)).^2;
    
    % determine the median frequency of each second of data
    for i = 1:n/fs
        bi_halfPower(i) = max(bi_power(i,:))/2;                   % find half power
        bi_dist(i,:) = abs(bi_halfPower(i) - bi_power(i,:));     % find diff between half power and each power value
        bi_minDist(i) = min(bi_dist(i,:));                        % find lowest difference (closest to half power)
        bi_median(i) = find(bi_dist(i,:) == bi_minDist(i), 1);   % find the index of the median frequency
        
        tri_halfPower(i) = max(tri_power(i,:))/2;
        tri_dist(i,:) = abs(tri_halfPower(i) - tri_power(i,:));
        tri_minDist(i) = min(tri_dist(i,:));
        tri_median(i) = find(tri_dist(i,:) == tri_minDist(i), 1);
        
        brach_halfPower(i) = max(brach_power(i,:))/2;
        brach_dist(i,:) = abs(brach_halfPower(i) - brach_power(i,:));
        brach_minDist(i) = min(brach_dist(i,:));
        brach_median(i) = find(brach_dist(i,:) == brach_minDist(i), 1);
    end
    
    % split data in before fatigue and after fatigue segments for
    % statistical analysis
    bi_before = bi_median(1:30)';
    bi_after = bi_median(61:end)';
    tri_before = tri_median(1:30)';
    tri_after = tri_median(61:end)';    
    brach_before = brach_median(1:30)';
    brach_after = brach_median(61:end)';
    
    % perform paired t-test on before and after fatigue data to determine
    % if fatigue was statistically significant or not
    [bi_h(x),bi_p(x)] = ttest(bi_before, bi_after);
    [tri_h(x), tri_p(x)] = ttest(tri_before, tri_after);
    [brach_h(x), brach_p(x)] = ttest(brach_before, brach_after);
    
    % plot the median frequency vs time and add line of best fit
    figure
    subplot(3,1,1)
    plot(t_sec, f(bi_median)); title(['Median Frequency Biceps Subject ', num2str(x)])    % plot
    bi_coef = polyfit(t_sec, f(bi_median), 1);        % find regression coefficinets
    bi_x = linspace(min(t_sec), max(t_sec), 1000);     % create x vector for line
    bi_y = polyval(bi_coef , bi_x);                  % create y vector for line
    hold on;
    plot(bi_x, bi_y, 'r-', 'LineWidth', 2);           % add line to plot
    hold off
    xlabel('Time (s)'); ylabel('Frequency (Hz)');
    ylim([0 100])
    
    subplot(3,1,2)
    plot(t_sec, f(tri_median)); title(['Median Frequency Triceps Subject ', num2str(x)])
    tri_coef = polyfit(t_sec, f(tri_median), 1);
    tri_x = linspace(min(t_sec), max(t_sec), 1000);
    tri_y = polyval(tri_coef , tri_x);
    hold on;
    plot(tri_x, tri_y, 'r-', 'LineWidth', 2);
    hold off
    xlabel('Time (s)'); ylabel('Frequency (Hz)');
    ylim([0 100])
    
    subplot(3,1,3)
    plot(t_sec, f(brach_median)); title(['Median Frequency Brachioradialis Subject ', num2str(x)])
    brach_coef = polyfit(t_sec, f(brach_median), 1);
    brach_x = linspace(min(t_sec), max(t_sec), 1000);
    brach_y = polyval(brach_coef , brach_x);
    hold on;
    plot(brach_x, brach_y, 'r-', 'LineWidth', 2);
    hold off
    xlabel('Time (s)'); ylabel('Frequency (Hz)');
    ylim([0 100])
    
    % save coefficients for slope of fatigue
    coefs_bi(x,:) = bi_coef;
    coefs_tri(x,:) = tri_coef;
    coefs_brach(x,:) = brach_coef;
    
    ant_label = 'Antagonistic Muscles: Biceps and Triceps';
    syn_label = 'Synergistic Muscles: Biceps and Brachioradialis';
    % complete MSC calculations on synergistic and antagonistic pairs
    msc(bi_time', brach_time', fs, 600, x, syn_label);
    msc(bi_time', tri_time', fs, 600, x, ant_label);

end

avg_bi = mean(coefs_bi(:,1));
avg_tri = mean(coefs_tri(:,1));
avg_brach = mean(coefs_brach(:,1));

