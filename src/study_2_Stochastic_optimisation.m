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

FFT_SIZE = 262144;
N_TRIES = 10;
N_TARGET = 1000;
W_SIZE = 20;

step = logspace(-1, -3, N_TARGET);

[x, brk, brkFine] = genericRectWave(10000, 1000.1, 0.5);
nBrk = length(brk);

eMax = Inf;
n = 0;
while (n < N_TARGET)
  
  xMod = repmat(x, 1, N_TRIES);
 
  % Draw a random transition
  idx = randi([1,nBrk-1]);

  % Draw random wiggles
  delta = step(n+1)*(-1 + 2*rand(2*W_SIZE+1, N_TRIES));
  
  % Apply the wiggles to the neighborhood of the selected transition
  a = brk(idx) - W_SIZE;
  b = brk(idx) + W_SIZE;
  xMod(a:b, :) = x(a:b, :) + delta;
  
  % Evaluate spectrum
  s = abs(fft(xMod, 262144));
  sHalf = s(1:FFT_SIZE/2, :);

  % Evaluate error
  % TODO: target the aliased harmonics specifically
  sSub = sHalf(60000:end, :);
  e = sum(abs(sSub), 1);
  [eMin, eMinIndex] = min(e);

  if eMin < eMax
    %fprintf('[INFO] e = %0.2f\n', e)
    eMax = eMin;
    x = xMod(:,eMinIndex);
    n = n + 1;
    
    %subplot(1,2,1)
    plot(20*log10(sHalf(:,eMinIndex)))
    grid minor
    ylim([-80 80])
    title(sprintf('Solution %d/%d', n, N_TARGET))

    %subplot(1,2,2)
    %plot(xMod)
    %xlim([485 515])

    pause(0.00001)
  end

end

