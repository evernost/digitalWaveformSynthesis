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



clear all
close all
clc



% =============================================================================
% SETTINGS
% =============================================================================
FS = 48000;
F0 = 301;

N_PTS = 10000;

H_SIZE = 50;

FFT_SIZE = 262144;
N_PEAKS = 140;

N_ITER = 10000;



% =============================================================================
% MAIN SCRIPT
% =============================================================================

% Time vector
t = (0:(N_PTS-1))'/FS;

% Initial impulse response
t_h = (0:(H_SIZE-1))'/H_SIZE;
%h = exp(-6*(0:(H_SIZE-1))'/H_SIZE).*sin(2*pi*1*t_h);
h = exp(-6*(0:(H_SIZE-1))'/H_SIZE);

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


% =============================================================================
% REFERENCE SPECTRUM
% =============================================================================

% Generate signal
x = impulseOsc(N_PTS, F0, FS, h);


s = abs(fft(x,FFT_SIZE));
s = s(1:(FFT_SIZE/2));

sRefAtPeaks = s(round(peakLoc)+1);




% =============================================================================
% TWEAK LOOP
% =============================================================================
zzMax = Inf;
for n = 1:N_ITER

  % Tweak the impulse response
  hNew = h + (1e-1)*(-1 + 2*rand(H_SIZE, 1));

  % Generate signal
  x = impulseOsc(N_PTS, F0, FS, hNew);
  

  s = abs(fft(x,FFT_SIZE));
  s = s(1:(FFT_SIZE/2));

  sAtPeaks = s(round(peakLoc)+1);


  if (max(abs(sAtPeaks(1:80) - sRefAtPeaks(1:80))) < 1) 
    
    zz = sAtPeaks(81:end) - sRefAtPeaks(81:end);
    if (sum(abs(zz)) < zzMax)
    %if 1

      sFreq = (0:((FFT_SIZE/2)-1)).';
      subplot(1,2,1)
      plot(sFreq, 20*log10(s), peakLoc(1:80), 20*log10(sAtPeaks(1:80)), 'r+', peakLoc(1:80), 20*log10(sRefAtPeaks(1:80)), 'k+')
      grid minor
      ylim([-60 70])
      title(sprintf('n = %d', n))
      
      subplot(1,2,2)
      plot(x)
      xlim([1 300])
      ylim([0 1])
  
      pause(0.01)
  
      h = hNew;
      zzMax = sum(abs(zz));
    else
      fprintf('sum = %0.8f, record = %0.8f\n', sum(abs(zz)), zzMax)
    end

    
  end

end











