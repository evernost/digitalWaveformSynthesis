% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : N/A
% File name     : study_7_Additive_synthesis_of_step_function.m
% File type     : Matlab script
% Purpose       : TODO
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Sunday, 30 March 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================

% PURPOSE
% Consider a step signal (or any signal with a major discontinuity).
% First step: calculate the theoretical 'perfect' alias-free version of this 
% broken signal (using additive synthesis)
% Then: show an animation of the spectrum as the signal morphs from the
% naive version to this ideal version.


clear all
close all
clc



% =============================================================================
% SETTINGS
% =============================================================================

% Signal properties
FS = 48000;
F0 = 100.1;
N_PER = 10.4;

% FFT analysis settings
FFT_SIZE = 262144;

% Maximum frequency component in the additive synthesis
F_MAX = 3000;

% Number of steps for the morphing
N_STEPS = 500;


% =============================================================================
% SIGNAL GENERATION
% =============================================================================
nPts = round(N_PER*FS/F0);

% Generate signal
t = (0:(nPts-1))'/FS;
[x, brk] = oscStep(t, F0, 0.5, [1, 0.8, 1.2], [-1, -0.8, -1.2]);

%phi = 2*pi*F0*t;
%phi(round(nPts/3):end) = phi(round(nPts/3):end) - 0.5;
%x = sin(phi);



% =============================================================================
% ADDITIVE SYNTHESIS
% =============================================================================
startFreq = F0/10;
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
legend('original', 'reconstructed')
grid minor

s = abs(fft(x, FFT_SIZE));
s = s(1:(FFT_SIZE/2));
plot(20*log10(s))


% =============================================================================
% MORPH
% =============================================================================
lambda = linspace(0, 1, N_STEPS);
figure('units','normalized','outerposition', [0 0 1 1])
for n = 1:N_STEPS

  xM = (1-lambda(n))*x + lambda(n)*xRec;
  
  s = abs(fft(xM, FFT_SIZE));
  s = s(1:(FFT_SIZE/2));
  
  subplot(1,2,1)
  plot(20*log10(s))
  title(sprintf('n = %d', n))
  xlim([0 30000])
  ylim([0 70])

  subplot(1,2,2)
  plot(xM)
  xlim([0 750])
  ylim([-1.2 1.2])

  pause(0.00001)
  
end
