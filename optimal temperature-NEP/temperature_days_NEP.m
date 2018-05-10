% Loren Albert, fall 2015
%
% This script looks at whether the number of days within an 'optimal'
% temperature range (based on the ANN response curve) has an impact on NEP
% for each year.
%
% To do:
% 0) clear workspace of objects
% 1) load workspace from 'all' daytime ANN runs: /Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/Eco Pheno Workspaces/NEE Without soil moisture/workspacesDay_w_SWE_no_S-H2O_1999_2013
% 2) run 'many_OneDriver_forPlot.m to generate average ANN temperature
% response (script in /Dropbox/Niwot Ridge project/Matlabscripts/MatlabScripts/LPA-edited scripts/MatlabScripts_from_TK/notSoSimple)
% 3) then run this script
%
% Secion 1: Calculate optimal temperature and number of daytimes near
% optimal temperature for each year
% Section 2: load annual NEP value data
% Section 3: Examine annual NEP metrics versus number of daytimes near Topt metrics


%% Section 1
% Calculate optimal temperature for 'all' data (all continuous daytime data)
NEP_max = find(NEP_ave_response_y==max(NEP_ave_response_y));
T_opt = response_x(NEP_max);
% And calculate 'breadth' of temperature response (temperatures at 95% of max NEP)
% (This uses absolute value since NEP_ave_response is 300 points instead of continuous)
NEP_95_max = find(abs((.95*max(NEP_ave_response_y))-NEP_ave_response_y)<0.03);
T_95_opt = response_x(NEP_95_max);
% And look at temperatures at 90% of max NEP
NEP_90_max = find(abs((.90*max(NEP_ave_response_y))-NEP_ave_response_y)<0.03);
T_90_opt = response_x(NEP_90_max);

% Double check that inputs are what you think they are (produces error if
% not)
if inputs(:) == subDriversMonths(:,columns.T21m);
else
    error('input is not temperature.  Check driverIndex')
end

% How many daytimes were within 95% and 90% of optimal temperature?
% (Note: 'inputs' was air temperature associate with each daytime data point)
daytimes_T_95_opt = find(inputs>T_95_opt(1) & inputs<T_95_opt(2));
daytimes_T_90_opt = find(inputs>T_90_opt(1) & inputs<T_90_opt(2));

% How many of those daytimes belong to each individual year?
% for 95% of Topt
yrs_daytimes_T_95_opt = subDriversMonths(daytimes_T_95_opt,:);
table_T_95_opt = tabulate(yrs_daytimes_T_95_opt(:,1)); %second column is number of occurences (see 'tabulate')
table_T_95_opt_15yrs = table_T_95_opt(1999:end,:);
% for 90% of Topt
yrs_daytimes_T_90_opt = subDriversMonths(daytimes_T_90_opt,:);
table_T_90_opt = tabulate(yrs_daytimes_T_90_opt(:,1)); %second column is number of occurences (see 'tabulate')
table_T_90_opt_15yrs = table_T_90_opt(1999:end,:);

%% Section 2
   % this will load observations and modeled results
    % from the NACP project for Niwot Ridge
    file='annual_values_ANN_input';
    
    % load annual values.
    addpath('/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/Annual value ANNs/Annual_DataIn');
    annual_var=importdata(strcat('Annual_DataIn/',file));
    
    % Convert cumulative NEE into cumulative NEP
    cum_NEE=annual_var.data(:,9);
    cum_NEP=-1*cum_NEE(2:end); % Leave out 1998 to start at 1999
    
    % Convert growing season cumulative NEE into growing season cumulative NEP
    cum_gs_NEE=annual_var.data(:,10);
    cum_gs_NEP=-1*cum_gs_NEE(2:end); % Leave out 1998 to start at 1999
    
    %% Section 3
    % Examine cumulative NEP versus number of daytimes near Topt
    figure()
    scatter(table_T_95_opt_15yrs(:,2), cum_NEP,'.')
    stats1=regstats(table_T_95_opt_15yrs(:,2), cum_NEP,'linear');
    S1=['r-square=',num2str(stats1.rsquare)];
    title(S1,'FontSize',14)
    l1=lsline;
    set(l1,'linewidth',2,'color','r');
    xlabel('Number of days 95 percent of Topt')
    ylabel('Annual cumulative NEP')
    
    % Examine growing season cumulative NEP versus number of daytimes near Topt
    figure()
    scatter(table_T_95_opt_15yrs(:,2), cum_gs_NEP,'.')
    stats2=regstats(table_T_95_opt_15yrs(:,2), cum_gs_NEP,'linear');
    S2=['r-square=',num2str(stats2.rsquare)];
    title(S2,'FontSize',14)
    l2=lsline;
    set(l2,'linewidth',2,'color','r');
    xlabel('Number of days 95 percent of Topt')
    ylabel('Cumulative growing season NEP')
    
    % Examine cumulative NEP versus number of daytimes within 90% of Topt
    figure()
    scatter(table_T_90_opt_15yrs(:,2), cum_NEP,'.')
    stats3=regstats(table_T_90_opt_15yrs(:,2), cum_NEP,'linear');
    S3=['r-square=',num2str(stats3.rsquare)];
    title(S3,'FontSize',14)
    l3=lsline;
    set(l3,'linewidth',2,'color','r');
    xlabel('Number of days 90 percent of Topt')
    ylabel('Annual cumulative NEP')
    
    % Could Examine snowmelt cumulative NEP versus number of snowmelt daytimes
    % near Topt (idea that this will be less affected by respiration
    % response to temperature)
    


