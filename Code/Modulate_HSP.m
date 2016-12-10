function [output] = Modulate_HSP(fs, T, bits)
%Modulate_HSP Modulates the half sine pulse
%
%   Inputs:
%       fs = sampling frequency
%       T = pulse width in time
%       bits = vector representing bitstream
%   Outputs:
%       output = modulated signal

%allocate output vector
num_bits = length(bits);
output = zeros(1, num_bits*fs*T);

%create half sine pulse
hsp = HSP(fs, T);

%modulate signal
jj = 1; %counter for output
for ii = 1:num_bits
    if bits(ii) == 1
        output(jj:jj+(fs*T)-1) = hsp;
    else
        output(jj:jj+(fs*T)-1) = -1*hsp;
    end
    jj = jj+(fs*T);
end

end