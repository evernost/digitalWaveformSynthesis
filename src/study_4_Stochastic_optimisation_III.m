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
step = logspace(-5, -6, N_TARGET);

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


sTmp = abs(fft(x, 262144));
sRef = sTmp(1:FFT_SIZE/2, :);

sHalfAtSubPeaksMin = 1000*ones(091,1);
eMax = Inf;
n = 0;
while (n < N_TARGET)
  
  xMod = repmat(x, 1, N_TRIES);
 
  % Draw a random transition to tweak 
  idx = randi([1, nBrk-1]);

  % Draw random a random wiggle
  delta = (H.')*[step(n+1)*(-1 + 2*rand(W_SUB_SIZE, 1)); zeros(W_SIZE-W_SUB_SIZE, 1)];
  
  % Apply the wiggle to the neighborhood of the selected transition
  a = brk(idx) - W_SIZE/2 + 1;
  b = brk(idx) + W_SIZE/2;
  xMod(a:b, :) = x(a:b, :) + delta;
  
  % Evaluate the new spectrum
  sTmp = abs(fft(xMod, 262144));
  s = sTmp(1:FFT_SIZE/2, :);

  % Evaluate non-aliased spectrum
  peaksUnaliasedIndex = round(peaksLoc(1:109))+1;
  sAtPeaks = s(peaksUnaliasedIndex, :);
  sHalfAtSubPeaksRef = sHalfRef(subPeakIndex, :);
  eRef = max(abs(sHalfAtSubPeaks - repmat(sHalfAtSubPeaksRef, 1, N_TRIES)));
  [~, eRefMinIndex] = min(eRef);

  % Evaluate error
  subPeakIndex = round(peaksLoc(110:200))+1;
  sHalfAtSubPeaks = sHalf(subPeakIndex, eRefMinIndex);
  %e = sum(sHalfAtSubPeaks.^2);
  %e = sum(abs(sHalfAtSubPeaks));
  
  %[eMin, eMinIndex] = min(e);

  %if eMin < 0.995*eMax
  %if eMin < eMax
  if all(sHalfAtSubPeaks < sHalfAtSubPeaksMin)
    %fprintf('[INFO] e = %0.2f\n', e)
    %eMax = eMin;
    sHalfAtSubPeaksMin = sHalfAtSubPeaks;
    x = xMod(:,eRefMinIndex);
    n = n + 1;
    
    %subplot(1,2,1)
    fPlot = (0:((FFT_SIZE/2)-1))';
    plot(fPlot, 20*log10(sHalf(:,eRefMinIndex)), peaksLoc(110:200), 20*log10(sHalfAtSubPeaks(:,1)), 'r+')
    grid minor
    ylim([-80 80])
    title(sprintf('Solution %d/%d', n, N_TARGET))

    %subplot(1,2,2)
    %plot(xMod)
    %xlim([485 515])

    pause(0.00001)
  end

end

