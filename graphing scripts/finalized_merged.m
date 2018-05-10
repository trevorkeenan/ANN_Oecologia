% This script was an attempt to create panels using .fig files.  This was
% for response curves.  It was tricky to get the proper 'children' for the
% main figure and inset axes, so ultimately I took a different approach.

close all

% Set directory for import
fig_dir = '/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/period colors/with insets';

cd(fig_dir)

test1 = 'AllDayT.fig';
test2 = 'AllNightT.fig';

% open figure for top
h1 = openfig(test1,'reuse'); 
inset1 = gca; % get handle to axes of figure (inset only)
ax1 = findobj(gcf,'type','axes');

% open figure for bottom
h2 = openfig(test2,'reuse');
inset2 = gca;
ax2 = findobj(gcf,'type','axes');


% test1.fig and test2.fig are the names of the figure files which you would % like to copy into multiple subplots
h3 = figure; %create new figure
s1 = subplot(2,1,1); %create and get handle to the subplot axes
s2 = subplot(2,1,2);


%get handle to all the children in the figure
% The first axes in ax1 or ax1 is the inset; the second is the main fig
fig1 = get(ax1(2),'children'); 
fig2 = get(ax2(2),'children');
copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);



% Define top 'main' figure

% Get position of top figure inset

% Define bottom 'main' figure

% Get position of bottom figure inset

