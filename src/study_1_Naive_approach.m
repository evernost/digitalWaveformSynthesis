% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : N/A
% File name     : study_1_Naive_approach.m
% Purpose       : study 1 - the naive approach in synthesis
% Author        : QuBi (nitrogenium@hotmail.com)
% Creation date : Saturday, 11 January 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================

clc
close all
clear all

% =============================================================================
% STEP 1: first order discontinuity (square wave)
% =============================================================================

tSim = 1.0;
fs = 48000;
fftSize = 1024;

nPts = round(tSim*fs);
t = (0:(nPts-1))'/fs;

[s, brk] = oscSquare(t, 0.1, 440);

plot(t,s)
grid minor
