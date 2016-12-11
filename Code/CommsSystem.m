function [success] = CommsSystem(fs, T, is_hsp, is_zf, alpha, K, noise_power, N, h_coef, plot_signals, plot_eyes)
%CommsSystem Does a single simulation of the communication system
%   
%   Inputs:
%       fs = sampling frequency
%       T = bit duration in time
%       is_hsp = true if half sine pulse,
%       is_zf = true if zero forcing equalizer
%       alpha = roll off factor for srrc
%       K = truncation parameter for srrc
%       noise_power = power of noise
%       N = number of dct blocks to send per transmission
%       h_coef = coefficients of channel
%       plot_signals = true will show plots of the signal after each stage
%       plot_eyes = true will plot eye diagrams
%   Outputs:
%       success = outputs true if the bitmatrix that was sent was
%       successfully recovered. Need this because image post process does
%       not work correctly so the resulting image is not a good evaluation
%       of our communication system. This output is only a good evaluation
%       of our system when there is 0 noise because if even a single bit is
%       wrong it will return false

%create title for run
if is_hsp
    pulse_type = 'HSP';
else
    pulse_type = 'SRRC';
end
if is_zf
    eq_type = 'Zero Forcing EQ';
else
    eq_type = 'MMSE EQ';
end
my_title = [pulse_type ', ' eq_type ', ' 'Noise = ' num2str(noise_power)];

%indicate start of simulation
fprintf('Starting run with: %s\n', my_title);
fprintf('Running...');

%load image
[Ztres, block_height, block_width, pixel_height, pixel_width, minval, maxval] = ImagePreProcess();
bit_matrix = ConvertToBitstream(Ztres, N);

%send picture
received_bits = zeros(size(bit_matrix));
for ii = 1:size(bit_matrix, 1)
    
    %modulate signal
    if is_hsp
        modulated_signal = Modulate_HSP(fs, T, bit_matrix(ii,:));
    else
        modulated_signal = Modulate_SRRC(fs, T, alpha, K, bit_matrix(ii,:));
    end

    %send signal through channel
    channel_output = Channel(fs, h_coef, modulated_signal);

    %add noise to signal
    noisy_signal = Noise(noise_power, channel_output);

    %pass signal through equalizer
    if is_zf
        equalizer_output = ZeroForcingEqualizer(fs, h_coef, noisy_signal);
    else
        equalizer_output = MMSEEqualizer(fs, h_coef, noise_power, noisy_signal);
    end

    %pass signal through matched filter
    matched_output = MatchedFilter(fs, T, alpha, K, equalizer_output, is_hsp);

    %sample and detect signal
    received_bits(ii,:) = SampleDetect(fs, T, K, matched_output, is_hsp, N);
    
    %show it is still running
    if mod(ii, ceil(25/N)) == 0
        fprintf('.');
    end
end

%check if received bits are correct
if isequal(received_bits, bit_matrix)
    success = true
else
    success = false
end

%restore image
newZtres = ConvertFromBitstream(received_bits, N);
ImagePostProcess(newZtres, block_height, block_width, pixel_height, pixel_width, minval, maxval);
title(my_title);

%plot signals
if plot_signals
    AdamPlot(modulated_signal, {'Modulated Signal'; my_title});
    AdamPlot(channel_output, {'Channel Output'; my_title});
    AdamPlot(noisy_signal, {'Channel Output + Noise'; my_title});
    AdamPlot(equalizer_output, {'Output of Equalizer'; my_title});
    AdamPlot(matched_output, {'Output of Matched Filter'; my_title});
end

%plot eye diagrams
if plot_eyes
    if is_hsp
        offset = 0;
    else
        offset = (((2*K*fs*T)-(fs*T)) / 2) + 4*fs*T;
    end
    RyanEyeDiagram(fs, T, is_hsp, {'Modulated Signal'; my_title}, modulated_signal(1+offset:length(modulated_signal)-offset), false);
    RyanEyeDiagram(fs, T, is_hsp, {'Channel Output'; my_title}, channel_output(1+offset:length(modulated_signal)-offset), false);
    RyanEyeDiagram(fs, T, is_hsp, {'Channel Output + Noise'; my_title}, noisy_signal(1+offset:length(modulated_signal)-offset), false);
    RyanEyeDiagram(fs, T, is_hsp, {'Output of Equalizer'; my_title}, equalizer_output(1+offset:length(modulated_signal)-offset), false);
    if is_hsp
        RyanEyeDiagram(fs, T, is_hsp, {'Output of Matched Filter'; my_title}, matched_output(1+fs*T:length(modulated_signal)), true);
    else
        RyanEyeDiagram(fs, T, is_hsp, {'Output of Matched Filter'; my_title}, matched_output(1+2*K*fs*T:length(modulated_signal)), true);
    end
end

%indicate end of simulation
fprintf('\nDone\n');

end

