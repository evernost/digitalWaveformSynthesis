% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : N/A
% File name     : study_2_Stochastic_optimisation.m
% Purpose       : study 2 - use noise to announce the discontinuity
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Monday, 20 January 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================

% PURPOSE
% Generate a 1Hz square wave using a naive approach.
% Its aliasing part is analysed by oversampling it with an important factor.
% Then, at every transition, N samples before and after are tuned using
% simulated annealing until the aliased components are reduced to a decent
% level.
% The scripts then classifies the transitions depending on their fine 
% location between two samples and shows the seemingly optimal tuning
% expected on the naive sampling to get a decent spectrum.
%
% Next steps:
% - randomise the amplitude in the square wave (= step signal)
% - add a slight slope on the 'steady' part of the square wave, see
%   how it affects the compensation required

clc
close all
clear all


% Oversampling ratio
R = 100;

