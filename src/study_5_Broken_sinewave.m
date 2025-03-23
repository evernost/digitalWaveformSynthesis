% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : N/A
% File name     : study_5_Broken_sinewave.m
% File type     : Matlab script
% Purpose       : study 5 - Spectrum of a sinewave with one or more discontinuities
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Sunday, 23 March 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================

% PURPOSE
% TODO!

clc
close all



% =============================================================================
% SETTINGS
% =============================================================================
N_PTS = 10000;
N0 = 345;
FFT_SIZE = 262144;
FS = 48000;
F0 = 100.6;



% =============================================================================
% MAIN SCRIPT
% =============================================================================
t = (0:(N_PTS-1))'/FS;

phi = 2*pi*F0*t;
x = sin(phi);

phi(N0:end) = phi(N0:end) - 10;
xBrk = sin(phi);


s = abs(fft(x, FFT_SIZE));
sBrk = abs(fft(xBrk, FFT_SIZE));
pltRange = 1:(FFT_SIZE/2);

plot(20*log10([s(pltRange), sBrk(pltRange)]))
