function [output, h_coef, h] = Channel(fs, sample_width, pulse_time, No, signal, to_plot, is_hsp, K)
%Channel Models our channel
%   Plots the impulse and frequency response of the channel, passes the
%   signal through the channel, and plots the eye diagram associated with
%   this signal and channel.
%   
%   Inputs:
%       fs = sampling frequency
%       sample_width = width of the pulse in samples
%       pulse_time = width of pulse in seconds
%       No = noise power
%       signal = vector respresnting modulated signal
%       to_plot = boolean to show plots or not
%       is_hsp = true if half sine pulse
%       K = truncation parameter
%   Outputs:
%       output = vector representing signal after being passed through
%                channel
%       h_coef = coefficients of channel filter (non zero padded)
%       h = impulse response of channel (zero padded)

%% Construct Channel
%vector to hold coefficients of channel
h_coef = [1 1/2 3/4 -2/7];
num_h_coef = length(h_coef);

%create a vector to hold the time and zero padded channel values
t_channel = 0:1/fs:num_h_coef-(1/fs);
h = zeros(1, num_h_coef*fs);
%t_channel = (0:1:length(signal)-1)/fs;
%h = zeros(1, length(signal));

%set delta functions to create the zero padded channel
for coef_index = 1:num_h_coef
    h(fs*(coef_index-1) + 1) = h_coef(coef_index);
end

%% Plot Impulse and Frequency Response of Channel
%plot impulse response of the channel
if to_plot
    figure;
    scatter(t_channel, h);
    axis([-1/fs 4 -3/2 3/2]);
    xlabel('Time');
    ylabel('h[n]');
    title('Impulse Response of Channel');
end

%plot frequency response of the channel
%freqz takes a numerator and denominator of the filter, z transform gives
%the numerator which are just the pulse amplitudes
if to_plot
    figure;
    freqz(h_coef, [1]);
    title('Frequency Response of Channel');
end

%% Pass Signal Through Channel
output = filter(h, [1], signal);

if to_plot
    figure;
    plot(output);
    title('Signal After Channel');
end

%% Create Eye Diagram
if to_plot
    RyanEyeDiagram(sample_width, pulse_time, No, 'Eye Diagram After Channel', output, is_hsp, K);
end

end

