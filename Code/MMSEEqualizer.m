function [output] = MMSEEqualizer(fs, h_coef, noise_power, signal)
%MMSEEqualizer Models MMSE Equalizer
%   
%   Inputs:
%       fs = sampling frequency
%       h_coef = coefficients of channel
%       noise_power = power of noise
%       signal = vector representing signal
%   Outputs:
%       output = resulting signal

%upsample channel to get impulse response
h = upsample(h_coef, fs);
%compute frequency response
H = fft(h, length(signal));
%compute impulse response of MMSE equalizer
Q = conj(H) ./ (abs(H).^2 + 2*noise_power);
q = ifft(Q);
%apply MMSE equalizer through convolution
output = conv(q, signal);

end

