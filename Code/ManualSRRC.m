function [SRRC] = ManualSRRC(time,T,alpha,K,A)
%ManualSRRC Generates single SRRC pulse
%
%   Inputs:
%       time = time vector for pulse
%       T = width of pulse in seconds
%       alpha = roll off factor
%       K = truncation parameter
%       A = normalizing factor
%   Outputs:
%       SRRC = single srrc pulse

SRRC = zeros(1,2*K*32);

for ii = 1:1:length(time)
    if time(ii) == 0
        SRRC(ii) = 1 - alpha + 4*alpha/pi;
    elseif abs(time(ii)) == T/(4*alpha)
        SRRC(ii) = alpha/sqrt(2)*((1+2/pi)*sin(pi/(4*alpha)) + ...
                                  (1-2/pi)*cos(pi/(4*alpha)));        
    else
        SRRC(ii) = (sin(pi/T*time(ii)*(1-alpha)) + ...
        4*alpha/T*time(ii).*cos(pi/T*time(ii)*(1+alpha))) ./ ...
        (pi/T*time(ii).*(1-(4/T*alpha*time(ii)).^2));    
    end
end

SRRC = SRRC*A;

end