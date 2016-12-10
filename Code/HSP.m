function [output] = HSP(fs, T)
%HSP Generates single half sine pulse
%   
%   Inputs:
%       fs = sampling frequency
%       T = pulse width in time
%   Outputs:
%       output = vector representing pulse

t = 0:1/fs:T-(1/fs);
output = sin(pi*t/T);

end

