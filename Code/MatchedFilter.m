function [output] = MatchedFilter(fs, hsp_time, alpha, K, signal, to_plot, is_hsp)
%MatchedFilter Applies the appropriate matched filter to the signal
%   Detailed explanation goes here
%   Inputs:
%       fs = sampling frequency
%       hsp_time = width of half sine pulse (seconds)
%       alpha = roll off factor used for raised cosine pulse
%       K = truncation length for raised cosine pulse
%       signal = vector representing signal to modulate
%       to_plot = show plots or not (boolean)
%       is_hsp = true for half sine pulse, false for raised cosine
%   Outputs:
%       output = signal after being passed through the matched filter

%construct half sine pulse
ts = 0:(hsp_time/fs):(hsp_time-hsp_time/fs);    % time vector for hsp
hsp = sin(pi*ts/hsp_time);                      % half-sine pulse shape
hsp_energy = sum(hsp.^2);

if is_hsp
    %apply half sine pulse through convolution
    output = conv(signal, hsp);
else
    %apply root raised cosine pulse through convolution
    ts = -K*hsp_time:(hsp_time/fs):(K*hsp_time-hsp_time/fs);
    srrc = ManualSRRC(ts,hsp_time,alpha,K,hsp_energy);
    output = conv(signal, srrc);
end

if to_plot
    figure;
    plot(output);
    title('Signal After Matched Filter');
end

end

