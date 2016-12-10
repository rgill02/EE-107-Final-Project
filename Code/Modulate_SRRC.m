function [modulated_SRRC] = Modulate_SRRC(fs, hsp_time, alpha, K, hsp_energy, signal)
%Modulate_SRRC Modulates the square root raised cosine pulse
%
%   Inputs:
%       fs = sampling frequency
%       hsp_time = time of half sine pulse
%       alpha = roll off factor
%       K = truncation parameter
%       hsp_energy = energy of half sine pulse
%       signal = vector of bits
%   Outputs:
%       modulated_SRRC = resulting signal

signal(signal==0) = -1;         %change zeros to -1
bits_per_set = length(signal);
samples_per_pulse = 2*K*fs;
time = -K*hsp_time:1/fs:K*hsp_time-1/fs;
%time = -K*hsp_time:1/fs:K*hsp_time;

SRRC = ManualSRRC(time,hsp_time,alpha,K,hsp_energy);

mod_samples = (2*K+bits_per_set-1)*fs;

modulated_SRRC = zeros(1,mod_samples);

jj = 1;
% iterate along all the bits in the current set 
for ii = 1:1:bits_per_set
    modulated_SRRC(jj:jj+samples_per_pulse-1) = ...
        modulated_SRRC(jj:jj+samples_per_pulse-1) + SRRC*signal(ii);
    jj = jj+fs;
    %figure;
    %plot(modulated_SRRC);
    %title(jj);
end

end