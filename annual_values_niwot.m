% This script will load half-hour data and and do calculations for 
% annual climate and flux variables of interest. The input files come from
% concatenate.m or match_data_flags.m output files depending upon whether
% you choose gap-filled or non-gap filled data. Then it uses the
% calculations for scatterplots, regressions and bar plots, including
% 1) scatterplots of climate variables versus NEE
% 2) a plot of NEE over time for each of the years.
% 3) a bar graph of cumulative precip for each year
% It also produces an output, 'annual_values_ANN_input', for use with
% inter-annual ANN analysis, saved in 'Annual value ANNs/Annual_DataIn/'
%
% Notes: Since some variables are cumulative, best to use
% gap-filled data.  Note that since 1998 is only part of a year, it's max
% and cumulative values probably don't mean much.  1998 is excluded from the
% figures/regressions in this script.

% To fix: 
% 1) in for loop that makes figures, check if p-values are the ones I
% want to extract (f-test versus t-test).  This is only necessary if I end
% up using these regressions....
% 2) In section 9, IF I USE IT FOR ANYTHING: 
%    2a) Check period start_DOY and stop_DOY against fluxMat and StartStop. 
%    Then erase this note
%    2b) Make sure that all rows 'binned' by period add up to total rows in
%    fluxMat (see warnings printed in for loops in secion 8 below).  This is to
%    make sure that the logic for inclusion in each period doesn't miss any rows. Again, 
%    only necessary if I use the cumulative NEE from each period for something
% 3) In section 8 add code to change length of winter for leap vs. non leap years

% To do:
% 1) Choose gap-filled or non-gap filled data

close all
clear all

%cd('/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts')

%% Section 1: Load data and make matrices

% Define file names for use with textread
fileNames={'_allyears_OKflags','_allyears'};
fileOK_30=fileNames{1}; % Use with 'load' for non-gap-filled 30 min climate data
fileGF_30=fileNames{2}; % Use with 'load' for gap-filled 30 min climate data

% Load climate data, and set 'fileOK' or 'fileGF'
filetoopen = strcat('../../../NR data/Data output from matlab/climate',fileGF_30,'.txt');
[Year, MO, DD, HR, MM, SS, DecimalDate, T_21m, RH_21m, P_bar_12m, ws_21m, wd_21m, ustar_21m, z_L_21m, precip_mm, Td_21m, vpd, wet_b, T_soil, T_bole_pi, T_bole_fi, T_bole_sp, Rppfd_in_, Rppfd_out, Rnet_25m_, Rsw_in_25, Rsw_out_2, Rlw_in_25, Rlw_out_2, T_2m, T_8m, RH_2m, RH_8m, h2o_soil, co2_21m] = ...
    textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');

% Load flux data, and set 'fileOK' or 'fileGF'
% Note: vector names used with textread are for gap-filled data... could
% change them if you use non-gap-filled data
filetoopen = strcat('../../../NR data/Data output from matlab/flux',fileGF_30,'.txt');
[fYear, fMO, fDD, fHR, fMM, fSS, fDecimalDate, Fco2_21m_ne, Fco2_21m_nee_wust, Strg_co2, tu_w_21m, Taua_21m, Qh_21m, Qe_21m, w_h2o_21m, Qh_soil, Strg_Qh, Strg_Qe, Strg_bole, Strg_needle] = ...
    textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');

% Load snotel data
run load_snotel.m

% Make matrix of climate variables from columns
driversMat=[Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m];

% Make matrix of flux variables from columns
fluxMat=[fYear fMO fDD fHR fMM fSS fDecimalDate Fco2_21m_ne Fco2_21m_nee_wust Strg_co2 tu_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle];

% Clear extra stuff
clear SWE_DS SWE_prev30DS SWE_prev30 file

%% Section 2: Calculations for climate variables

% Make for loop to find maximum, mean, etc for driver values
% (It would be nice to have each year have a vector that dynamically changes names, but for some reason
% eval(['yr',num2str(years(i))](k,:))=driversMat(k,:); doesn't work)

years=unique(driversMat(:,1));
T_21m_max=[];
T_21m_min=[];
T_21m_mean=[];
temp=[];
cum_precip=[];
cum_ppfd=[];
cum_vpd=[];

for i=1:length(years)
    for k=1:length(driversMat(:,1));
        if driversMat(k,1)==years(i)
            temp=[temp; driversMat(k,:)];
        end
    end
    T_21m_max=[T_21m_max; max(temp(:,8))];
    T_21m_min=[T_21m_min; min(temp(:,8))];
    T_21m_mean=[T_21m_mean; nanmean(temp(:,8))];
    cum_precip=[cum_precip; nansum(temp(:,15))];
    cum_ppfd=[cum_ppfd; nansum(temp(:,23))];
    cum_vpd=[cum_vpd; nansum(temp(:,17))];
    temp=[];
end


% Find maximum SWE for each year (this can't be done in the for loop above
% because this data is at 'day' increments not half-hour increments.

% First make vector of years to match SWE data
% For reference:
% 365 days for 1999, 2001, 2002, 2003, 2005, 2006, 2007, 2009, 2010, 2011;
% 366 days for 2000, 2004, 2008, 2012; 
vec_1998_days=305:1:365;    % Make vector of days for 1998.  The first row of SWE is is Nov 1, 1998,
vec_1998=repmat(1998,length(vec_1998_days),1);
vec_daysPerYr=[];
vec_years=[];
for j = 2:length(years);
    vec_daysPerYr(j)=sum(eomday(years(j),1:12));
    vec_years=[vec_years; repmat(years(j),vec_daysPerYr(j),1)];
end
vec_years=[vec_1998; vec_years];
SWE_years=[vec_years, SWE];

% Make for loop to find maximum SWE for each year
temp2=[];
SWE_max=[];
for j=1:length(years)
   for i=1:length(SWE_years(:,1))
       if SWE_years(i,1)==years(j)
           temp2=[temp2; SWE_years(i,:)];
       end
   end
   SWE_max=[SWE_max; max(temp2(:,2))];
   temp2=[];
end
%% Section 3: Calculations for flux variables

% Make for loop to calculate cumulative NEE for each year
temp3=[];
cum_NEE=[];
for j=1:length(years)
    for i=1:length(fluxMat(:,1))
        if fluxMat(i,1)==years(j)
            temp3=[temp3; fluxMat(i,:)];
        end
    end
    cum_NEE=[cum_NEE; nansum(temp3(:,8))];
    temp3=[];
end

% Cumulative NEE of the growing season
% load start/stop dates and find start date of snow-melt & post-monsoon for each year
%filename = '/Users/lpapgm/Dropbox/Niwot Ridge project/NR data/Data output from matlab/start_stop_from_climate_allyears_OKflags.txt';
filename = '/Users/lalbert/Dropbox/Niwot Ridge project/NR data/Data output from matlab/start_stop_from_climate_allyears_OKflags.txt';
delimiterIn = '\t';
headerlinesIn = 1;
StartStop = importdata(filename,delimiterIn,headerlinesIn);
% Add DOY to fluxmat
fluxMat(:,end+1)=floor(fluxMat(:,7));

% For loop to find start of snowmelt for each year
snowmelt_Ind=[];
Startdoy_Ind=[];
yrs = unique(fluxMat(:,1));
for y = 1:length(yrs);
    if yrs(y)==1998 % Since 1998 is not a complete year
        Startdoy_Ind(y)=nan;
    else
        snowmelt_Ind(y) = find(StartStop.data(:,1)==yrs(y));
        Startdoy_Ind(y)=find(fluxMat(:,1)==yrs(y) & fluxMat(:,21)==StartStop.data(snowmelt_Ind(y),3),1,'first');
    end
end
Startpos = Startdoy_Ind';

% For loop to find end of growing season for each year
    post_Ind=[];
    Stopdoy_Ind=[];
    for i = 1:length(yrs);
        if yrs(i)==1998 % Since 1998 is not a complete year
            Stopdoy_Ind(i)=nan;
        else
            post_Ind(i) = find(StartStop.data(:,1)==yrs(i));
            Stopdoy_Ind(i)=find(fluxMat(:,1)==yrs(i) & fluxMat(:,21)==StartStop.data(post_Ind(i),11),1,'first');
        end
    end
    Stoppos = Stopdoy_Ind';
  
% Make loop to calculate cumulative NEE of the growing season for each year
temp4=[];
cum_NEE_GS=[];
for j=1:length(yrs)
    if yrs(j) == 1998
        cum_NEE_GS(j)=nan;
    else
        for i=1:length(fluxMat(:,1))
            if i >Startpos(j) && i <Stoppos(j)
                temp4=[temp4; fluxMat(i,:)];
            else
                temp4=temp4;
            end
        end
        cum_NEE_GS(j)=[nansum(temp4(:,8))];
        temp4=[];
    end
end


%% Section 4: Scatterplots of annual climate variables versus NEE

% Change to directory where I want to save these graphs
cd('/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/annual_values_niwot_graphs')

% Make new matrix with all the new calculations
annualMat=[years T_21m_max T_21m_min T_21m_mean cum_precip cum_ppfd cum_vpd SWE_max cum_NEE cum_NEE_GS'];
name_vec={'years' 'T_21m_max' 'T_21m_min' 'T_21m_mean' 'cumulative_precip' 'cumulative_ppfd' 'cumulative_vpd' 'SWE_max' 'cumulative_NEE' 'growSeason_cum_NEE'};
statmat=[];

% Variables versus annual cumulative NEE
for i=2:(length(annualMat(1,:))-1)
    stats=regstats(annualMat(2:end,9),annualMat(2:end,i),'linear');
    statmat(1,i)=stats.fstat.pval;
    statmat(2,i)=stats.tstat.pval(2);   % I think tstats gives values for the betas, but NEED to check which pval is which
    f=figure(i);
    scatter(annualMat(2:end,i),annualMat(2:end,9),'.') %skip 1998 (first row) since it is incomplete
    S1=['r-square=',num2str(stats.rsquare)];
    title(S1,'FontSize',14)
    xlabel(name_vec(i),'FontSize',14)
    ylabel('Cumulative Net Ecosystem Exchange','FontSize',14)
    h=lsline;
    set(h,'linewidth',2,'color','r');
    T_21m_MO=[];
    Fco2_21m_nee_MO=[];
    %     hgexport(f,name_vec(i))
    filename=name_vec{i};
    print(f,'-dpdf',filename)
end

% stats=regstats(annualMat(2:end,9),annualMat(2:end,i),'linear');

% Variables versus growing season cumulative NEE
for k=2:(length(annualMat(1,:))-1)
    stats=regstats(annualMat(2:end,10),annualMat(2:end,k),'linear');
    statmat(1,k)=stats.fstat.pval;
    statmat(2,k)=stats.tstat.pval(2);   % I think tstats gives values for the betas, but NEED to check which pval is which
    f=figure(k+9);
    scatter(annualMat(2:end,k),annualMat(2:end,10),'.') %skip 1998 (first row) since it is incomplete
    S1=['r-square=',num2str(stats.rsquare)];
    title(S1,'FontSize',14)
    xlabel(name_vec(k),'FontSize',14)
    ylabel('Growing Season Cum. NEE','FontSize',14)
    h=lsline;
    set(h,'linewidth',2,'color','r');
    T_21m_MO=[];
    Fco2_21m_nee_MO=[];
    %     hgexport(f,name_vec(i))
    filename=name_vec{k};
    print(f,'-dpdf',filename)
end

%% Section 5: Make plot of NEE over year for each year
figure (k+10)

plot(fluxMat(:,1),fluxMat(:,9)); % Think about which NEE column is right for this graph

%% Section 6: Make bar graph of precip for each year
figure (k+11)

% Bar plot of cumulative precipitation from 1999 on
bar(years(2:end),cum_precip(2:end),'FaceColor',[0.65,0.65,0.65],'EdgeColor','k');
fsize=22;
xlabel('Year','FontSize',fsize,'FontWeight','bold','Color','k')
ylabel('Cumulative precipitation (mm)','FontSize',fsize,'FontWeight','bold','Color','k')

%% Section 7: Make bar graph of precip plus SWE
figure(k+12)

% Concatenate cumulative precip and peak SWE in preparation for bar plot
group_data = [cum_precip(2:end) SWE_max(2:end)];

% Bar plot of cumulative precipitation and max SWE from 1999 on
% P_SWE_bar=plotyy(years(2:end),cum_precip(2:end),years(2:end),SWE_max(2:end),'bar');% %this doesn't quite work, but maybe worth playing with
P_SWE_bar = bar(years(2:end),group_data,'group','BarWidth',0.9);

% Label axes
fsize=22;
xlabel('Year','FontSize',fsize,'FontWeight','bold','Color','k')
ylabel('H_2O (mm)','FontSize',fsize,'FontWeight','bold','Color','k')

% Set axis properties
axesP_SWE = gca;
axesP_SWE.FontSize=16;
axesP_SWE.XTickLabelRotation=45;

% Set face color
P_SWE_bar(1).EdgeColor = 'k';
P_SWE_bar(1).FaceColor = [0.85,0.85,0.85];
P_SWE_bar(2).EdgeColor = 'k';
P_SWE_bar(2).FaceColor = [0.45,0.45,0.45];

% remove box around plot
box off

% add legend
P_SWE_leg=legend('Cumulative precip.','Max. SWE','Location','North');

%% Section 8: length of each period vs. annual cumulative NEE

% Right now some of these dates overlap by one day.  Fix this. (check
% loadobsanddrivers, and script that makes background graphs).  Also fix winter2_length for leap years
% THEN DELETE this note and note in 'to fix' in header

SM_length=StartStop.data(:,5)-(StartStop.data(:,3)-1);          % Add 1 since SM start date is included in snow melt
preM_length=StartStop.data(:,7)-(StartStop.data(:,5)+1);        % subtract 2 because pre-monsoon starts one doy after snowmelt ends and stops one doy before monsoon begins
monsoon_length=StartStop.data(:,9)-(StartStop.data(:,7)-1);     % Add 1 since monsoon start date is included in monsoon
postM_length=StartStop.data(:,11)-StartStop.data(:,9);          % post monsoon starts day after monsoon ends
winter1_length = StartStop.data(:,3)-1;                         % winter stops day before SM starts
winter2_length = 365-StartStop.data(:,11);                      % winter starts day after post monsoon stops
winter_total_length = winter1_length+winter2_length;

f=figure(k+13);
scatter(SM_length, cum_NEE)
SM_stats=regstats(SM_length, cum_NEE,'linear');
s1=['r-square=',num2str(SM_stats.rsquare)];
title(s1,'FontSize',14)
xlabel('Snowmelt length','FontSize',14)
ylabel('Annual cumulative NEE','FontSize',14)
h=lsline;
set(h,'linewidth',2,'color','r');
SM_p=SM_stats.fstat.pval;

f=figure(k+14);
scatter(preM_length, cum_NEE)
preM_stats=regstats(preM_length, cum_NEE,'linear');
s2=['r-square=',num2str(preM_stats.rsquare)];
title(s2,'FontSize',14)
xlabel('Pre-monsoon length','FontSize',14)
ylabel('Annual cumulative NEE','FontSize',14)
h=lsline;
set(h,'linewidth',2,'color','r');

f=figure(k+15);
scatter(monsoon_length, cum_NEE)
Monsoon_stats=regstats(monsoon_length, cum_NEE,'linear');
s3=['r-square=',num2str(Monsoon_stats.rsquare)];
title(s3,'FontSize',14)
xlabel('Monsoon length','FontSize',14)
ylabel('Annual cumulative NEE','FontSize',14)
h=lsline;
set(h,'linewidth',2,'color','r');

f=figure(k+16);
scatter(postM_length, cum_NEE)
Post_monsoon_stats=regstats(postM_length, cum_NEE,'linear');
s4=['r-square=',num2str(Post_monsoon_stats.rsquare)];
title(s4,'FontSize',14)
xlabel('Post-monsoon length','FontSize',14)
ylabel('Annual cumulative NEE','FontSize',14)
h=lsline;
set(h,'linewidth',2,'color','r');
Post_monsoon_p=Post_monsoon_stats.fstat.pval;

f=figure(k+17);
scatter(winter_total_length, cum_NEE)
winter_stats=regstats(winter_total_length, cum_NEE,'linear');
s5=['r-square=',num2str(winter_stats.rsquare)];
title(s5,'FontSize',14)
xlabel('Winter length','FontSize',14)
ylabel('Annual cumulative NEE','FontSize',14)
h=lsline;
set(h,'linewidth',2,'color','r');
winter_p=winter_stats.fstat.pval;
 
%% Section 9: cumulative NEE for each period (uncomment if I use for anything.  It's slow)
% 
% SEE 'TO FIX' IN HEADER IF I USE THIS FOR ANYTHING
%
% % For loop to find the start and stop doy of each seasonal period for each
% % year
% yr_Ind=[];
% snowmelt_start_DOY=[];
% snowmelt_stop_DOY=[];
% premon_start_DOY=[];
% premon_stop_DOY=[];
% monsoon_start_DOY=[];
% monsoon_stop_DOY=[];
% postm_start_DOY=[];
% postm_stop_DOY=[];
% winter_start_DOY=[];
% winter_stop_DOY=[];
% 
% % Find start and stop for each period for each year in flux dataset
% yrs = unique(fluxMat(:,1));
% for y = 1:length(yrs);
%     if yrs(y)==1998 % Since 1998 is not a complete year
%         snowmelt_start_DOY=nan;
%         premon_start_DOY=nan;
%         monsoon_start_DOY=nan;
%         postm_start_DOY=nan;
%         winter_start_DOY=nan;
%         snowmelt_stop_DOY=nan;
%         premon_stop_DOY=nan;
%         monsoon_stop_DOY=nan;
%         postm_stop_DOY=nan;
%     else
%         yr_Ind(y)=find(StartStop.data(:,1)==yrs(y));
%         snowmelt_start_DOY(y)=find(fluxMat(:,1)==yrs(y) & fluxMat(:,21)==StartStop.data(yr_Ind(y),3),1,'first');
%         snowmelt_stop_DOY(y)=find(fluxMat(:,1)==yrs(y) & fluxMat(:,21)==StartStop.data(yr_Ind(y),5),1,'first');
%         premon_start_DOY(y)=snowmelt_stop_DOY(y)+48; %start pre-monsoon one doy after snowmelt ends
%         monsoon_start_DOY(y)=find(fluxMat(:,1)==yrs(y) & fluxMat(:,21)==StartStop.data(yr_Ind(y),7),1,'first');
%         premon_stop_DOY(y)= monsoon_start_DOY(y)-48; %end pre-monsoon one doy before monsoon starts
%         monsoon_stop_DOY(y)=find(fluxMat(:,1)==yrs(y) & fluxMat(:,21)==StartStop.data(yr_Ind(y),9),1,'first');
%         postm_start_DOY(y)=monsoon_stop_DOY(y)+48; %start post-monsoon one doy after monsoon ends
%         postm_stop_DOY(y)=find(fluxMat(:,1)==yrs(y) & fluxMat(:,21)==StartStop.data(yr_Ind(y),11),1,'first');
%         winter_start_DOY(y)=postm_stop_DOY(y)+48;
%     end
% end
% 
% % Define winter stops (seperate loop since depends on y+1 index)
% for y = 1:length(yrs)-1; %since last winter is incomplete (goes into 2014) only go to second to last winter
%     if yrs(y)==1998 % Since 1998 is not a complete year
%         winter_stop_DOY=nan;
%     else
%         winter_stop_DOY(y)=snowmelt_start_DOY(y+1)-48;
%     end
% end
% 
% 
% % Make loops to calculate cumulative NEE of each period for each year
% % Sums for all periods except winter
% snowmelt_cum_NEE = [];
% premonsoon_cum_NEE = [];
% monsoon_cum_NEE = [];
% postmonsoon_cum_NEE = [];
% tempSM=[];
% tempPreM=[];
% tempMon=[];
% tempPostM=[];
% not_included=[0];
% 
% for yy=1:length(yrs)
%     if yrs(yy) == 1998
%         snowmelt_cum_NEE(yy)=nan;
%         premonsoon_cum_NEE(yy)=nan;
%         monsoon_cum_NEE(yy)=nan;
%         postmonsoon_cum_NEE(yy)=nan;
%         winter_cum_NEE(yy)=nan;
%     else
%         for i=1:length(fluxMat(:,1))
%             if i >snowmelt_start_DOY(yy) && i <snowmelt_stop_DOY(yy)
%                 tempSM=[tempSM; fluxMat(i,:)];
%             elseif i >premon_start_DOY(yy) && i <premon_stop_DOY(yy)
%                 tempPreM=[tempPreM; fluxMat(i,:)];
%             elseif i >monsoon_start_DOY(yy) && i <monsoon_stop_DOY(yy)
%                 tempMon=[tempMon; fluxMat(i,:)];
%             elseif i >postm_start_DOY(yy) && i <postm_stop_DOY(yy)
%                  tempPostM=[tempPostM; fluxMat(i,:)];
%             else
%                 not_included=[not_included+1];
%             end
%         end
%         SM_cum_NEE(yy)=[nansum(tempSM(:,8))];
%         tempSM=[];
%         premonsoon_cum_NEE(yy)=[nansum(tempPreM(:,8))];
%         tempPreM=[];
%         monsoon_cum_NEE(yy)=[nansum(tempMon(:,8))];
%         tempMon=[];
%         postmonsoon_cum_NEE(yy)=[nansum(tempPostM(:,8))];
%         tempPostM=[];
%     end
% end
% warning([num2str(not_included) ' rows of fluxMat is not included in snowmelt, pre-M, monsoon, or post-M periods.  Sum of 1998 rows plus 2013 rows plus winter rows should equal this'])
% 
% % Sums for winter
% tempW=[];
% winter_cum_NEE = [];
% not_included=[0];
% 
% for yy=1:length(yrs)-1
%     if yrs(yy) == 1998
%         winter_cum_NEE(yy)=nan;
%     else
%         for i=1:length(fluxMat(:,1))
%             if i >winter_start_DOY(yy) && i <winter_stop_DOY(yy)
%                 tempW=[tempW; fluxMat(i,:)];
%             else
%                 not_included=[not_included+1];
%             end
%         end
%         Winter_cum_NEE(yy)=[nansum(tempW(:,8))];
%         tempW=[];
%         %add addition for each year, other periods, here
%     end
% end
% warning([num2str(not_included) ' rows of fluxMat is not included in winter ecosystem phenology period.  Sum of 1998 rows plus 2013 rows plus all other periods should equal this'])


%% Section 10: Export new ANN input files
% (For annual value ANN analysis)


% Export data into tab-delimited file
% Note that header names are hard-coded and based on names used to make 'data' matrix

%header = {'%Year', 'T_21m_max', 'T_21m_min', 'T_21m_mean', 'cum_precip', 'cum_ppfd', 'cum_vpd', 'SWE_max', 'cum_NEE'};
header = name_vec;
filepathout='/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/Annual value ANNs/Annual_DataIn/';
filenameout='annual_values_ANN_input';
outputfilepath = strcat(filepathout,filenameout);
fid = fopen(outputfilepath, 'w');
% if fid == -1; error('Cannot open file: %s', outfile); end
fprintf(fid, '%s\t', header{:});
fprintf(fid, '\n');
fclose(fid);
dlmwrite(outputfilepath,annualMat,'-append','delimiter','\t');
% %dlmwrite(outputfilepath,annualMat,'\t'); %output tab delimited file for file without header
