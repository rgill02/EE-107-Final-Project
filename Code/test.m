close all;

%define constants
fs = 32;
T = 1;
is_hsp = false;
alpha = 0.5;
K = 6;
noise_power = 0;
N = 1;

%load image
[Ztres, block_height, block_width, pixel_height, pixel_width, minval, maxval] = ImagePreProcess();
bit_matrix = ConvertToBitstream(Ztres, N);

%modulate signal
if is_hsp
    modulated_signal = Modulate_HSP(fs, T, bit_matrix(1,:));
else
    modulated_signal = Modulate_SRRC(fs, T, alpha, K, bit_matrix(1,:));
end

%plot modulated signal
figure;
plot(modulated_signal);
title('Modulated Signal');

%add noise to signal
noisy_signal = Noise(noise_power, modulated_signal);

%plot noisy signal
figure;
plot(noisy_signal);
title('Signal with Noise');

%pass signal through matched filter
matched_output = MatchedFilter(fs, T, alpha, K, noisy_signal, is_hsp);

%plot output of matched filter
figure;
plot(matched_output);
title('Output of Matched Filter');

%sample and detect signal
%TODO fix num of bits
received_bits = SampleDetect(fs, T, K, matched_output, is_hsp, N);

%restore image
newZtres = ConvertFromBitstream(bit_matrix, N);
ImagePostProcess(newZtres, block_height, block_width, pixel_height, pixel_width, minval, maxval);

%check if got correct bits
if isequal(received_bits, bit_matrix(1,:)) == 0
    ans = 'You done fucked up'
else
    ans = 'Nice job'
end
