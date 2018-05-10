% This is a record of the relevant steps that produced
% 'find_light_nights_workspace.mat'  The issue was that some nighttime
% period show non-zero PAR

% Load driversDaily for night 1999-2013 using loadoabs and drivers

% Make scatter plot of PAR and doy to find nights with light
scatter(driversDaily(:,3),driversDaily(:,21))

% Select points above 5 or so
[pind,xs,ys] = selectdata('selectionmode','rect'); % requires selectdata.m, in the 'Matlab' folder in documents
lightnight=driversDaily(pind,:);

% run 'daylen_OK_ through line 253, defining dataset1.Day as ordinal

% Make dataset into matrix for indexing
matDS1 = double(dataset1);
tempA=[lightnight(:,1) lightnight(:,3)];
tempB=[matDS1(:,1) matDS1(:,39)];

% Find the start of each year/DOY with the night light  problem
[Lia, Locb] = ismember(tempA,tempB, 'rows'); %Locb gives indices for the first half hour period of a DOY for the year.

% another possible method
% idx = arrayfun(@(x)find(tempB(:,1)==x,1),tempA(:,1));

% There are 48 half hours in each day, so find the end of each day with the
% light problem
locbEnd = Locb+48; %end right before the next day

% Fill out half hour periods between start and end
matIdx = [];
for j = 1:length(Locb)
    wholeday=[Locb(j):1:locbEnd(j)];
    matIdx = [matIdx; wholeday'];
end

% Get rid of duplicate start/stop indices
matIDxU = unique(matIdx);

% Index the dataset
% Note, there seems to be one extra row after each doy that is
% nonconsecutive.  Ignoring for now, since this is just troubleshooting
lightNight48 = matDS1(matIDxU,:);
lightNight48rev = [matDS1(matIDxU,1:7) matDS1(matIDxU,23) matDS1(matIDxU,36)]; % just the relevant columns