% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : N/A
% File name     : study_0_Basics.m
% Purpose       : study 0 - some basics
% Author        : QuBi (nitrogenium@hotmail.com)
% Creation date : Saturday, 11 January 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================

% PURPOSE
% Provide some justifications for DSP basics that will be used throughout
% the scripts.

clc
close all
clear all

% =============================================================================
% ANNEX 1: statistics of each bin in the PSD of a Gaussian white noise
% =============================================================================
% TODO


% dsp = spectrumAnalyser(
% Lindeberg condition
% ...


% =============================================================================
% ANNEX 2: build a calibrated 0dB sinewave with -80 dB noise floor
% =============================================================================

% TODO 
s = sin(2*pi*1000*t) + 0.5*randn(nPts,1);

