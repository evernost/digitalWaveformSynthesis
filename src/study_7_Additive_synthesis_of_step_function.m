% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : N/A
% File name     : study_4_Stochastic_optimisation_III.m
% File type     : Matlab script
% Purpose       : study 4 - use noise to announce the discontinuity
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Sunday, 23 March 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================

% PURPOSE
% TODO!
clear all
close all
clc



% =============================================================================
% SETTINGS
% =============================================================================

% Signal properties
FS = 48000;
F0 = 100.1;
N_PER = 10.4;

% Haar basis settings
W_SIZE = 128;
W_SUB_SIZE = 16;

% FFT analysis settings
FFT_SIZE = 262144;

% Number of spectral peaks considered for the iteration
N_PEAKS = 150;

% Required number of solutions before stopping the script
N_TARGET = 10000;


F_MAX = 10000;

FIRST_STEP_SIZE_POW10 = -2;
LAST_STEP_SIZE_POW10 = -5;


% =============================================================================
% PRELIMINARY VARIABLES
% =============================================================================

nPts = round(N_PER*FS/F0);

% Generate signal
t = (0:(nPts-1))'/FS;
%[x, brk] = oscSquare(t, 0.5, F0);
[x, brk] = oscStep(t, F0, 0.5, [1, 0.5, 1.5], [-1, -0.5, -1.5]);
nBrk = length(brk);


nTerms = floor(F_MAX/F0);
M = zeros(nPts, 2*nTerms);
Msin = sin(2*pi*F0*t*(0:(nTerms-1)));
Mcos = cos(2*pi*F0*t*(0:(nTerms-1)));

M(:, 1:2:end) = Msin;
M(:, 2:2:end) = Mcos;
Minv = M(:, 2:end);

s = Minv\x;
s = [0; s];

plot([s(1:2:end), s(2:2:end)])

xRec = M*s;
plot([x, xRec])
ylim([-2 2])

s = abs(fft(xRec, FFT_SIZE));
s = s(1:(FFT_SIZE/2));
plot(20*log10(s))


