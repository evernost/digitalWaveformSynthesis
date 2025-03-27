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
% - nPts  [1*1] : output signal size (number of points)
% - f     [1*1] : frequency (Hz)
% - fs    [1*1] : sampling frequency (Hz)
% - fs    [N*1] : impulse response
%
% Outputs:
% - s     [nPts*1]  : output signal




function s = impulseOsc(nPts, f, fs, h)

  hSize = length(h);
  s = zeros(nPts,1);
  
  t = 0;
  n = 0;
  %sizeAmp = length(amp);
  %nAmp = 1;
  while (1)
    %n = ceil(t*fs);

    % Read location in the look-up table (might not be an integer)
    aRead = ceil(t*fs) - (t*fs);
    bRead = floor(aRead + hSize - 1);

    % Write location in the signal (must be an integer)
    aWrite = ceil(t*fs) + 1;
    bWrite = floor(t*fs + hSize - 1) + 1;

    s_h = interp1((0:(hSize-1))', h, (aRead:bRead)');

    nMax = min(bWrite, nPts);
    s(aWrite:nMax) = s(aWrite:nMax) + s_h(1:(nMax-aWrite+1));

    t = t + (1/f);

    if (bWrite >= nPts)
      return
    end

    % if (nAmp == sizeAmp)
      % nAmp = 1;
    % else
      % nAmp = nAmp + 1;
    % end
  end
end

