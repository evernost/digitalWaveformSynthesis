% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : N/A
% File name     : study_3_Stochastic_optimisation_II.m
% File type     : Matlab script
% Purpose       : study 3 - use noise to announce the discontinuity
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Sunday, 23 March 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================

% PURPOSE
% 

clc
close all
clear all


N_HARM = 50;
N_PTS = 10000;
FFT_SIZE = 262144;
FS = 48000;
F0 = 100.6;

%step = logspace(-1, -3, N_TARGET);


% Generate a rectangular wave using additive synthesis
r = 0.5;
osc = ones(N_HARM+1, 1); osc(1:2:end) = -1;
a = zeros(N_HARM+1, 1);
b = zeros(N_HARM+1, 1);
for n = 1:N_HARM
  a(n+1) = -(osc(n+1)/(pi*n))*sin(2*pi*n*r)/sqrt(r*(1-r));
  b(n+1) = -(osc(n+1)/(pi*n))*(1-cos(2*pi*n*r))/sqrt(r*(1-r));
end

t = (0:(N_PTS-1))'/FS;
Msin = sin(2*pi*F0*t*(0:N_HARM));
Mcos = cos(2*pi*F0*t*(0:N_HARM));
x = Mcos*a + Msin*b;

s = abs(fft(x, FFT_SIZE));




[xAlias, brk] = oscSquare(t, r, F0);
xAlias = -xAlias;
sAlias = abs(fft(xAlias, FFT_SIZE));

figure
sPlot = s(1:FFT_SIZE/2);
fPlot = FS*(0:((FFT_SIZE/2)-1))'/FFT_SIZE;
plot(fPlot, [sAlias(1:FFT_SIZE/2), sPlot])
%plot(fPlot, sAlias(1:FFT_SIZE/2)-sPlot)


figure
%plot(t,[x,xAlias])
plot(t,xAlias-x)