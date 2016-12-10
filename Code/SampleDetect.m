function [received_bits] = SampleDetect(fs, T, K, signal, is_hsp, N)
%SampleDetect Samples and thresholds input signal
%
%   Inputs:
%       fs = sampling frequency
%       T = bit duration in time
%       K = truncation length for raised cosine pulse
%       signal = vector representing signal to modulate
%       is_hsp = true for half sine pulse, false for raised cosine
%       N = number of dct blocks per transmission
%   Outputs:
%       received_bits = vector respresenting received bits

%allocate output vector
num_samples = 512*N;
received_bits = zeros(1, num_samples);

if is_hsp
    %sampling for HSP
    for ii = 1:num_samples
        %threshold signal
        if signal(fs*T*ii + 1) > 0
            received_bits(ii) = 1;
        else
            received_bits(ii) = 0;
        end
    end
else
    %sampling for SRRC
    jj = 1;
    start_index = 2*K*T*fs+1;
    for ii = start_index:fs:start_index+(num_samples-1)*fs*T
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