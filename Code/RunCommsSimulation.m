% Adam Chapman + Ryan Gill
% EE-107
% Final Project

clear;
close all;
clc;

%define simulation parameters
fs = 32;                    %sampling frequency (samples/sec)
T = 1;                      %bit duration (seconds)
N = 5;                      %number of dct blocks to send per transmission
alpha = 0.5;                %roll off factor of srrc
K = 6;                      %truncation parameter of srrc
noise_power = 0;            %power of noise
is_hsp = true;              %true for hsp and false for srrc
is_zf = true;               %true for zero forcing equalizer and false for mmse
h_coef = [1 1/2 3/4 -2/7];  %impulses of channel (non zero padded)
plot_signals = false;       %show signal after every stage
plot_eyes = false;          %show eye diagram after every stage

%simulate communication system
success = CommsSystem(fs, T, is_hsp, is_zf, alpha, K, noise_power, N, h_coef, plot_signals, plot_eyes);
