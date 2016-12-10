function [noisy_output] = Noise(noise_power, signal)
%Noise Models the noise in our channel and system
%   Adds additive white gaussian noise to our signal with a specified noise
%   power and plots the eye diagram with the added noise
%
%   Inputs:
%       noise_power = power of the noise
%       signal = vector representing modulated signal to add noise to
%   Outputs:
%       noisy_output = signal with noise added

%compute sigma from noise power
sigma = sqrt(noise_power);
%create noise matrix to apply to the channel output
noise_matrix = sigma*randn(1, length(signal));
%add gaussian noise to the input signal
noisy_output = signal + noise_matrix;

end

