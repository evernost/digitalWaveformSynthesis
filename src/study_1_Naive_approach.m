% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : N/A
% File name     : study_1_Naive_approach.m
% Purpose       : study 1 - the naive approach in synthesis
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Saturday, 11 January 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================

% PURPOSE
% Demonstrate how a lack of caution while trying to synthesise some typical
% 'synth' waveforms (square, sawtooth, etc.) digitally can lead to some
% nasty results.

clc
close all
clear all

% =============================================================================
% STEP 1: first order discontinuity (square/rectangular wave)
% =============================================================================

tSim = 1.0;
fs = 48000;
fftSize = 32768;

nPts = round(tSim*fs);
t = (0:(nPts-1))'/fs;

[s, brk] = oscSquare(t, 0.5, 440);

% Calibrated sinewave
s = sin(2*pi*1000*t) + 0.5*randn(nPts,1);



figure
spectrumAnalyser(s, fftSize, fftSize/4)

% figure
% spectrumAnalyser(sMod, fftSize, fftSize/4)



% =============================================================================
% STEP 2: second order discontinuity (triangle/sawtooth wave)
% =============================================================================



% =============================================================================
% STEP 3: third order discontinuity (parabolic wave)
% =============================================================================




