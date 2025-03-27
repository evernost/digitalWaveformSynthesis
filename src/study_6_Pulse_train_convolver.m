% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : N/A
% File name     : study_6_Pulse_train_convolver.m
% File type     : Matlab script
% Purpose       : attach an impulse response to a train of pulses
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Sunday, 23 March 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================

% PURPOSE
% Extend the idea of rectangular wave generation for a deeper study on the 
% aliasing issues.
%
% This scripts generates a signal that plays an impulse response at every
% period, then it is time sampled. 
% Like rectangular waves, time sampling will cause aliasing.
%
% The goal of the study is to see if some impulse response minimise the aliasing
% components.
% 
% Any interesting result observed here will have direct consequences on the 
% study on polynomial recursions.

clc
close all



% =============================================================================
% SETTINGS
% =============================================================================
FS = 48000;
F0 = 301;

N_PTS = 10000;

H_SIZE = 200;

FFT_SIZE = 262144;
N_PEAKS = 140;



% =============================================================================
% MAIN SCRIPT
% =============================================================================

% Time vector
t = (0:(N_PTS-1))'/FS;

% Initial impulse response
t_h = (0:(H_SIZE-1))'/H_SIZE;
h = exp(-6*(0:(H_SIZE-1))'/H_SIZE).*sin(2*pi*8*t_h);

% Determine location of the spectral peaks
peakLoc = zeros(N_PEAKS, 1);
firstAlias = true;
for n = 1:N_PEAKS
  u = n*F0*FFT_SIZE/FS;
  
  while ((u > ((FFT_SIZE/2)-1)) || (u < 0))
    if (u > ((FFT_SIZE/2)-1))
      if firstAlias
        fprintf('[INFO] First aliased peak at index %d\n', n);
        firstAlias = false;
      end
      u = FFT_SIZE-2 - u;
    end

    if (u < 0)
      u = -u;
    end
  end
  peakLoc(n) = u;
end

% Generate signal
x = impulseOsc(N_PTS, F0, FS, h);
plot(x)
grid minor



s = abs(fft(x,FFT_SIZE));
s = s(1:(FFT_SIZE/2));

sAtPeak = s(round(peakLoc)+1);

figure
sFreq = (0:((FFT_SIZE/2)-1)).';
plot(sFreq, 20*log10(s), peakLoc, 20*log10(sAtPeak), 'r+')
grid minor








