function [] = RunCommsSystem(fs, T, is_hsp, is_zf, alpha, K, noise_power, N, h_coef)
%RunCommsSystem Summary of this function goes here
%   Detailed explanation goes here

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

if is_hsp
    pulse_type = 'HSP, ';
else
    pulse_type = 'SRRC, ';
end

if is_zf
    eq_type = 'Zero Forcing EQ, ';
else
    eq_type = 'MMSE EQ, ';
end

title([pulse_type eq_type 'Noise = ' num2str(noise_power)]);

end

