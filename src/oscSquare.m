% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : oscSquare
% File name     : oscSquare.m
% Purpose       : study 1 - the naive approach in synthesis
% Author        : QuBi (nitrogenium@hotmail.com)
% Creation date : Saturday, 11 January 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================
%
% Description:
% Generates a 'naive' square wave.
% Output is normalized with 0 mean and unity power.
%
% Arguments:
% - t     [nPts*1]  : time vector
% - duty  [1*1]     : duty cycle ratio, between 0 and 1
% - f     [1*1]     : frequency
% - fs    [1*1]     : sampling frequency
%
% Outputs:
% - s     [nPts*1]  : square wave output
% - brk   [nBrk*1]  : list of indexes where the signal toggles at the next
%                     sample.



function [s, brk] = oscSquare(t, duty, f)

  nPts = size(t,1);
  s = zeros(nPts,1);
  brk = zeros(nPts,1); nBrk = 0;
  n = floor(t*f);
  h = sqrt(1-duty)/sqrt(duty); l = -1/h;
  
  lastState = -1;
  for i = 1:nPts
    if (t(i) < ((n(i) + duty)/f))
      s(i) = h;
      if (lastState == 0)
        nBrk = nBrk + 1;
        brk(nBrk) = i-1;
        lastState = 1;
      else
        lastState = 1;
      end
    else
      s(i) = l;
      if (lastState == 1)
        nBrk = nBrk + 1;
        brk(nBrk) = i-1;
        lastState = 0;
      else
        lastState = 0;
      end
    end
  end

  brk = brk(1:nBrk);

end

