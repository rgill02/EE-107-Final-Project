function [noisy_output] = Noise(sample_width, pulse_time, noise_power, signal, to_plot, is_hsp, K)
%Noise Models the noise in our channel and system
%   Adds additive white gaussian noise to our signal with a specified noise
%   power and plots the eye diagram with the added noise
%
%   Inputs:
%       sample_width = width of pulse in samples
%       pulse_time = width of pulse in seconds
%       noise_power = power of the noise
%       signal = vector representing modulated signal to add noise to
%       to_plot = boolean if to show plots
%       is_hsp = true if half sine pulse
%       K = truncation parameter
%   Outputs:
%       noisy_output = signal with noise added

%% Add Noise to Signal
%compute sigma from noise power
sigma = sqrt(noise_power);
%create noise matrix to apply to the channel output
noise_matrix = sigma*randn(1, length(signal));
%add gaussian noise to the input signal
noisy_output = signal + noise_matrix;

if to_plot
    figure;
    plot(noisy_output);
    title('Signal After Noise');
end

%% Create Eye Diagram
if to_plot
    RyanEyeDiagram(sample_width, pulse_time, noise_power, 'Eye Diagram with Noise', noisy_output, is_hsp, K);
end

end

