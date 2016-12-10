% Adam Chapman + Ryan Gill
% EE-107
% Final Project

clear;
close all;
clc;

%% Define Parameters
fs = 32;        % sampling frequency
hsp_time = 1;   % half sine pulse duration (seconds)
N = 1;          % dct blocks to send per transmission
No = 0.5;         % noise power
to_plot = true; % show plots
is_hsp = false;  % true if half sine pulse, false if raised cosine
is_zf = false;   % true if zero forcing equalizer, false if mmse

K = 2;          % truncation length for SRRC
alpha = 0.5;    % rolloff factor for SRRC

%% Convert Image to Bitstream
[Ztres, block_height, block_width, pixel_height, pixel_width, minval, maxval] = ImagePreProcess();
bit_matrix = ConvertToBitstream(Ztres, N);

%% Transmission and Reception
pulse_width = fs;
pulse_time = hsp_time;

% send N dct blocks at a time
received_bitstreams = zeros(size(bit_matrix));
for ii = 1:1:size(bit_matrix, 1)
    %shows plots of first transmission only
    if ii == 2
        to_plot = false;
    end

    %current set of N dct blocks
    signal = bit_matrix(ii,:);

    % Modulation
    modulated_signal = Modulate(fs, hsp_time, alpha, K, signal, to_plot, is_hsp);
    
    % Transmit through channel
    [channel_output, channel_coef, channel_ir] = Channel(fs, pulse_width, pulse_time, No, modulated_signal, to_plot, is_hsp, K);

    % Add noise
    noisy_output = Noise(pulse_width, pulse_time, No, channel_output, to_plot, is_hsp, K);

    % Compensate for channel effects with equalizer
    equalizer_output = Equalizer(pulse_width, pulse_time, channel_coef, channel_ir, No, noisy_output, to_plot, is_zf, is_hsp, K);

    % Apply matched filter at receiver
    matched_filter_output = MatchedFilter(fs, hsp_time, alpha, K, equalizer_output, to_plot, is_hsp);

    % Sampling and detection
    received_bits = SampleDetect(fs, hsp_time, alpha, K, matched_filter_output, to_plot, is_hsp, N);

    %save received bitstreams
    received_bitstreams(ii,:) = received_bits;
end

%% Convert Bitstreams Back to Image
Z_rec = ConvertFromBitstream(received_bitstreams, N);
ImagePostProcess(Z_rec, block_height, block_width, pixel_height, pixel_width, minval, maxval);


