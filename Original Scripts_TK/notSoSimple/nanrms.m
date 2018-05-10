function e = nanrms(x)
% NANRMS(X) root-mean-square ignoring NaN values
% From https://github.com/jgmalcolm/matlab/blob/master/lib/nanrms.m
  e = sqrt(nanmean(x.^2));