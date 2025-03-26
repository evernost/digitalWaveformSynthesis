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
% Oscillator based on an impulse response positioned at every period.
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



function s = impulseOsc(nPts, f, fs, h, amp)

  hSize = length(h);
  s = zeros(nPts,1);
  
  t = 0;
  n = 0;
  sizeAmp = length(amp);
  nAmp = 1;
  while (n < nPts)
    n = ceil(t*fs);

    % Read location in the look-up table (might not be an integer)
    aRead = ceil(t*fs) - (t*fs);
    bRead = floor(aRead + hSize - 1);

    % Write location in the signal (must be an integer)
    aWrite = ceil(t*fs) + 1;
    bWrite = floor(t*fs + hSize - 1) + 1;

    s_h = amp(nAmp)*interp1((0:(hSize-1))', h, (aRead:bRead)');

    nMax = min(bWrite, nPts);
    s(aWrite:nMax) = s(aWrite:nMax) + s_h(1:(nMax-aWrite+1));

    t = t + (1/f);

    if (nAmp == sizeAmp)
      nAmp = 1;
    else
      nAmp = nAmp + 1;
    end
  end
end

