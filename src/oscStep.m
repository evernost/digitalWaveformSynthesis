% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : oscStep
% File name     : oscStep.m
% Purpose       : step wave generator
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Saturday, 29 March 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================
%
% Description:
% TODO
%
% Arguments:
% - t     [nPts*1]  : time vector
% - duty  [1*1]     : duty cycle ratio, between 0 and 1
% - f     [1*1]     : frequency (Hz)
%
% Outputs:
% - x     [nPts*1]  : square wave output
% - brk   [nBrk*1]  : list of indexes where the signal toggles at the next
%                     sample.
%



function [x, brk] = oscStep(t, f, duty, highVal, lowVal)
  
  nPts = size(t,1);

  x = zeros(nPts,1);
  brk = zeros(nPts,1); nBrk = 0;
  
  % 'getCycleCount(i)' returns the cycle count at time t = t(i)
  getCycleCount = floor(t*f);

  state = 0; nextState = 0;
  for i = 1:nPts
    
    % -------------------------------------------------------------------------
    % LOW STATE
    % -------------------------------------------------------------------------
    if (t(i) < ((getCycleCount(i) + duty)/f))
      if (state ~= -1)
        l = lowVal(randi([1 length(lowVal)]));
        nBrk = nBrk + 1;
        brk(nBrk) = i-1;
        nextState = -1;
      end
    
      x(i) = l;
      
    % -------------------------------------------------------------------------
    % HIGH STATE
    % -------------------------------------------------------------------------
    else
      if (state ~= 1)
        h = highVal(randi([1 length(highVal)]));
        nBrk = nBrk + 1;
        brk(nBrk) = i-1;
        nextState = 1;
      end
      
      x(i) = h;
    end
    
    state = nextState;
  end

  brk = brk(1:nBrk);

end

