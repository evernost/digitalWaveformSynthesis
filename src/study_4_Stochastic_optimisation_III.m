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

% Signal properties
FS = 48000;
F0 = 101;
N_PTS = 50000;

% Haar basis settings
W_SIZE = 32;
W_SUB_SIZE = 8;

% FFT analysis settings
FFT_SIZE = 262144;

% Number of spectral peaks considered for the iteration
N_PEAKS = 200;

% Required number of solutions before stopping the script
N_TARGET = 10000;



% =============================================================================
% PRELIMINARY VARIABLES
% =============================================================================
% Generate the Haar matrix
H = genHaar(W_SIZE);

% Generate signal
t = (0:(N_PTS-1))'/FS;
[x, brk] = oscSquare(t, 0.5, F0);
nBrk = length(brk);

% Generate the list of step size
step = logspace(-7, -8, N_TARGET);

% Generate the list of expected peak location
peaksFreq = zeros(N_PEAKS, 1);
firstAlias = true;
nAlias = -1;
for n = 1:N_PEAKS
  u = (2*n-1)*F0*FFT_SIZE/FS;
  
  while ((u > ((FFT_SIZE/2)-1)) || (u < 0))
    if (u > ((FFT_SIZE/2)-1))
      if firstAlias
        fprintf('[INFO] First aliased peak at index %d.\n', n);
        firstAlias = false;
        nAlias = n;
      end
      u = FFT_SIZE-2 - u;
    end

    if (u < 0)
      u = -u;
    end
  end
  peaksFreq(n) = u;
end
peaksIndices = round(peaksFreq)+1;

if (nAlias == -1)
  error('[ERROR] INVALID SETTING: please set ''N_PEAKS'' to a large enough value to capture spectral peaks in the aliased domain.')
end

% Generate the reference spectrum
s = abs(fft(x, FFT_SIZE));
sRef = s(1:(FFT_SIZE/2), :);

% Calculate the energy reference
sigEnerg = sum(x.^2);

rangeUAS = 1:nAlias;
rangeAS = (nAlias+1):N_PEAKS;



% =============================================================================
% ITERATIVE CONSTRUCTION
% =============================================================================
eMax = Inf;
n = 0;
figure('units','normalized','outerposition',[0 0 1 1])
while (n < N_TARGET)

  % Copy the signal
  xMod = x;

  % Draw a random wiggle
  delta = (H.')*[step(n+1)*(-1 + 2*rand(W_SUB_SIZE, 1)); zeros(W_SIZE-W_SUB_SIZE, 1)];
  
  % Draw a random transition
  idx = randi([1, nBrk-1]);

  % Apply the wiggle to the neighborhood of the transition
  a = brk(idx) - W_SIZE/2 + 1;
  b = brk(idx) + W_SIZE/2;
  xMod(a:b) = x(a:b) + delta;
  
  % Calculate the new spectrum
  s = abs(fft(xMod, FFT_SIZE));
  s = s(1:(FFT_SIZE/2), :);

  % Calculate amplitude deviation in the non-aliased part of the spectrum (NAS)
  errNAS = abs(s(peaksIndices(rangeUAS)) - sRef(peaksIndices(rangeUAS)));
  
  % Calculate amplitude deviation in the aliased part of the spectrum (AS)
  errAS = abs(s(peaksIndices(rangeUAS)) - sRef(peaksIndices(rangeUAS)));
  
  % Test the criterias
  test1 = max(errNAS) < 1e-3;
  test2 = sum(errAS.^2) < eMax;
  test3 = sum(xMod.^2) < sigEnerg;
  test1 = true;
  %test3 = true;
  
  if (test1 && test2 && test3)
    
    % Store the new aliased energy
    eMax = sum(errAS.^2);
    %fprintf('[INFO] e = %0.2f\n', e)
    
    % Store the new solution
    x = xMod;
    n = n + 1;
    
    subplot(1,2,1)
    fPlot = (0:((FFT_SIZE/2)-1))';
    plot(fPlot, 20*log10(s), peaksFreq(rangeUAS), 20*log10(s(peaksIndices(rangeUAS))), 'r+', peaksFreq(rangeAS), 20*log10(s(peaksIndices(rangeAS))), 'k+')
    grid minor
    ylim([-60 100])
    title(sprintf('Solution %d/%d', n, N_TARGET))

    subplot(1,2,2)
    plot(xMod)
    xlim([0 4000])
    ylim([-1.2 1.2])

    pause(0.00001)
  end

end

