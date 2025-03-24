% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : impulseOsc
% File name     : impulseOsc.m
% Purpose       : oscillator based on customisable impulses
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Monday, 24 March 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================
%
% DESCRIPTION
% Generates the equivalent of 
%
% Arguments:
% - t     [nPts*1]  : time vector
% - duty  [1*1]     : duty cycle ratio, between 0 and 1
% - f     [1*1]     : frequency
%
% Outputs:
% - s     [nPts*1]  : square wave output
% - brk   [nBrk*1]  : list of indexes where the signal toggles at the next
%                     sample.



function s = impulseOsc(f, fs, h)

  nPts = size(t,1);
  s = zeros(nPts,1);
  
  t = 0;
  n = 0;
  while (n < nPts)
    n = ceil(t*fs);

    aRead = ceil(t*fs) - (t*fs);
    bRead = ceil(t*fs) - (t*fs) + size(h) - 1;

    aWrite = n;
    bWrite = min(n + size(h), nPts);

    t = t + (1/f);
  end
  
  
end

