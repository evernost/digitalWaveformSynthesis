% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : spectrumAnalyser
% File name     : spectrumAnalyser.m
% Purpose       : a simple spectrum analyser for stationary signals
% Author        : QuBi (nitrogenium@hotmail.com)
% Creation date : Sunday, 12 January 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================
%
% Description:
% Plots the estimated power spectral density (Welch method)
% The signal will be padded with zeros when the size is not a multiple of
% 'fftSize'.
%
% Arguments:
% - s           [nPts*1]  : input signal
% - fftSize     [1*1]     : size of the FFT
% - overlapSize [1*1]     : 
% - fs          [1*1]     : sampling frequency
%
% Outputs:
% None.
%



function spectrumAnalyser(s, fftSize, hopSize)
  
  nPts = size(s,1);
  nFrm = ceil(1 + ((nPts-fftSize)/hopSize));
  nPad = (fftSize+(nFrm-1)*hopSize) - nPts;
  
  sPad = [s; zeros(nPad,1)];
  sBrk = zeros(fftSize, nFrm);
  for frm = 1:nFrm
    a = 1       + (frm-1)*hopSize;
    b = fftSize + (frm-1)*hopSize;
    sBrk(:,frm) = sPad(a:b).*hann(fftSize);
  end
  
  sFFT = fft(sBrk)/fftSize;
  sp = 20*log10(sum(abs(sFFT(1:fftSize/2,:)), 2)/nFrm);
  semilogx(sp)
  grid minor

end

