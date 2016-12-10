close all;

%define constants
fs = 32;
T = 1;
is_hsp = false;
alpha = 0.5;
K = 6;

%define bitstream
bits = [1 1 0 1 0 1 0 0 0 1 0 1 0 0 1 1 0 1 1 1 0 1 1 1 0 1 0 1 0 0 1 1];

%modulate signal
if is_hsp
    modulated_signal = Modulate_HSP(fs, T, bits);
else
    modulated_signal = Modulate_SRRC(fs, T, alpha, K, bits);
end

%plot modulated signal
figure;
plot(modulated_signal);
title('Modulated Signal');

%pass signal through matched filter
matched_output = MatchedFilter(fs, T, alpha, K, modulated_signal, is_hsp);

%plot output of matched filter
figure;
plot(matched_output);
title('Output of Matched Filter');

%sample and detect signal
%TODO fix num of bits
received_bits = SampleDetect(fs, T, K, matched_output, is_hsp, length(bits));

%check if got correct bits
if isequal(received_bits, bits) == 0
    ans = 'You done fucked up'
else
    ans = 'Nice job'
end
