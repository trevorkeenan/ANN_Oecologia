% This script creates a scatterplot matrix of niwot daytime or nighttime
% drivers.
% 
% To do:
% 1) Open the workspace (daytime or nighttime drivers from all consecutive year
% runs) or use directory with 'load' below. 
%
% 2) Note that code should be checked if used on a subset of data
% (especially check if 'subDriversMonths' is the right subset to use)
% 
% 3) Then run this script and save.
%
% To fix:
% 1) Consider adding water flux-filtered version of scatterplot matrix 
% since it might have slightly different data coverage
% (although it will probably be very very similar to NEP-filtered versions)
% see notes about water vapor flux below
% 
% 2) Consider adding correlation coefficient above or below diagonal
%
% 3) Consider running 'tightfig.m' to see if it will reduce buffer around
% margins and make plot bigger.--DONE
%
% 4) Maybe remove PAR and net radiation from nighttime plot since those
% aren't used as drivers.--DONE
%
% Resources:
% https://www.mathworks.com/matlabcentral/newsreader/view_thread/275628
% https://www.mathworks.com/help/matlab/ref/xlim.html#bularnx-1
% http://stackoverflow.com/questions/20432415/how-to-plot-a-regression-line-in-each-of-the-subplots-of-a-plotmatrix-in-matlab
% https://www.mathworks.com/matlabcentral/answers/246992-make-all-elements-of-given-row-numbers-equal-to-nan
% https://www.mathworks.com/matlabcentral/fileexchange/10253-mcorr
% http://stackoverflow.com/questions/32726239/get-current-figure-size-in-matlab

%% Open Matlab workspace
load('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/Eco Pheno Workspaces/NEE Without soil moisture/workspacesDay_w_SWE_no_S-H2O_1999_2013/all_day_ workspace')
%load('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/Eco Pheno Workspaces/NEE Without soil moisture/workspacesNight_w_SWE_no_S-H20_1999_2013/all_night_ workspace')

%% Prepare data

%%% This probably isn't needed.  I originally was going to filter out all
%%% nan rows in based on nan in any driver column, but decided that this
%%% would filter out driver data that would be used with single input drivers

% % Only use info columns and columns used as drivers
% mat_drive1 = [1:5,6,9,10,11,13,15,17,21,23,31,32,34];
% mat_drive2 = [1:5,6,9,10,11,13,15,17,21,23,31,34];
% driversDaily_used = driversDaily(:,mat_drive1);
% driversDaily_used_no_soilH2O = driversDaily(:,mat_drive2);
% 
% % Prepare for filter. Make version of the drivers for 1999-2013 (no soil water version) and
% % 2002-2013 (with soil water version). Otherwise all rows 1999-2001 would
% % be excluded in next step.
% driversDaily_post1999Ind = find(driversDaily_used_no_soilH2O(:,1)>1998);
% driversDaily_post1999 = driversDaily_used_no_soilH2O(driversDaily_post1999Ind,:);
% driversDaily_post2002Ind = find(driversDaily_used(:,1)>2002);
% driversDaily_post2002 = driversDaily_used(driversDaily_post2002Ind,:);
% 
% % Since ANNs should only run on rows where all input and target columns are
% % present (complete tuples), it makes sense to filter by presence of other 
% % drivers and presence of target data.
% % without soil moisture
% driversDaily_post1999_filter1 = driversDaily_post1999;
% is_nan_row = any( isnan( driversDaily_post1999 ), 2 );
% driversDaily_post1999_filter1(is_nan_row, : ) = nan;
% % Include soil moisture in this filter
% driversDaily_post2002_filter1 = driversDaily_post2002;
% is_nan_row = any( isnan( driversDaily_post2002 ), 2);
% driversDaily_post2002_filter1(is_nan_row, : ) = nan;
% % Test that driver filter was applied. There were no missing precip before.
% sum(isnan(driversDaily_post1999(:,10)))
% sum(isnan(driversDaily_post1999_filter1(:,10)))

% Since ANNs should only run on rows where all input and target columns are
% present (complete tuples), it makes sense to filter by presence of target data
if HD == 2
    % Filtered by daytime NEE target
    driversDaily_target_filter_NEE_DAY_Ind = find(~isnan(subDataMonths(:,7)));
    driversDaily_target_filter_NEE_DAY = subDriversMonths(driversDaily_target_filter_NEE_DAY_Ind,:);
    driversDaily_target_filter_H2O_DAY_Ind = find(~isnan(subDataMonths(:,13)));
    driversDaily_target_filter_NEE_DAY = subDriversMonths(driversDaily_target_filter_H2O_DAY_Ind,:);
elseif HD == 1
    % Filtered by nighttime NEE target
    driversDaily_target_filter_NEE_NIGHT_Ind = find(~isnan(subDataMonths(:,6)));
    driversDaily_target_filter_NEE_NIGHT = subDriversMonths(driversDaily_target_filter_NEE_NIGHT_Ind,:);
    driversDaily_target_filter_H2O_NIGHT_Ind = find(~isnan(subDataMonths(:,19)));
    driversDaily_target_filter_H2O_NIGHT = subDriversMonths(driversDaily_target_filter_H2O_NIGHT_Ind,:);
    % Check that NEE target filter removed low ustar values at night
    min(driversDaily_target_filter_NEE_NIGHT(:,11)); % Gives 0.1736 for 2015 data version and the earlier version
    min(driversDaily_target_filter_H2O_NIGHT(:,11)); % Gives 0.1736 for 2015 data version (didn't check earlier version)
end



% Does this filter need to be done for water vapor flux separately? The
% water flux data presence might be a little different from the NEE flux
% data presence...
missingNEEDay = sum(isnan(subDataMonths(:,7)));
missingNEENight = sum(isnan(subDataMonths(:,6)));
missingH2ODay = sum(isnan(subDataMonths(:,13)));
missingH2ONight = sum(isnan(subDataMonths(:,19)));

% Make labels
if HD == 2
    data_labels = {'Air T. (\circC)','Wind sp. (m s^-^1)',...
        'Wind dir. (degrees)','u_* (m s^-^1)','Precip. (mm)',...
        'VPD (kPa)', 'Soil T. (\circC)', 'PAR (\mumol m^-^2 s^-^1)',...
        'Net rad. (W m^-^2)', 'RH (%)', 'Soil H_2O. (m^3 m^-^3)',...
        'SWE (mm)'};
    % columns that correspond to the labels
    mat_dri = [6,9,10,11,13,15,17,21,23,31,32,34];
elseif HD == 1
    data_labels = {'Air T. (\circC)','Wind sp. (m s^-^1)',...
        'Wind dir. (degrees)','u_* (m s^-^1)','Precip. (mm)',...
        'VPD (kPa)', 'Soil T. (\circC)',...
        'RH (%)', 'Soil H_2O. (m^3 m^-^3)',...
        'SWE (mm)'};
    
    % columns that correspond to the labels
    mat_dri = [6,9,10,11,13,15,17,31,32,34];
end


%% generate the scatterplot
figure()
if HD == 2
    [H,AX]= plotmatrix(driversDaily_target_filter_NEE_DAY(:,mat_dri));
elseif HD == 1
    [H,AX]= plotmatrix(driversDaily_target_filter_NEE_NIGHT(:,mat_dri));
end

% Consider adding water flux version (although it will be very very
% similar)

% % label the plots (not rotated)
% for i = 1:length(AX)
%     ylabel(AX(i,1),data_labels{i});
%     xlabel(AX(end,i),data_labels{i});
% end

% label the axes of the plots (rotated)
for i = 1:length(AX)
    ylabel(AX(i,1),data_labels{i},'Rotation',0,'HorizontalAlignment','right',...
        'FontSize',13);
    xlabel(AX(end,i),data_labels{i},'Rotation',45,'HorizontalAlignment','right',...
        'FontSize',13);
end


% Get x axis limits
% ax1=get(AX,'xlim');

% Set the x axis limits to the minimum data value
set(AX,'xlim',[-inf inf])

% Set the y axis limits to the minimum data value
set(AX,'ylim',[-inf inf])

%Set ticks (puts them at the first and last)
NumTicks = 2;
for k = 1:numel(AX)
    L = get(AX(k),'XTick');
    set(AX(k),'XTick',linspace(L(1),L(end),NumTicks));
    LY = get(AX(k),'YTick');
    set(AX(k),'YTick',linspace(LY(1),LY(end),NumTicks));
end

% Get current figure size
pos = get(gcf, 'Position'); %// gives x left, y bottom, width, height
width = pos(3);
height = pos(4);

% Set figure size
%  set(gcf, 'PaperUnits', 'inches');
%  y_width=7.25; x_width=9.125;
%  set(gcf, 'PaperPosition', [0 0 x_width y_width]);
h=gcf;
set(h,'PaperPositionMode','auto');         
set(h,'PaperOrientation','landscape');
set(h, 'Position', [267 82 1100 950])

% Get rid of extra space on margins
addpath('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/tightfig')
tightfig(h)

% Save figure
cd(strcat(pwd,'/more graphs'))
if HD == 2
    saveas(h,'scatterMat_Day.fig') % save by hand for now, then manually save as .eps doesn't cut so much off
%    saveas(h,'scatterMat_Day.eps', 'psc2')
elseif HD == 1
    saveas(h,'scatterMat_Night.fig') % save by hand for now, then manually save as .eps doesn't cut so much off
%    saveas(h,'scatterMat_Night.eps', 'psc2')
end

%% correlation coefficients
% this isn't working:
%rmat = corrcoef(driversDaily(:,mat_dri),driversDaily(:,mat_dri),'rows','pairwise'); %This excludes NaNs. Since it is only comparing two things, I think 'pairwise' and 'complete' are the same in this case.  (Applying 'pairwise' Trevor's original example script does not change r value)
%
% In later versions of matlab something like this would work:
% corrplot(driversDaily(:,mat_dri),'type','Kendall','testR','on')
% Note that there is also a fileExchange version of 'corrplot' that I
% tested but doesn't seem like what I want because it plots all r values on same plot.
% http://www.mathworks.com/matlabcentral/fileexchange/35674-corrplot/content/cp/corrplot.m
%

%% For stack overflow
% % Maybe make stack exchange question about how to add correlation
% % coefficients?
% % http://stackoverflow.com/questions/41645327/matlab-plotmatrix-edit-ticks-for-each-plot#41645327
% 
% % Example data
% example = driversDaily_target_filter_NEE_DAY(1:50,[6,9,10]);
% 
% % Labels for data
% data_labels = {'Variable1','Variable2',...
%     'Variable3'};
% 
% % Make scatterplot matrix with histogram on diagonal
% figure()
% [H,AX]= plotmatrix(example(:,:));
% 
% % label the axes of the plots (rotated)
% for i = 1:length(AX)
%     ylabel(AX(i,1),data_labels{i},'Rotation',0,'HorizontalAlignment','right',...
%         'FontSize',12);
%     xlabel(AX(end,i),data_labels{i},'Rotation',60,'HorizontalAlignment','right',...
%         'FontSize',12);
% end
% 
% %Set ticks (puts them at the limits)
% % NumTicks = 2;
% % for k = 1:numel(AX)
% %     L = get(AX(k),'XLim');
% %     set(AX(k),'XTick',linspace(L(1),L(2),NumTicks));
% % could add y here too
% % end
% 
% %Set ticks (puts them at the first and last)
% for k = 1:numel(AX)
%     L = get(AX(k),'XTick');
%     set(AX(k),'XTick',linspace(L(1),L(end),NumTicks));
%     LY = get(AX(k),'YTick');
%     set(AX(k),'YTick',linspace(LY(1),LY(end),NumTicks));
% end
% 
% % Or could do like this:
% %set(AX, {'XTick'}, cellfun(@(x)linspace(x(1),x(2),2), get(AX, 'Xlim'), 'UniformOutput', false))
