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
N_TRIES = 100000;
N_TARGET = 1000;
W_SIZE = 20;

step = logspace(-1, -4, N_TARGET);



[x, brk, brkFine] = genericRectWave(10000, 1000.1, 0.5);
nBrk = length(brk);

eMax = Inf;
delta = zeros(2*W_SIZE+1, 5);
n = 0;
while (n < N_TARGET)
  
  xMod = x;
  delta = step(n+1)*(-1 + 2*rand(2*W_SIZE+1, 5));
  for b = 1:nBrk-1
    if (brkFine(b) < 0.2)
      xMod((brk(b)-W_SIZE):(brk(b)+W_SIZE)) = x((brk(b)-W_SIZE):(brk(b)+W_SIZE)) + delta(:,1);
    
    elseif (brkFine(b) >= 0.2) && (brkFine(b) < 0.4)
      xMod((brk(b)-W_SIZE):(brk(b)+W_SIZE)) = x((brk(b)-W_SIZE):(brk(b)+W_SIZE)) + delta(:,2);
    
    elseif (brkFine(b) >= 0.4) && (brkFine(b) < 0.6)
      xMod((brk(b)-W_SIZE):(brk(b)+W_SIZE)) = x((brk(b)-W_SIZE):(brk(b)+W_SIZE)) + delta(:,3);
      
    elseif (brkFine(b) >= 0.6) && (brkFine(b) < 0.8)
      xMod((brk(b)-W_SIZE):(brk(b)+W_SIZE)) = x((brk(b)-W_SIZE):(brk(b)+W_SIZE)) + delta(:,4);
      
    else
      xMod((brk(b)-W_SIZE):(brk(b)+W_SIZE)) = x((brk(b)-W_SIZE):(brk(b)+W_SIZE)) + delta(:,5);
    end
  end
  
  % Evaluate spectrum
  %s = 20*log10(abs(fft(x, 262144)));
  s = abs(fft(xMod, 262144));
  sHalf = s(1:FFT_SIZE/2);

  % Investigate peaks
  % sBefore = sHalf(1:(end-2));
  % sMiddle = sHalf(2:(end-1));
  % sAfter  = sHalf(3:end);
  % sTest = ((sMiddle > sBefore) & (sMiddle > sAfter));
  % peakLoc = find(sTest)+1;
  % peakVal = sHalf(peakLoc);

  % [B, I] = sort(peakVal, 'descend');

  %e = sum(sHalf(59627:524:end));
  met = sHalf(60000:end);
  %e = sum(met.^2);
  e = max(met);
  if (e < eMax)
    fprintf('[INFO] e = %0.2f\n', e)
    eMax = e;
    x = xMod;
    n = n + 1;
    
    %subplot(1,2,1)
    plot(20*log10(sHalf))
    grid minor
    ylim([-80 80])

    %subplot(1,2,2)
    %plot(xMod)
    %xlim([485 515])

    pause(0.001)
  end

end

