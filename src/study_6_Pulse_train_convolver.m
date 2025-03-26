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
% TODO!

clc
close all



% =============================================================================
% SETTINGS
% =============================================================================
FS = 48000;
F0 = 110;

N_PTS = 10000;

H_SIZE = 200;

FFT_SIZE = 262144;

ORBIT_SIZE = 1;


% =============================================================================
% MAIN SCRIPT
% =============================================================================

% Pick random period
orbit = ones(ORBIT_SIZE, 1);
while mean(orbit) > 0.01
  orbit = -1 + 2*rand(ORBIT_SIZE, 1);
end

% Time vector
t = (0:(N_PTS-1))'/FS;

% Impulse response
t_h = (0:(H_SIZE-1))'/H_SIZE;
h = exp(-6*(0:(H_SIZE-1))'/H_SIZE).*sin(2*pi*2*t_h);
%plot((0:(H_SIZE-1))', h)

x = impulseOsc(N_PTS, F0, FS, h, orbit);
plot(x)
grid minor


s = abs(fft(x,FFT_SIZE));
s = s(1:(FFT_SIZE/2));

figure
plot(20*log10(s))



