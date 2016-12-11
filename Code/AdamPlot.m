function [] = AdamPlot(signal, plot_title)
%AdamPlot Plots signal
%   
%   Inputs:
%       signal = vector of signal to plot
%       plot_title = title of plot
%   Ouputs:
%       None

figure;
plot(real(signal)); %Adam likes to "keep it real"
xlabel('Samples');
ylabel('Amplitude');
title(plot_title);

end

