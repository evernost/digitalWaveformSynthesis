% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : N/A
% File name     : study_4_Stochastic_optimisation_III.m
% Purpose       : study 4 - use noise to announce the discontinuity
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Sunday, 20 January 2025
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
N_PTS = 10000;

FFT_SIZE = 262144;
N_TRIES = 10;
N_TARGET = 1000;
W_SIZE = 64;
W_SUB_SIZE = 16;



% =============================================================================
% MAIN CODE
% =============================================================================
% Build the Haar matrix
% H = zeros(16);
% H(:,1)  = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
% H(:,2)  = [1; 1; 1; 1; 1; 1; 1; 1;-1;-1;-1;-1;-1;-1;-1;-1];
% H(:,3)  = [1; 1; 1; 1;-1;-1;-1;-1; 0; 0; 0; 0; 0; 0; 0; 0];
% H(:,4)  = [0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1; 1;-1;-1;-1;-1];
% H(:,5)  = [1; 1;-1;-1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
% H(:,6)  = [0; 0; 0; 0; 1; 1;-1;-1; 0; 0; 0; 0; 0; 0; 0; 0];
% H(:,7)  = [0; 0; 0; 0; 0; 0; 0; 0; 1; 1;-1;-1; 0; 0; 0; 0];
% H(:,8)  = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 1;-1;-1];
% H(:,9)  = [1;-1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
% H(:,10) = [0; 0; 1;-1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
% H(:,11) = [0; 0; 0; 0; 1;-1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
% H(:,12) = [0; 0; 0; 0; 0; 0; 1;-1; 0; 0; 0; 0; 0; 0; 0; 0];
% H(:,13) = [0; 0; 0; 0; 0; 0; 0; 0; 1;-1; 0; 0; 0; 0; 0; 0];
% H(:,14) = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1;-1; 0; 0; 0; 0];
% H(:,15) = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1;-1; 0; 0];
% H(:,16) = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1;-1];
H = genHaar(W_SIZE);

step = logspace(0.2, -3, N_TARGET);

t = (0:(N_PTS-1))'/FS;
[x, brk] = oscSquare(t, 0.5, 110);
nBrk = length(brk);

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
  % TODO: target the aliased harmonics specifically
  sSub = sHalf(60000:end, :);
  %e = sum(abs(sSub), 1);
  e = sum(sSub.^2, 1);
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

