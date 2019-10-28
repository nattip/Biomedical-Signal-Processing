function hist = histogram(minimum, maximum, Nbins, data)

% This function computes the histogram for a given data vector
%
% The 4 inputs to the function are:
%   min = lower edge value of the smallest bin
%   max = upper edge value of the largest bin
%   Nbins = number of data bins to display
%   data = input data vector for histogram to be made from
%
% Written By Natalie Tipton, September 10, 2019 

% error checking
if(isempty(data))   % empty data
    error('Input vector is empty');
end

if(minimum > maximum)   % improper min/max
    error('Min value greater than max value');
end

if(Nbins < 1)   % No bins
    error('Not enough bins');
end

bin_size = (maximum - minimum) / Nbins; % calculate size of bins
hist = zeros(1, Nbins);                 % allocate size for histogram
[m,n] = size(data);                     % find size of data
highest = max(data);                    % find maximum value of data

% generate histogram values for all bins but last
for bin = 1:Nbins-1 
    hist(1,bin) = sum(data >= (minimum + (bin_size * (bin - 1))) & data < (minimum + (bin_size * bin))) / n;
end

% reset maximum value if highest data point is larger than original max
if (highest > maximum)
    maximum = highest;  
end

% generate final bin value up to maximum value
hist(1,Nbins) = sum(data >= (minimum + (bin_size * (Nbins - 1))) & data <= maximum) / n;
