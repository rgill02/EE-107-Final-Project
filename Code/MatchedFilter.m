function [output] = MatchedFilter(fs, T, alpha, K, signal, is_hsp)
%MatchedFilter Applies the appropriate matched filter to the signal
%   
%   Inputs:
%       fs = sampling frequency
%       T = bit duration in time
%       alpha = roll off factor used for raised cosine pulse
%       K = truncation length for raised cosine pulse
%       signal = vector representing signal associated with matched filter
%       is_hsp = true for half sine pulse, false for raised cosine
%   Outputs:
%       output = signal after being passed through the matched filter

if is_hsp
    output = conv(signal, HSP(fs, T));
else
    output = conv(signal, SRRC(fs, T, alpha, K));
end

end

