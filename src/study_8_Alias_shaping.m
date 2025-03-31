% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : N/A
% File name     : study_8_Alias_shaping.m
% File type     : Matlab script
% Purpose       : study 8 - try to shape the aliased spectrum
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Monday, 31 March 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================

% PURPOSE
% An attempt to hide the aliased spectrum in the background noise.
% Potiential benefits:
% - aliasing would sound less harsh
% - hopefully easier to implement than trying to completely erase the aliasing


clear all
close all
clc



% =============================================================================
% SETTINGS
% =============================================================================

% Signal properties
FS = 48000;
F0 = 100.1;
N_PER = 1.4;

% FFT analysis settings
FFT_SIZE = 262144;

% Maximum frequency component in the additive synthesis (Hz)
F_MAX = 5000;

% Required number of solutions before stopping the script
N_TARGET = 1000;

FIRST_STEP_SIZE_POW10 = -3;
LAST_STEP_SIZE_POW10 = -6;


% =============================================================================
% SIGNAL GENERATION
% =============================================================================
nPts = round(N_PER*FS/F0);

% Generate a simple rectangular wave
t = (0:(nPts-1))'/FS;
[x, brk] = oscStep(t, F0, 0.1, [1], [-1]);

%phi = 2*pi*F0*t;
%phi(round(nPts/3):end) = phi(round(nPts/3):end) - 0.5;
%x = sin(phi);



% =============================================================================
% ADDITIVE SYNTHESIS
% =============================================================================
startFreq = F0/1;
nTerms = floor(F_MAX/startFreq);
M = zeros(nPts, 2*nTerms);
Msin = sin(2*pi*startFreq*t*(0:(nTerms-1)));
Mcos = cos(2*pi*startFreq*t*(0:(nTerms-1)));

M(:, 1:2:end) = Msin;
M(:, 2:2:end) = Mcos;

% Remove the 'sin' term at null frequency (vector is all 0)
Minv = M(:, 2:end);

s = Minv\x;
s = [0; s];

stem([s(1:2:end), s(2:2:end)])
grid minor

xRec = M*s;

plot(t, [x, xRec])
ylim([-2 2])
legend('original (naive)', 'alias-free')
grid minor

% Calculate the residue
xRes = x - xRec;
plot(t, xRes)
grid minor
title('''De-aliasing'' signal for the rectangular wave (= x-x_{Rec})')

s = abs(fft(xRes, FFT_SIZE));
%s = s(1:(FFT_SIZE/2));
plot(20*log10(s))


% =============================================================================
% TURN THE 'DE-ALIASING' SIGNAL INTO NOISE
% =============================================================================
% Generate the list of step size
step = logspace(FIRST_STEP_SIZE_POW10, LAST_STEP_SIZE_POW10, N_TARGET);

n = 0;
figure('units','normalized','outerposition', [0 0 1 1])
while (n < N_TARGET)

  % Copy the signal
  xMod = xRes;

  % Draw a random wiggle
  delta = step(n+1)*(-1 + 2*rand(nPts, 1));
  
  % Apply a wiggle to the rectifying signal
  xMod = xMod + delta;
  
  % Calculate the new spectrum
  s = abs(fft(xMod, FFT_SIZE));
  s = s(1:(FFT_SIZE/2), :);

  % Calculate peak value
  errNAS = max(s);
  
  % Calculate amplitude deviation in the aliased part of the spectrum (AS)
  errAS = abs(s(peaksIndices(rangeUAS)) - sRef(peaksIndices(rangeUAS)));
  energAS = sum(s(peaksIndices(rangeAS)).^2);

  % Test the criterias
  test1 = max(errNAS) < 0.5;
  test2 = energAS < eMax;
  test3 = sum(xMod.^2) < sigEnerg;
  %test1 = true;
  %test3 = true;
  %fprintf('max errNAS: %0.4f (target: 0.1)\n', max(errNAS));
  %fprintf('max energ: %0.4f (target: %0.4f)\n', sum(xMod.^2), sigEnerg);
  %fprintf('\n');
  
  if (test1 && test2 && test3)
    
    % Store the new aliased energy
    eMax = energAS;
    
    % Store the new solution
    x = xMod;
    n = n + 1;
    
    subplot(1,2,1)
    fPlot = (0:((FFT_SIZE/2)-1))';
    plot(fPlot, 20*log10(s), ...
         peaksFreq(rangeUAS), 20*log10(s(peaksIndices(rangeUAS))), 'r+', ...
         peaksFreq(rangeAS), 20*log10(s(peaksIndices(rangeAS))), 'k+', ...
         peaksFreq(rangeAS), 20*log10(sRef(peaksIndices(rangeAS))), 'b+'...
       )
    grid minor
    %ylim([-60 100])
    ylim([25 60])
    xlim([0.9e5 1.3e5])
    title(sprintf('Solution %d/%d', n, N_TARGET))

    subplot(1,2,2)
    plot(xMod)
    xlim([0 4000])
    ylim([-1.2 1.2])

    pause(0.00001)
  end
  
end
