function [output] = SRRC(fs, T, alpha, K)
%SRRC Generates single square root raised cosine pulse
%   
%   Inputs:
%       fs = sampling frequency
%       T = bit duration in time
%       alpha = roll off factor
%       K = truncation parameter
%   Outputs:
%       output = vector representing pulse

%allocate output vector
t = -K*T:1/fs:(K*T)-(1/fs);
output = zeros(1, length(t));

%construct srrc pulse
for ii = 1:length(output)
    if t(ii) == 0
        %special case where denominator equals 0
        output(ii) = 1 - alpha + 4*alpha/pi;
    elseif abs(t(ii)) == T/(4*alpha)
        %special case where denominator equals 0
        output(ii) = (alpha/sqrt(2)) * ((1+(2/pi))*sin(pi/(4*alpha)) + (1-(2/pi))*cos(pi/(4*alpha)));
    else
        output(ii) = (sin(pi*t(ii)/T*(1-alpha)) + 4*alpha*t(ii)/T*cos(pi*t(ii)/T*(1+alpha))) / (pi*t(ii)/T*(1-((4*alpha*t(ii)/T)^2)));
    end 
end

%compute energy in srrc pulse
srrc_energy = sum(output.^2);
%compute energy in hsp pulse
hsp_energy = sum(HSP(fs, T).^2);
%compute normalization factor
A = sqrt(hsp_energy/srrc_energy);

%apply normalization factor
output = A*output;


end

