function [modulated_HSP,HSP_energy] = Modulate_HSP(fs, T, current_set)
%Modulate_HSP Modulates the half sine pulse
%
%   Inputs:
%       fs = sampling frequency
%       T = pulse time
%       current_set = vector representing signal
%   Outputs:
%       modulated_HSP = resulting signal
%       HSP_energy = energy of half sine pulse

bits_per_set    = length(current_set);
samples_per_set = bits_per_set*fs;

ts = 0:(T/fs):(T-T/fs); % time vector for HSP
HSP = sin(pi*ts/T);                               % half-sine pulse shape

modulated_HSP = zeros(1,samples_per_set);         % preallocate

jj = 1;     % counter for index in the modulated array

% iterate along all the bits in the current set 
for ii = 1:1:bits_per_set
    if current_set(ii) == 1
        modulated_HSP(1,jj:jj+31) = HSP(1,:);
    else
        modulated_HSP(1,jj:jj+31) = -HSP(1,:);
    end
    jj = jj+32;
end

HSP_energy = sum(HSP.^2);

end