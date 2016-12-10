close all;

%define constants
fs = 32;
T = 1;
is_hsp = true;
is_zf = true;
alpha = 0.5;
K = 6;
noise_power = 0.1;
N = 5;
h_coef = [1 1/2 3/4 -2/7];

%load image
[Ztres, block_height, block_width, pixel_height, pixel_width, minval, maxval] = ImagePreProcess();
bit_matrix = ConvertToBitstream(Ztres, N);

received_bits = zeros(size(bit_matrix));
for ii = 1:size(bit_matrix, 1)
    
    %modulate signal
    if is_hsp
        modulated_signal = Modulate_HSP(fs, T, bit_matrix(ii,:));
    else
        modulated_signal = Modulate_SRRC(fs, T, alpha, K, bit_matrix(ii,:));
    end

    %{
    %plot modulated signal
    figure;
    plot(modulated_signal);
    title('Modulated Signal');
    %}

    %send signal through channel
    channel_output = Channel(fs, h_coef, modulated_signal);

    %{
    %plot output of channel
    figure;
    plot(channel_output);
    title('Channel Output');
    %}

    %add noise to signal
    noisy_signal = Noise(noise_power, channel_output);

    %{
    %plot noisy signal
    figure;
    plot(noisy_signal);
    title('Signal with Noise');
    %}

    %pass signal through equalizer
    if is_zf
        equalizer_output = ZeroForcingEqualizer(fs, h_coef, noisy_signal);
    else
        equalizer_output = MMSEEqualizer(fs, h_coef, noise_power, noisy_signal);
    end

    %{
    %plot output of equalizer
    figure;
    plot(equalizer_output);
    title('Output of Equalizer');
    %}

    %pass signal through matched filter
    matched_output = MatchedFilter(fs, T, alpha, K, equalizer_output, is_hsp);

    %{
    %plot output of matched filter
    figure;
    plot(matched_output);
    title('Output of Matched Filter');
    %}

    %sample and detect signal
    received_bits(ii,:) = SampleDetect(fs, T, K, matched_output, is_hsp, N);
    
    ii
end

%restore image
newZtres = ConvertFromBitstream(received_bits, N);
ImagePostProcess(newZtres, block_height, block_width, pixel_height, pixel_width, minval, maxval);
title(['HSP=' num2str(is_hsp) ', ZF=' num2str(is_zf) ', Noise=' num2str(noise_power)]);

