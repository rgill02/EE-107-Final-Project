function [output] = Channel(fs, h_coef, signal)
%Channel Models our channel
%   Plots the impulse and frequency response of the channel, passes the
%   signal through the channel, and plots the eye diagram associated with
%   this signal and channel.
%   
%   Inputs:
%       fs = sampling frequency
%       h_coef = coefficients of channel
%       signal = vector respresnting modulated signal
%   Outputs:
%       output = vector representing signal after being passed through
%                channel

%upsample channel to get impulse response
h = upsample(h_coef, fs);
%apply channel by convolution
output = conv(h, signal);

end

