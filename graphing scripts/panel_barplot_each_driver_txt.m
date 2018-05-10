% This creates a panel barplot using subplot. Needs to be finished.

% This version relies on matrices output from
% GenerateWorkspaceDerivedTables.m
%
% Soil moisture row needs to be added manually to the tab-delimited txt
% files for 'no soil moisture' files that are output from GenerateWorkspaceDerivedTAbles. 
% This has been done for the .txt files in the 'Edited for
% barplots' folder that this script draws from.
%
%
% Note that this script can also be used to make barplots for best+one
% results (secondary drivers) also, but they have the same format as the
% primary tables.  To run with secondary, the secondary results would need
% to be added to the directory that this runs on.
%
% Note also that if using this for best plus one results....
% The primary driver for the 'snowmelt' period for ETdaytime and NEPdaytime
% was soil moisture.  Thus, the column from the scenarios 'with soil moisture'
% needs to be added to the txt files for w/o soil moisture. 

% Resources:
% https://www.mathworks.com/matlabcentral/answers/84163-getting-handle-for-subplot-of-saved-figure


%% Prepare to loop through files

clear all
close all

% Load matrix with r2 values
filepath = '/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/Workspace-derived Tables/Edited for barplots';

% Create list of names
txtFiles = dir(fullfile(filepath,'*.txt'));

% Create a vector of driver names for the first bar plot
YTL_primary={'Air temp. (\circC)','Wind speed (m s^-^1)',...
    'Wind dir. (degrees)', 'u_* (m s^-^1)', 'Precip (mm)',...
    'VPD (kPa)', 'Soil temp. (\circC)', 'PAR (\mumol m^-^2 s^-^1)',...
    'Net rad. (W m^-^2)', 'Rel. Humidity 8m', 'Soil moist. (m^3 m^-^3)',...
    'SWE (mm)'};

        
% Change to directory where graphs will be saved
cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs')


%% Loop through each file

% Initialize
pos = [];

for k = 1:numel(txtFiles)
    % Open file
    resultsMat = importdata(strcat(filepath,'/',txtFiles(k).name));
    
    % Make index for r2 columns (order is r2, model sigma, RMSE for each
    % period)
    r2_ind = [1,4,7,10,13,16]; %This is for seasonal indices; 5 seasons + 1 for all data;
    
    % Pull out the r2 results from resultsMat
    r2_var=resultsMat(:,r2_ind);
    
    % Create figure that subplots will be added to
    figureBP = figure();
    
    % loop through each column of r2 results
    for j = 1:size(r2_var,2)
        % benchmark r2 is first row
        r2_bench = r2_var(1,j);
        
        % Probably not going to do this afterall since I don't re-order the
        % column tables either.
        % % Create order and re-arrange (so similar variables near each other for plot)
        % BP_ind = [4 2 3 5 7 1 8 9 10 6 12 11];
        % r2_var_ord = r2_var(BP_ind); %if nothing needs to be added
        % YTL_primary_ord = YTL_primary(BP_ind);
        
        %YTL_primary_ord = YTL_primary;
        
        % Create subplot
        BPh = subplot(1,6,j);
        
        % Flip r2_var so that it matches top to bottom order of table
        %r2_var_plot = flipud(r2_var(2:end,j)); % this works, but then Y tick labels are off... not sure of Matlab's logic here
        r2_var_plot = r2_var(2:end,j); % start at row 2 since row 1 is benchmark
        
        % Add vertical barplot
        barh(r2_var_plot, 'FaceColor',[0.4 0.4 0.4]);
        
        % Define limits of barplot
        % CHECK: SHOULD THIS NOT BE PLUS 1? AIR T REPEATED TWICE??
        %ylim([0 length(r2_var)]) %This is one longer than the number of drivers, 
        % but that helps things fit, and is taken into account in
        % YTL_primary
        xlim([0 1])
        
        % plot the best we can expect from the benchmark
        l1=line([r2_bench;r2_bench], [0;length(r2_var)+1]);
        set(l1,'LineStyle','--','color','k')
        
        % Set the Y-tick labels depending upon if it is the first subplot
        if j== 1
            % Set the Y tick labels with the driver names (optional, best for first
            % plot only)
            set(BPh,'YTickLabel',YTL_primary,... %'fontsize',8, %does changing fontsize here also affect the xtick fontsize for some reason?
                'YTick',1:length(r2_var_plot));
        else 
            % Alternatively, leave off y tick labels of drivers
            set(BPh,'YTickLabel',YTL_primary, 'YTick', []);
        end
        
        % Settings for all plots
%         set(BPh, 'XTick', [], 'TickDir','out', 'box','off');
        set(BPh, 'TickDir','out', 'box','off');

        
        % Set the X axis label to the appropriate season
        xlabel('r^2')
        
        % Set title
        if j == 1
            period = 'Winter';
        elseif j == 2
            period = 'Snowmelt';
        elseif j == 3
            period = 'Pre-monsoon';
        elseif j ==4
            period = 'Monsoon';
        elseif j ==5
            period = 'Post-monsoon';
        elseif j ==6
            period = 'All';
        end
        title(period,'fontSize',9.5)
        
%         % Resize (decided to move this down... can remove here)
%         figBPpos = get(figureBP,'Position');
%         %width = 8.4*2;      % one column in Oecologia is 84 mm
%         width = 20;
%         height = 23.4/2;      % max height Oecologia permits is 234 mm and I will stack these plots
%         set(figureBP,'units','centimeters','position',[0 0 width height])
        
        
        % Define the current subplot positions
        pos(j,:) = get( BPh, 'Position' );

    end
    
    %% Final figure edits
    
    % Get rid of empty space between subplots
    % define y coordinate of each subplot before running tightfig
        origY = linspace(pos(1,1),pos(6,1),6); % current evenly spaced lower corner 'y' positions
        newY = linspace(pos(1,1),(pos(6,1)-.11),6); % add value to bottom plot corner and calculate even spacing
        % Assign new y values to matrix of all positions
        pos(:,1) = newY;

        set( subplot(1,6,1), 'Position', pos(1,:)); %For some reason this
        %shifts the leftmost panel even though it shouldn't... but tightfig
        %fixes that
        set( subplot(1,6,2), 'Position', pos(2,:));
        set( subplot(1,6,3), 'Position', pos(3,:));
        set( subplot(1,6,4), 'Position', pos(4,:));
        set( subplot(1,6,5), 'Position', pos(5,:));
        set( subplot(1,6,6), 'Position', pos(6,:));
        
        
%         % Make leftmost panel same width as others if subplot(1,6,1) not
%         set? Not working yet...
%         pos1 = get( subplot(1,6,2), 'Position');
%         pos1(3) = pos(2,3);
%         set( subplot(1,6,1), 'Position', pos1);
        

    % Get rid of empty margins
    addpath('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/tightfig')
    tightfig(figureBP)
    
    % Resize
    figBPpos = get(figureBP,'Position');
    width = 8.4*2;      % one column in Oecologia is 84 mm
    height = 23.4/2;      % max height Oecologia permits is 234 mm and I will stack these plots
    set(figureBP,'units','centimeters','position',[0 0 width height])
    
    % Export figure
    
    %could remove '.txt' before saving
    fig_name = strcat(txtFiles(k).name,'.fig');
    savefig(figureBP,fig_name)
end