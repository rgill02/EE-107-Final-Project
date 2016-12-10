function [output] = Equalizer(pulse_width, pulse_time, channel_coef, channel_ir, noise_power, signal, to_plot, is_zf, is_hsp, K)
%Equalizer Reverses effects of channel
%   
%   Inputs:
%       pulse_width = width of pulse in samples
%       pulse_time = width of pulse in seconds
%       channel_coef = vector of coefficients representing channel transfer
%                      function
%       channel_ir = zero padded impulse response of channel
%       noise_power = power of noise
%       signal = vector representing signal
%       to_plot = boolean whether or not to display plots
%       is_zf = true if zero forcing, false if mmse
%       is_hsp = true if half sine pulse
%       K = truncation parameter
%   Outputs:
%       output = resulting signal

if is_zf
    output = ZeroForcingEqualizer(pulse_width, pulse_time, channel_coef, channel_ir, noise_power, signal, to_plot, is_hsp, K);
else
    output = MMSEEqualizer(pulse_width, pulse_time, channel_coef, channel_ir, noise_power, signal, to_plot, is_hsp, K);
end

end

