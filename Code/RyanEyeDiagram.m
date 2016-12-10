function [] = RyanEyeDiagram(fs, T, noise_power, diagram_title, signal, is_hsp, K)
%RyanEyeDiagram Abstracts Eye diagram function
%
%   Inputs:
%       fs = pulse width in samples
%       T = pulse width in seconds
%       noise_power = power of noise
%       diagram_title = title of eye diagram
%       signal = vector representing signal
%       is_hsp = true if half sine pulse
%       K = truncation parameter
%   Outputs:
%       None

offset = fs/2;

%SRRC requires special eye diagram parameters
if is_hsp == false
    %grab portion of srrc to get rid of distortion on ends
    temp = length(signal);
    signal = signal(temp/4:3*temp/4);
    if mod(K,2) == 0
        offset = 9;
    else
        offset = 25;
    end
end

%plot and combine all eye diagrams to ensure we have complete picture, 
%code to combine figures is from:
%https://www.mathworks.com/matlabcentral/answers/127341-is-there-any-way-
%to-merge-several-figures-already-drawn-into-one-fugure
fhandles(1) = eyediagram(signal, fs, T, offset);
fhandles(2) = eyediagram(-1*signal, fs, T, offset);

handleLine = findobj(fhandles,'type','line');
figure;
title([diagram_title ', Noise Power = ' num2str(noise_power)]);
xlabel('Time');
ylabel('Amplitude');
hold on ;
for j = 1 : length(handleLine)
    plot(get(handleLine(j),'XData'), get(handleLine(j),'YData')) ;
end
hold off;
%close all individual eye diagrams
for k = 1:length(fhandles)
    close(fhandles(k));
end

end

