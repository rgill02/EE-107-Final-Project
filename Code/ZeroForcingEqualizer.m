function [output] = ZeroForcingEqualizer(fs, h_coef, signal)
%ZeroForcingEqualizer Models the zero forcing equalizer associated with our
%channel
%   Zero Forcing Equalizer is used to undo the effects of the channel. It
%   has the inverse of the channel's frequency response. This function
%   plots the impulse and frequency response of the zero forcing equalizer,
%   passes the signal through it, and plots the eye diagram associated with
%   the signal after it has been passed through the equalizer
%
%   Input:
%       fs = sampling frequency
%       h_coef = coefficients of the channel
%       signal = vector representing signal to pass through equalizer
%   Outputs:
%       output = vector representing equalized signal

%compute frequency response of the message signal
M = fft(signal);
%upsample channel to get impulse response
h = upsample(h_coef, fs);
%compute frequency response
H = fft(h, length(signal));
%compute impulse response of ZF equalizer
Q = 1 ./ H;
%multiply frequency responses of signal and equalizer, take inverse
output = ifft(M.*Q);

end

