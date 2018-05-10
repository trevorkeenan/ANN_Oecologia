% Loren Albert
%
% This script is for determining start and stop dates for seasonal
% 'binning' of data to run on ANNs when it involves precipitation.  
% The results are called in 'LoadObsAndDrivers.m' (at first I wrote code 
% to determine start and stop dates based on precipitation in
% 'LoadObsAndDrivers', but the problem is that I could only work with
% either day or night....I wanted daytime and nighttime to have the same
% start/stop dates).  
%
% This script takes the output of 'Match_data_flags.m', which is a climate
% file or flux file that includes only data with flags 1,4 and 5 OR 
% takes as input the concatenated climate files made with the
% script "concatenate.m".  Note that if using to define threshold dates,
% this script won't work with FLUX files as currently written (threshold
% dates depend upon CLIMATE variables SWE, precip, and also doy). (Note
% that since SWE and precipitation have no gaps, Datatype=1 and Datatype=3
% give same start/stop dates for ecosystem phenology periods (criteria 10).
%
% There is some commented out code at the bottom that might be useful for
% future reference ('neeneg' from loadObsAndDrivers that I took out since I
% don't think I'll use it).
%
% Useful links: http://www.mathworks.com/matlabcentral/answers/15290-axis-date-values-disappear-when-datetick-is-applied-to-a-simple-time-series-plot
%
% To do: 
% 1) Choose whether to use climate or flux data under 'changeable options'
% 2) Choose whether to define start/stop dates for ecosystem phenology
% periods (criteria 10) or graph-making (criteria 11).
% 3) If using this script for defining monsoon start/stop dates, choose
% precipitation sum threshold for monsoon start.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all

%%%%%%%%%%%%%%%%%%%%%%
%% Changable options %
%%%%%%%%%%%%%%%%%%%%%%

% Change directory if not already there
% cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts')

% Path names and output file path
%fileyear = 1998; %Year for data and flags files when going year by year
filepath = char('../../../NR data/Data output from matlab/'); %directory where files live
filepathout = char('../../../NR data/Data output from matlab/'); %directory for output

% Choose Data Type:
% Choose 1 for climate data file that includes only data with flags 1,4 and 5.
% Choose 2 for flux data file that includes only data with flags 1,4 and 5.
% Choose 3 for climate data file that is gap-filled (all flags included).
% Choose 4 for fluxdata file that is gap-filled (all flags included).
% (Note that since there are no gaps in SWE or precip, 1 versus 3 shouldn't
% make a difference for various start/stop dates).
Datatype = 1;

% Choose which criteria for output
% Choose 10 for precip criteria for monsoon start/stop dates, and export matrix of these dates
% Choose 11 for graph-making of environmental variables for each year
Criteria = 10;

% Choose precipitation threshold (if Criteria == 10)
precipThresh=10;        % Tried 10 mm, which is decent for most years but some years have preMonsoon only a few days long if criteria of after July 10/July 15 isn't added

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated 1--Import data and assign output file name%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If statement for importing data and choosing output file name based on data type
if Datatype == 1
    filename = strcat('climate_allyears_OKflags.txt'); %Output from Match_data_flags
    filetoopen = strcat(filepath,filename); %concatenate file path with file name
    [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m] = ...
            textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab'); 
    filenameout = strcat('start_stop_from_climate_allyears_OKflags.txt'); % Output filename
elseif Datatype == 2
    filename = strcat('flux_allyears_OKflags.txt'); %Output from Match_data_flags
    filetoopen = strcat(filepath,filename); %concatenate file path with file name
    [Year MO DD HR MM SS DecimalDate Fco2_21m_nee_stat_int_Ustar Fco2_21m_nee_stat_int Strg_co2 tu_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle] = ...
            textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
    filenameout = strcat('start_stop_from_flux_allyears_OKflags.txt'); % Output filename
elseif Datatype == 3
    filename = strcat('climate_allyears.txt'); %Output from Concatenate
    filetoopen = strcat(filepath,filename); %concatenate file path with file name
    [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m] = ...
            textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab'); 
    filenameout = strcat('start_stop_from_climate_allyears.txt'); % Output filename
elseif Datatype == 4
     filename = strcat('flux_allyears.txt'); %Output from Concatenate
    filetoopen = strcat(filepath,filename); %concatenate file path with file name
    [Year MO DD HR MM SS DecimalDate Fco2_21m_ne Fco2_21m_nee_wust Strg_co2 tu_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle] = ...
        textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
    filenameout = strcat('start_stop_from_flux_allyears.txt'); % Output filename
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated 2--Find dates for defining ecosystem phenology start/stops%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Criteria == 10
    
    % Make a matrix then dataset from data
    data = [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m];
    header = {'Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'};
    dataset1 = dataset({data,header{:}});
    
    % Make a new data column based on year that is ordinal (for concatenated all years file)
    y = min(Year(:));
    Y = max(Year(:));
    labels2 = num2str((y:Y)');
    edges = y:Y+1;
    dataset1.YearOrd = ordinal(dataset1.Year,labels2,[],edges);
    
    % Make a new data column based on DD that is ordinal and without decimal for use with
    % statistics command.  Based on code here: http://www.mathworks.com/help/stats/ordinal.html
    m = floor(min(DecimalDate(:)));
    M = floor(max(DecimalDate(:)));
    labels = num2str((m:M)');
    edges = m:M+1;
    dataset1.Day = ordinal(dataset1.DecimalDate,labels,[],edges);
    
    % Calculate variable means and precip sum for each doy by combination of year, and day of year
    % Based on code here: http://www.mathworks.com/help/stats/grpstats.html#bthgrw_
    MeanEnvds = grpstats(dataset1,{'YearOrd','Day'},'mean','DataVars',{'MO','T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'});
    sumEnvds = grpstats(dataset1,{'YearOrd','Day'},'sum','DataVars',{'precip_mm'});
    sumEnv=double(sumEnvds);
    meanEnv = double(MeanEnvds);
    YearN = meanEnv(:,1:1) + 1997;
    meanEnv(:,1:1) = YearN;
    sumEnv(:,1:1) = YearN;
    
    % Load snotel data
    run load_snotel
    cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts')
    
    % Make vector of years for 'for' loops
        yrs=unique(sumEnv(:,1));
        yearStart=min(yrs);
        yearEnd=max(yrs);
    
        
    % Find peak SWE AND first time no SWE (snow melted)
    peak_SWE=[];
    end_SWE = [];
    Temp=[];
    %for y = yearStart:yearEnd
    for y = yearStart:yearEnd
        for i = 1:length(meanEnv(:,1))
            if meanEnv(i,1)==y                      % For each year make temporary matrix of doy and SWE
                Temp(i,1)=meanEnv(i,2);             % DOY
                Temp(i,2)=SWE(i);                   % SWE
            elseif meanEnv(i,1)<y;
                Temp(i,1)=NaN;
                Temp(i,2)=NaN;
            end
        end
        % peak SWE (snowmelt start date)
        maxSWE=max(Temp(:,2));
        maxSWEyr=find(Temp(:,2)==maxSWE,1,'First');
        peak_SWE = [peak_SWE; y maxSWEyr]; % makes vector of peak SWE
        % Day stop based on SWE going to zero
        %         if yrs(y)==1998 % Since 1998 only has a few months of winter; no growing season
        %             noSWE = [nan];
        %         else
        %             noSWE = find(Temp(:,2)==0,1,'First');
        %             end_SWE = [end_SWE; noSWE-1]; % Vector of first occurance of zero snow for each year and subtract 1 to avoid overlap with premonsoon period
        %         end
        noSWE = find(Temp(:,2)==0,1,'First');
        end_SWE = [end_SWE; noSWE-1];    %Thus end_SWE ends the last day with snow (first day with no snow minus 1)
        Temp = [];
    end
    clear i y
    % Make vector of peak SWE doy from SWE index for concatenated matrix
    peak_SWEdoy=meanEnv(peak_SWE(:,2),2);
    % Make vector of end of SWE doy from end_SWE index for concatenated matrix
    end_SWEdoy=meanEnv(end_SWE(2:end,:),2);
    % replace 1998 values with nan because it wasn't a complete year
    peak_SWE(1,2)=nan;
    peak_SWEdoy(1,1)=nan;
    end_SWE(1,1)=nan;
    end_SWEdoy = [nan;end_SWEdoy];    

    
    % Find start/stop dates for monsoon
    yrs=unique(sumEnv(:,1));
    Temp=[];
    monsoonStart=[];
    monsoonStartDOY=[];
    for i = 1:length(yrs);                     % For each year
        for r = 1:length(sumEnv(:,1));      % For each day of time series
            if sumEnv(r,1)==yrs(i);
                Temp(r,1)=sumEnv(r,1);       % precip column 1 is year
                Temp(r,2)=sumEnv(r,2);       % precip column 2 is doy
                Temp(r,3)=sumEnv(r,4);       % precip column 1 is sum of precip for day
            elseif Year(r)<yrs(i);
                Temp(r,1)=NaN;
                Temp(r,2)=NaN;
                Temp(r,3)=NaN;
            end
        end
        
        % %This finds day of year for each year, but there is also a different
        % %way to do it with monsoonStartDOY is noncommented out script
        %         Temp2=Temp(all(~isnan(Temp),2),:);
        %         rainyDates = find(Temp2(:,3)>precipThresh);    % Find all days greater than precipThresh mm precip
        %         rainyDatesDOY=Temp2(rainyDates,2);
        %         monsoonDates=rainyDatesDOY(find(rainyDatesDOY>167));
        %         monsoonStart(i)=monsoonDates(1,1);
        
        % This finds row number for concatenated matrix
        yearEnd=find(sumEnv(:,1)==yrs(i),1,'First')-1; %Find the last day of each year
        rainyDates = find(Temp(:,3)>precipThresh);    % Find all days greater than precipThresh mm precip
        if yrs(i)==1998 % Since 1998 only has a few months of winter; no growing season
            monsoonStart(i) = [nan];
            monsoonStartDOY=[nan];
        elseif yrs(i)==1999||yrs(i)==2001||yrs(i)==2002||yrs(i)==2003||yrs(i)==2005||yrs(i)==2006||yrs(i)==2007||yrs(i)==2009||yrs(i)==2010||yrs(i)==2011||yrs(i)==2013
            monsoonDate = rainyDates(find(rainyDates>166+yearEnd)); % Find rainy days greater than June 15
            monsoonStart(i)=monsoonDate(1,1);
            monsoonStartDOY=[monsoonStartDOY sumEnv(monsoonStart(i),2)];
        elseif yrs(i)==2000||yrs(i)==2004||yrs(i)==2008||yrs(i)==2012 %leap years
            monsoonDate = rainyDates(find(rainyDates>167+yearEnd)); % Find rainy days greater than June 15
            monsoonStart(i)=monsoonDate(1,1);   % Index for monsoon start
            monsoonStartDOY=[monsoonStartDOY sumEnv(monsoonStart(i),2)];    % day of year for monsoon start
        end
%         % Figure of precip and monsoon start
%         if yrs(i) > 1998
%             figure(i)
%             plot(Temp(:,2),Temp(:,3))
%             title(['monsoon start ',num2str(yrs(i))]);
%             yLimits = get(gca,'YLim');
%             hold on
%             plot(monsoonStartDOY(i),yLimits(1):yLimits(2),'-r','LineWidth',1.5)
%             hold off
%         end
        Temp = [];
    end
    % Year_Monsoon_start=[yrs monsoonStart' monsoonStartDOY']; % Old matrix for use with loadobsanddrivers
    
    
    % Find start date for post-monsoon
    postmonsoonStart=[];
    Temp=[];
    for i = 1:length(yrs);                     % For each year
        for r = 1:length(meanEnv(:,1));      % For each day of time series
            if meanEnv(r,1)==yrs(i);
                Temp(r,1)=sumEnv(r,1);       % meanEnv column 1 is year
                Temp(r,2)=sumEnv(r,2);       % meanEnv column 2 is doy
            elseif Year(r)<yrs(i);
                Temp(r,1)=NaN;
                Temp(r,2)=NaN;
            end
        end
        if yrs(i)==1998 % Since 1998 only has a few months of winter; no growing season
            DateInd = [nan];
            Sept20=[nan];
        elseif yrs(i)==1999||yrs(i)==2001||yrs(i)==2002||yrs(i)==2003||yrs(i)==2005||yrs(i)==2006||yrs(i)==2007||yrs(i)==2009||yrs(i)==2010||yrs(i)==2011||yrs(i)==2013
            DateInd = find(Temp(:,2)==263); % Find Sept 20 non leap years
            Sept20 = Temp(DateInd,2);
        else %yrs(i)==2000||2004||2008||2012 %leap years
            DateInd = find(Temp(:,2)==264); % Find Sept 20 leap years
            Sept20 = Temp(DateInd,2);
        end
        postmonsoonStart(i)=DateInd;
        Temp = [];
    end
    % Make vector of doy for post-monsoon start
    postmonsoonStartdoy=meanEnv(postmonsoonStart(2:end)',2);
    postmonsoonStartdoy=[nan; postmonsoonStartdoy];
    
    
    % Find winter period start dates
    % Initialize vectors
    Temp=[];
    post_monsoon_StopInd=[];
    for i = 1:length(yrs);
        for r = 1:length(meanEnv(:,1));     %For each row of year-subset flux data
            if meanEnv(r,1)==yrs(i);
                Temp(r,1)=meanEnv(r,2);     % DOY
                Temp(r,2)=SWE(r);           % SWE
                Temp(r,3)=meanEnv(r,28);    % column 28 is temperature at 2 m
            elseif meanEnv(r,1)<yrs(i);
                Temp(r,1)=NaN;
                Temp(r,2)=NaN;
                Temp(r,3)=NaN;
            end
        end
        % Winter start based on SWE going 25 mm
        if yrs(i)==1998
            post_monsoon_StopInd(i)=[nan];
        else
        some_SWE = find(Temp(:,2)>=25);           % Find all SWE >= some threshold in mm (25 is about 1 inch)
        some_SWEdoy = Temp(some_SWE,1);
        fall_SWEInd = find(some_SWEdoy>264);       % find SWE >= threshold that are after Sept 20 or Sept 21 (depending on leap year)
        fall_stick_SWE = strfind(diff(fall_SWEInd)',[1 1 1 1 1 1 1])';  % Create index for when SWE >=threhsold several dates in a row after Sept 20/21
        post_monsoon_StopInd(i) = some_SWE(fall_SWEInd(fall_stick_SWE(1))); % this is vector of post-monsoon stop/winter start dates
        end
%         % Figures
%         figure(i)
%         plot(1:length(Temp),Temp(:,2))              % Plot SWE
%         xmin=(i-1)*365;
%         xlim([xmin length(Temp)]);
%         title(num2str(yrs(i)));
%         hold on
%         hold off
        Temp=[];
    end
    % Make vector of post-monsoon stop day of year
    post_monsoon_Stopdoy=meanEnv(post_monsoon_StopInd(2:end)',2);
    post_monsoon_Stopdoy=[nan; post_monsoon_Stopdoy];
    
    % Make matrix of all threshold date (start/stop date) indices and their day of year.
    dateMat=[peak_SWE peak_SWEdoy end_SWE end_SWEdoy monsoonStart' monsoonStartDOY' postmonsoonStart' postmonsoonStartdoy post_monsoon_StopInd' post_monsoon_Stopdoy];
    
    % Export matrix of dates and day of year into tab-delimited file
    outputfilepath = strcat(filepathout,filenameout);
    header = {'%Year','peak_SWE', 'peak_SWE_doy', 'end_SWE', 'end_SWE_doy', 'monsoon_start','monsoon_start_doy','postMonsoonStart', 'postMonsoonStart_doy', 'winterStart', 'winterStart_doy'};
    fid = fopen(outputfilepath, 'w');
    if fid == -1; error('Cannot open file: %s', outfile); end
    fprintf(fid, '%s\t', header{:});
    fprintf(fid, '\n');
    fclose(fid);
    dlmwrite(outputfilepath,dateMat,'-append','delimiter','\t');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Automated 3--Make some graphs%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif Criteria == 11
    % Make a matrix then dataset from data
    data = [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m];
    header = {'Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'};
    dataset1 = dataset({data,header{:}});
    
    % Make a new data column based on year that is ordinal (for concatenated all years file)
    y = min(Year(:));
    Y = max(Year(:));
    labels2 = num2str((y:Y)');
    edges = y:Y+1;
    dataset1.YearOrd = ordinal(dataset1.Year,labels2,[],edges);
    
    % Make a new data column based on DD that is ordinal and without decimal for use with
    % statistics command.  Based on code here: http://www.mathworks.com/help/stats/ordinal.html
    m = floor(min(DecimalDate(:)));
    M = floor(max(DecimalDate(:)));
    labels = num2str((m:M)');
    edges = m:M+1;
    dataset1.Day = ordinal(dataset1.DecimalDate,labels,[],edges);
    
    % Calculate variable means and precip sum for each doy by combination of year, and day of year
    % Based on code here: http://www.mathworks.com/help/stats/grpstats.html#bthgrw_
    MeanEnvds = grpstats(dataset1,{'YearOrd','Day'},'mean','DataVars',{'MO','T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'});
    sumEnvds = grpstats(dataset1,{'YearOrd','Day'},'sum','DataVars',{'precip_mm'});
    sumEnv=double(sumEnvds);
    meanEnv = double(MeanEnvds);
    YearN = meanEnv(:,1:1) + 1997;
    meanEnv(:,1:1) = YearN;
    sumEnv(:,1:1) = YearN;
    
    % Load snotel data
    run load_snotel
    cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts')
    
    yrs=unique(meanEnv(:,1));
    Temp=[];
    for i = 1:length(yrs);                     % For each year
        for r = 1:length(meanEnv(:,1));      % For each day of time series
            if meanEnv(r,1)==yrs(i);
                Temp(r,1)=sumEnv(r,1);       % meanEnv column 1 is year
                Temp(r,2)=sumEnv(r,2);       % meanEnv column 2 is doy
                Temp(r,3)=sumEnv(r,4);       % meanEnv column 1 is sum of precip for day
                Temp(r,4)=meanEnv(r,6);      % sumEnv column 6 is mean relative humidity
                Temp(r,5)=meanEnv(r,28);     % sumEnv column 28 is mean temperature at 8 m
                Temp(r,6)=SWE_DS(r,1);       % SWE column is snow water equivalent
                Temp(r,7)=meanEnv(r,31);     % meanEnv column 31 is soil moisture
                Temp(r,8)=meanEnv(r,13);
            elseif Year(r)<yrs(i);
                Temp(r,1)=NaN;
                Temp(r,2)=NaN;
                Temp(r,3)=NaN;
                Temp(r,4)=NaN;
                Temp(r,5)=NaN;
                Temp(r,6)=NaN;
                Temp(r,7)=NaN;
                Temp(r,8)=NaN;
            end
        end
        
        if yrs(i)==1998 % Since 1998 only has a few months of winter; no growing season
            DateInd = [nan];
            Sept20=[nan];
        elseif yrs(i)==1999||yrs(i)==2001||yrs(i)==2002||yrs(i)==2003||yrs(i)==2005||yrs(i)==2006||yrs(i)==2007||yrs(i)==2009||yrs(i)==2010||yrs(i)==2011||yrs(i)==2013
            DateInd = find(Temp(:,2)==263); % Find Sept 20 non leap years
            Sept20 = Temp(DateInd,2);
        else %yrs(i)==2000||2004||2008||2012 %leap years
            DateInd = find(Temp(:,2)==264); % Find Sept 20 leap years
            Sept20 = Temp(DateInd,2);
        end
        if yrs(i) > 1998
            figure(i)
            plot(Temp(:,2),Temp(:,3))
            hold on
            %     plot(Temp(:,2),Temp(:,4),'-g')
            plot(Temp(:,2),Temp(:,5),'-r')
            plot(Temp(:,2),Temp(:,6),'-k')
            plot(Temp(:,2),Temp(:,7),'-c')
            plot(Temp(:,2),Temp(:,8),'-y')
            title(['Environmental variables ',num2str(yrs(i))]);
            yLimits = get(gca,'YLim');
            plot(Sept20,yLimits(1):yLimits(2),'-r','LineWidth',1.5)
            hold off
            Temp = [];
        end
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Old code for reference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Removed from loadObsAndDrivers.m, so to use in this script would need to
% change matrix names for all below
%
%%%%%%%%%%%%%%%%%%%
% elseif 'neeNeg' for when NEE is negative for a defined consecutive streak then positive for a defined consecutive streak (for growing season)
%
% elseif strcmpi(month,'neeNeg')
%     yrs=unique(yearStart:1:yearEnd);
%     Temp=[];
%     DayStartMat=[];
%     for i = 1:length(yrs);
%         for r = 1:length(subDataYears(:,1)); %For each row of year-subset flux data
%             if subDataYears(r,1)==yrs(i);
%                 Temp(r,1)=subDataYears(r,3);
%                 Temp(r,2)=subDataYears(r,6);
%             end
%         end
%         Startpos = find(Temp(:,2)<0);  % Find negative CO2
%         StartInd = Startpos(strfind(diff(Startpos)',[1 1 1 1])'); %Find four consecutive positions in Startpos
%         Stoppos = find(Temp(:,2)>0);
%         Stoppos2 = Stoppos(find(Stoppos>StartInd(1))); % Day stop greater than daystart, and DayStart= StartInd(1)
%         StopInd = strfind(diff(Stoppos2)',[1 1 1])';
%         DayStartMat(i,1)= [yrs(i)];
%         DayStartMat(i,2)= StartInd(1);
%         DayStartMat(i,3)= Stoppos2(StopInd(1)); % DayStartMat is matrix of year, start date and stop date
%         Temp = [];
%     end
%
%%%%%%%%%%%%%%%%%%%%
% elseif strcmpi(month,'snowmelt')
%     % This is with start date with steepest NEE slope (following Hu 2010)for 'snowmelt' period
%     %This probably only works for daytime measurements.... move to different script?
%     % OR base on SWE max instead of decreasing NEE? 
%     % (Later note: since now this is in a script that uses 24-hour data
%     % instead of half-day data, maybe this would work....see emails and Hu
%     % paper to see if she used half-hour data or 24 hour averages for her
%     % paper).
%     
%     yearlyResults=[];
%     snoMresults=[];
%     Startpos=[];
%     Stoppos = [];
%     for y = yearStart:yearEnd
%         for i = 1:length(subDataYears(:,1))-n
%             for n = 2:8
%                 % for each year, index 3 to 9 day periods then apply regression
%                 if subDataYears(i,1)==y
%                     ind=i:i+n;
%                     fitResult = polyfit(ind',subDataYears(ind,6),1);  %fit linear model
%                     m=fitResult(1);
%                     yearlyResults=[yearlyResults; y n i m];
%                     sortedYR=sortrows(yearlyResults,4);
%                 end
%             end
%             if subDataYears(i,1)==y                 % For each year make temporary matrix of doy and SWE
%                 Temp(i,1)=subDriversYears(i,3);
%                 Temp(i,2)=subDriversYears(i,34);    %column 34 is SWE
%             elseif subDriversYears(i,1)<y;
%                 Temp(i,1)=NaN;
%                 Temp(i,2)=NaN;
%             end
%         end
%         % Get results of regressions for each year
%         snoMresults=[snoMresults;sortedYR(1,:)];
%         yearlyResults=[];
%         % Day stop based on SWE going to zero
%         noSWE = find(Temp(:,2)==0,1,'First');
%         Stoppos = [Stoppos; y noSWE-1]; %Find the first occurance of zero snow for each year and subtract 1 to avoid overlap with premonsoon period
%           % Need to add DayStartMat here
%         Temp = [];
%     end
%     clear i %n y

%%%%%%%%%%%%%%%%%%%
% % Old version of pre-monsoon (before importing monsoon start dates from
% % this script)
% elseif strcmpi(month,'preMonsoon')
%     precipThresh=10;        % Tried 10 mm, which is decent for most years but some years have preMonsoon only a few days long if criteria of after July 10 isn't added
%     yrs=unique(yearStart:1:yearEnd);
%     Temp=[];
%     DayStartMat=[];
%     for i = 1:length(yrs);
%         for r = 1:length(subDriversYears(:,1));     %For each row of year-subset flux data
%             if subDriversYears(r,1)==yrs(i);
%                 Temp(r,1)=subDriversYears(r,3);
%                 Temp(r,2)=subDriversYears(r,34);    %column 34 is SWE
%                 Temp(r,3)=subDriversYears(r,13);    %column 13 is precip
%                 Temp(r,4)=subDriversYears(r,32);    %column 32 is soil h20
%                 Temp(r,5)=subDriversYears(r,28);    %column 28 is temperature at 2 m
%             elseif subDriversYears(r,1)<yrs(i);
%                 Temp(r,1)=NaN;
%                 Temp(r,2)=NaN;
%                 Temp(r,3)=NaN;
%                 Temp(r,4)=NaN;
%                 Temp(r,5)=NaN;
%             end
%         end
%         Startpos(i) = find(Temp(:,2)==0,1,'First'); %Find the first occurance of zero snow for each year
%         Stoppos = find(Temp(:,3)>precipThresh);        % Find all greater than precipThresh mm precip
%         %         Stoppos = find(Temp(:,3)<=max(Temp(:,3)) & Temp(:,3)>
%         %         (0.30*max(Temp(:,3)))); % This approach finds precip events that are some percentage of the peak precip for the year
%         %         Stoppos2 = Stoppos(find(Stoppos>Startpos(i))); % Find Day stop greater than daystart
%         if yrs(i)==2000||2004||2008||2012 %leap years
%             Stoppos2 = Stoppos(find(Stoppos>167+sum(isnan(Temp(:,1))))); % Find Day stop greater than July 10
%         else
%             Stoppos2 = Stoppos(find(Stoppos>166+sum(isnan(Temp(:,1))))); % Find Day stop greater than July 10
%         end
%         Stoppos3(i)=Stoppos2(1,1);                  % Find first day in Stoppos 2 (all occurances)
%         DayStartMat(i,1)= [yrs(i)];
%         DayStartMat(i,2)= Startpos(i);
%         DayStartMat(i,3)= Stoppos3(i);              % DayStartMat is matrix of year, start date and stop date
%         figure(i)
%         plot(1:length(Temp),Temp(:,3))            % This makes plots of SWE and precip for each year for visualization
%         hold on
%         plot(1:length(Temp),Temp(:,2),'r.')
%         plot(1:length(Temp),Temp(:,4).*10,'g-')  % Multiplying soil moisture by 10 so I can see pattern on same axis as SWE and precip
%         plot(1:length(Temp),Temp(:,5),'y-')
%         xmin=(i-1)*365;
%         xlim([xmin length(Temp)]);
%         title(num2str(yrs(i)));
% %         refline(0,precipThresh)
%         plot(Startpos(i),1:18,'m-')             % plot start date for premonsoon
%         plot(Stoppos3(i),1:18,'m-')             % plot stop date for premonsoon
%         hold off
%         Temp = [];
%     end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make figures for monsoon start dates (was part of 'for' look for monsoon
% start/stop dates) 
%
% for i = 1:length(yrs);
%        % Make figures for each year:
%        % This plotting method works, but x axis has the row number
%        % for the day rather than doy
%        figure(i)
%         plot(1:length(Temp),Temp(:,3))              % This makes plots of SWE and precip for each year for visualization
%         hold on
%         xmin=yearEnd;
%         xmax=xmin+366;
%         xlim([xmin xmax]);
%         title(['monsoon start ',num2str(yrs(i))]);
%         % refline(0,precipThresh)
%         yLimits = get(gca,'YLim');
%         plot(monsoonStart(i),yLimits(1):yLimits(2),'-r','LineWidth',1.5)             % plot start date for monsoon
%         hold off
% % This plotting method has x axis as doy.
% end