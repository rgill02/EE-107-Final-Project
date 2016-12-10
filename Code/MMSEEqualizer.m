function [output] = MMSEEqualizer(pulse_width, pulse_time, channel_coef, channel_ir, noise_power, signal, to_plot, is_hsp, K)
%MMSEEqualizer Models MMSE Equalizer
%   
%   Inputs:
%       pulse_width = width of pulse in samples
%       pulse_time = width of pulse in seconds
%       channel_coef = vector of coefficients representing transfer
%                      function of channel
%       channel_ir = zero padded impulse response of channel
%       noise_power = power of noise
%       signal = vector representing signal
%       to_plot = boolean if should plot
%       is_hsp = true if half sine pulse
%       K = truncation parameter
%   Outputs:
%       output = resulting signal

%% Construct MMSE Equalizer For Plotting
%construct equalizer to be used to plot frequency response
[H, w] = freqz(channel_coef, 1);
Q = conj(H) ./ (abs(H).^2 + 2*noise_power);

%% Plot Impulse and Frequency Response of MMSE Equalizer
%plot frequency response of MMSE equalizer
if to_plot
    figure;
    subplot(2, 1, 1);
    plot(w, 20*log10(abs(Q)));
    xlabel('w (rad/s)');
    ylabel('Magnitude of Q(s) (dB)');
    title('Frequency Response of MMSE Equalizer');
    subplot(2, 1, 2);
    plot(w, angle(Q));
    xlabel('w (rad/s)');
    ylabel('Phase of Q(s)');
end

%plot impulse response
q = ifft(Q);
t = 0:1:length(q)-1;
if to_plot
    figure;
    plot(t, real(q));
    xlabel('Sample (n)');
    ylabel('q(t)');
    title('Impulse Response of MMSE Equalizer');
end

%% Construct MMSE Equalizer to Apply to Signal
H = fft(channel_ir, length(signal));
Q = conj(H) ./ ((abs(H).^2) + 2*noise_power);

%% Pass Signal Through Equalizer
output = conv(signal, ifft(Q, length(signal)));
output = output(1:length(signal));
%output = ifft(fft(signal).*fftshift(Q));   %runs faster but does not fully work

if to_plot
    figure;
    plot(output);
    title('Signal After MMSE Equalizer');
end

%% Create Eye Diagram
if to_plot
    RyanEyeDiagram(pulse_width, pulse_time, noise_power, 'Eye Diagram after MMSE Equalizer', output, is_hsp, K);
end

end

