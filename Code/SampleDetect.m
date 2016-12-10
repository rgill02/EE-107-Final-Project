function [received_bits] = SampleDetect(fs, hsp_time, alpha, K, signal, to_plot, is_hsp, N)
%SampleDetect Samples and thresholds input signal
%
%   Inputs:
%       fs = sampling frequency
%       hsp_time = width of half sine pulse (seconds)
%       alpha = roll off factor used for raised cosine pulse
%       K = truncation length for raised cosine pulse
%       signal = vector representing signal to modulate
%       to_plot = show plots or not (boolean)
%       is_hsp = true for half sine pulse, false for raised cosine
%       N = number of dct blocks per transmission
%   Outputs:
%       received_bits = vector respresenting received bits

%create vector to store transmitted bits in
num_samples = 512*N;
received_bits = zeros(1, num_samples);

if is_hsp
    %sampling for HSP
    for ii = 1:num_samples
        %threshold signal
        if signal(fs*ii + 1) > 0
            received_bits(ii) = 1;
        else
            received_bits(ii) = 0;
        end
    end
else
    %sampling for SRRC
    jj = 1;
    start_index = 2*fs*K;
    for ii = start_index:fs:start_index+(num_samples-1)*fs
        %threshold signal
        if signal(ii) > 1
            received_bits(jj) = 1;
        else
            received_bits(jj) = 0;
        end
        jj = jj+1;
    end
end

end