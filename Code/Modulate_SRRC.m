function [output] = Modulate_SRRC(fs, T, alpha, K, bits)
%Modulate_SRRC Modulates the square root raised cosine pulse
%
%   Inputs:
%       fs = sampling frequency
%       T = width of bit pulse
%       alpha = roll off factor
%       K = truncation parameter
%       bits = vector of bits
%   Outputs:
%       output = modulated signal

%allocate output vector
num_bits = length(bits);
spill_over = 2*K*T*fs - T*fs;
output = zeros(1, num_bits*fs*T + spill_over);

%generate srrc pulse
srrc = SRRC(fs, T, alpha, K);
srrc_pulse_width = length(srrc);

jj = 1;
for ii = 1:num_bits
    if bits(ii) == 1
        output(jj:jj+srrc_pulse_width-1) = output(jj:jj+srrc_pulse_width-1) + srrc;
    else
        output(jj:jj+srrc_pulse_width-1) = output(jj:jj+srrc_pulse_width-1) - srrc;
    end
    jj = jj + fs*T;
end

end