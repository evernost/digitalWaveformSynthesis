% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : genericRectWave
% File name     : genericRectWave.m
% Purpose       : monitored rectangular wave generator
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Friday, 21 March 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================
%
% Description:
% Rectangular wave (not suited for audio generation) with trackers to help 
% investigate bandlimiting countermeasures.
%
% Arguments:
% - nPts        [1*1]       : size of the signal to be generated (number of points)
% - period      [1*1]       : size of the period (number of points, eventually fractionnal)
% - dutyRatio   [1*1]       : duty cycle ratio (between 0 and 1)
% - highLevels  [nLevels*1] : list of possible values for the 'high' state
% - lowLevels   [nLevels*1] : list of possible values for the 'low' state
% - highSlopes  [nSlopes*1] : list of possible values for slope during the 'high' state
% - lowSlopes   [nSlopes*1] : list of possible values for slope during the 'low' state
%
% Outputs:
% - s     [nPts*1]  : signal output
% - brk   [nBrk*1]  : list of indexes where the signal toggles at the next
%                     sample.
%


function [s, brk, brkFine] = genericRectWave(nPts, period, dutyRatio, highLevels, lowLevels, highSlopes, lowSlopes)
  
  s = zeros(nPts,1);
  brk = []; brkFine = []; brkCount = 0; brkLast = 0;
  
  state = -1;
  t = 0;
  while (t < (nPts-1))
    
    if (state == -1)
      t = t + (dutyRatio*period);  
      s((brkLast+1):floor(t)) = -1;
      state = 1;
    elseif (state == 1)
      t = t + ((1.0-dutyRatio)*period);
      s((brkLast+1):floor(t)) = 1;
      state = -1;
    end
  
    %fprintf('[INFO] Populating from %d to %d\n', brkLast+1, floor(t))

    brk = [brk; floor(t)];
    brkLast = floor(t);
    brkFine = [brkFine; t-floor(t)];
    brkCount = brkCount + 1;
  end
end