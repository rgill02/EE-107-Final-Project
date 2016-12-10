clear;
close all;
clc;

%define constants
fs = 32;
T = 1;
is_hsp = true;
is_zf = true;
alpha = 0.5;
K = 6;
%noise_power = 0.1;
noise_power = [0 0.01 0.025 0.05 0.1 0.2 0.3 0.5 1];
N = 5;
h_coef = [1 1/2 3/4 -2/7];

for ii = 1:length(noise_power)
    RunCommsSystem(fs, T, true, true, alpha, K, noise_power(ii), N, h_coef);
    RunCommsSystem(fs, T, true, false, alpha, K, noise_power(ii), N, h_coef);
    RunCommsSystem(fs, T, false, true, alpha, K, noise_power(ii), N, h_coef);
    RunCommsSystem(fs, T, true, false, alpha, K, noise_power(ii), N, h_coef);
end
