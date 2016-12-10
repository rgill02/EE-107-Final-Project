function [output] = Modulate(fs, hsp_time, alpha, K, signal, to_plot, is_hsp)
%Modulate Modulates the bitstream
%
%   Inputs:
%       fs = sampling frequency
%       hsp_time = width of half sine pulse (seconds)
%       alpha = roll off factor used for raised cosine pulse
%       K = truncation length for raised cosine pulse
%       signal = vector representing signal to modulate
%       to_plot = show plots or not (boolean)
%       is_hsp = true for half sine pulse, false for raised cosine
%   Outputs:
%       output = modulated signal

%need to call to get energy for raised cosine
[hsp_output, hsp_energy] = Modulate_HSP(fs, hsp_time, signal);

if is_hsp
    output = hsp_output;
else
    output = Modulate_SRRC(fs, hsp_time, alpha, K, hsp_energy, signal);
end

if to_plot
    figure;
    plot(output);
    title('Modulated Signal');
end

end

