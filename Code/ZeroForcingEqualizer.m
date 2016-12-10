function [output] = ZeroForcingEqualizer(sample_width, pulse_time, h_coef, h, noise_power, signal, to_plot, is_hsp, K)
%ZeroForcingEqualizer Models the zero forcing equalizer associated with our
%channel
%   Zero Forcing Equalizer is used to undo the effects of the channel. It
%   has the inverse of the channel's frequency response. This function
%   plots the impulse and frequency response of the zero forcing equalizer,
%   passes the signal through it, and plots the eye diagram associated with
%   the signal after it has been passed through the equalizer
%
%   Input:
%       sample_width = width of pulse in samples
%       pulse_time = width of pulse in seconds
%       h_coef = coefficients of channel filter (non zero padded)
%       h = impulse response of channel (zero padded)
%       noise_power = power of noise
%       signal = vector representing signal to pass through equalizer
%       to_plot = boolean if to show plots
%       is_hsp = true if half sine pulse
%       K = truncation parameter
%   Outputs:
%       output = vector representing equalized signal

%% Plot Impulse and Frequency Response of Equalizer
%plot frequency response of the zero forcing equalizer
%freqz takes a numerator and denominator of the filter, z transform gives
%the numerator of the channel which are just the pulse amplitudes,
%therefore since the zero forcing filter is just the inverse then swap the
%numerator and denominator
if to_plot
    figure;
    freqz([1], h_coef);
    title('Frequency Response of Zero Forcing Equalizer');
end
%call above plots is and call below stores frequency response
[Q, w] = freqz([1], h_coef);

%plot impulse response
q = ifft(Q);
t = 0:1:length(q)-1;
if to_plot
    figure;
    plot(t, real(q));
    xlabel('Sample (n)');
    ylabel('q(t)');
    title('Impulse Response of Zero Forcing Equalizer');
end

%% Pass Signal Through Equalizer
output = filter([1], h, signal);

if to_plot
    figure;
    plot(output);
    title('Signal After Zero Forcing Equalizer');
end

%% Create Eye Diagram
if to_plot
    RyanEyeDiagram(sample_width, pulse_time, noise_power, 'Eye Diagram After Zero Forcing Equalizer', output, is_hsp, K);
end

end

