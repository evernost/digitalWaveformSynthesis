% =============================================================================
% Project       : digitalWaveformSynthesis
% Module name   : findRatio
% File name     : findRatio.m
% Purpose       : integer approximation of an irrational period
% Author        : QuBi (nitrogenium@outlook.fr)
% Creation date : Wednesday, 26 March 2025
% -----------------------------------------------------------------------------
% Best viewed with space indentation (2 spaces)
% =============================================================================
%
% DESCRIPTION
% TODO



function [a, b] = findRatio(r, nMax)

  fPart = r - floor(r);
  e = 2;
  for m = 1:nMax
    for n = 1:nMax
      alpha = abs((m/(m+n)) - fPart);
      if (alpha < e)
        e = alpha;
        a = n;
        b = m;
      end
    end
  end

end