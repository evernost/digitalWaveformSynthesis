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



clc
close all



% =============================================================================
% SETTINGS
% =============================================================================
FS = 48000;
F0 = 110;
N_PTS = 10000;
N_PEAKS = 400;

FFT_SIZE = 262144;
N_TRIES = 10;
N_TARGET = 10000;
W_SIZE = 32;
W_SUB_SIZE = 8;



% =============================================================================
% MAIN SCRIPT
% =============================================================================
% Build the Haar matrix
H = genHaar(W_SIZE);

% Generate signal
t = (0:(N_PTS-1))'/FS;
[x, brk] = oscSquare(t, 0.5, F0);
nBrk = length(brk);

% Define steps
step = logspace(0, -6, N_TARGET);

% Calculate peak locations
peaksLoc = zeros(N_PEAKS, 1);
for n = 1:N_PEAKS
  u = (2*n-1)*F0*FFT_SIZE/FS;
  
  while ((u > 131072) || (u < 0))
    if (u > 131072)
      u = 262144 - u;
    end

    if (u < 0)
      u = -u;
    end
  end
  
  peaksLoc(n) = u;
end

eMax = Inf;
n = 0;
while (n < N_TARGET)
  
  xMod = repmat(x, 1, N_TRIES);
 
  % Draw a random transition
  idx = randi([1, nBrk-1]);

  % Draw random wiggles
  %delta = H*step(n+1)*(-1 + 2*rand(W_SIZE, N_TRIES));
  delta = (H.')*[step(n+1)*(-1 + 2*rand(W_SUB_SIZE, N_TRIES)); zeros(W_SIZE-W_SUB_SIZE, N_TRIES)];
  
  % Apply the wiggles to the neighborhood of the selected transition
  a = brk(idx) - W_SIZE/2 + 1;
  b = brk(idx) + W_SIZE/2;
  xMod(a:b, :) = x(a:b, :) + delta;
  
  % Evaluate spectrum
  s = abs(fft(xMod, 262144));
  sHalf = s(1:FFT_SIZE/2, :);

  % Evaluate error
  %sSub = sHalf(60000:end, :);
  subPeakIndex = round(peaksLoc(110:400))+1;
  sHalfAtSubPeaks = sHalf(subPeakIndex, :);
  e = sum(sHalfAtSubPeaks.^2);
  %e = sum(abs(sHalfAtSubPeaks));
  
  [eMin, eMinIndex] = min(e);

  %if eMin < 0.995*eMax
  if eMin < eMax
    %fprintf('[INFO] e = %0.2f\n', e)
    eMax = eMin;
    x = xMod(:,eMinIndex);
    n = n + 1;
    
    %subplot(1,2,1)
    fPlot = (0:((FFT_SIZE/2)-1))';
    plot(fPlot, 20*log10(sHalf(:,eMinIndex)), peaksLoc(110:400), 20*log10(sHalfAtSubPeaks(:,eMinIndex)), 'r+')
    grid minor
    ylim([-80 80])
    title(sprintf('Solution %d/%d', n, N_TARGET))

    %subplot(1,2,2)
    %plot(xMod)
    %xlim([485 515])

    pause(0.00001)
  end

end

