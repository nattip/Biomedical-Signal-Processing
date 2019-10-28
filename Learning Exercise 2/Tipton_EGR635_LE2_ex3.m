%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: LE 2 Ex 3
% Filename: Tipton_EGR635_LE2_ex3.m 
% Author: Natalie Tipton
% Class: EGR 635
% Date: 9/25/19
% Instructor: Dr. Rhodes
% Description: This script uses ensemble averaging to mitigate noise.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% Exercise 3 %%%%%%%%%%%%%%%%%%%

erp0 = load('ERP_0.txt');               % read in both data files
erp8 = load('ERP_08.txt');


erp0_sep = reshape(erp0, 500, 61)';      % separate each ERP
erp8_sep = reshape(erp8, 500, 61)';

fs = 500;                               % declare sampling frequency

t1 = 0: 1/fs:1;                          % create time vector
t1(end) = [];                           % eliminate extra data point

figure(1)
subplot(2,1,1)
plot(t1, erp0_sep(1,:));                % plot 1 ERP from 0% data in subplot
title('First ERP from 0% halothane data'); xlabel('time (s)'); ylabel('Potential (mV)')
subplot(2,1,2)
plot(t1, erp8_sep(1,:));                % plot 1 ERP from 0.8% data in subplot
title('First ERP from 0.8% halothane data'); xlabel('time (s)'); ylabel('Potential (mV)')

erp0_5 = mean(erp0_sep(1:5, :));    % average 5 ERPs from both data sets
erp8_5 = mean(erp8_sep(1:5, :));

figure(2)                               % plot the average of 5 ERPs from both
subplot(2,1,1)
plot(t1, erp0_5);        
title('Average of 5 ERPs from 0% halothane data'); xlabel('time (s)'); ylabel('Potential (mV)')
subplot(2,1,2)
plot(t1, erp8_5);
title('Average of 5 ERPs from 0.8% halothane data'); xlabel('time (s)'); ylabel('Potential (mV)')

for i = 1:20
    erp0_20 = mean(erp0_sep(1:20, :));  % average 20 ERPs from both data sets
    erp8_20 = mean(erp8_sep(1:20, :));
end
   
figure(3)                               % plot average of 20 ERPs from both
subplot(2,1,1)
plot(t1, erp0_20);
title('Average of 20 ERPs from 0% halothane data'); xlabel('time (s)'); ylabel('Potential (mV)')
subplot(2,1,2)
plot(t1, erp8_20);
title('Average of 20 ERPs from 0.8% halothane data'); xlabel('time (s)'); ylabel('Potential (mV)')

for i = 1:61
    erp0_61 = mean(erp0_sep(1:61, :));  % average all ERPs from both data sets
    erp8_61 = mean(erp8_sep(1:61, :));
end

figure(4)                               % plot average of all ERPs from both
subplot(2,1,1)
plot(t1, erp0_61);
title('Average of all ERPs from 0% halothane data'); xlabel('time (s)'); ylabel('Potential (mV)')
subplot(2,1,2)
plot(t1, erp8_61);
title('Average of all ERPs from 0.8% halothane data'); xlabel('time (s)'); ylabel('Potential (mV)')