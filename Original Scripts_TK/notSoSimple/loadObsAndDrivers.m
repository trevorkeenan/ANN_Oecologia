% Trevor's script to load the observations for Niwot Ridge.
%
% Edited by Loren Albert
%
% To do:
% 1) Check the drivers.  If using data other than flux and climate as
% formatted in '_allyears_OKflags_daylen_thresh0.5_Day,' then make sure 
% that the columns selected as drivers assigned in this script are correct.
% 2) Choose whether to use gap-filled or non-gapfilled (OK) data.
% 3) Choose whether to load daytime or night time data (target automated
% based on this)
% 4) Choose whether to use consecutive or non-consecutive years, and
% start/stop dates, or years to include.  (Make sure yearStart and yearEnd
% are uncommented since they might be from running
% 'run_all_periods_each_year.m')
% 5) Choose which time period to use (month=) for months, ecosystem
% phenology periods, etc.
% 6) Set net1.trainParam.showWindow = true (to show extra plots) or false.
%
% To fix:
% 1) find a way to name the drivers columns structure, ideally using column
% names from ameriflux drivers dataset--Somewhat done
% 2) In second section, find way to adjust day start and stop for leap
% years (may not be necessary if defining growing season based on a
% different criteria, but would be necessary for month-by-month analysis)
% 3) Double check that indices of DayStartMat are selecting day start and
% day stop based on the criteria (make sure they are doing what I think
% they're doing)--Done
% 4) For winter period, it might be useful to add capacity to end winter on
% a year other than the last year of NEEObsMod.  See notes in that section.
% 5) double check whether SWE and precip have gaps (would start/stop dates
% change between gap/non gap filled data?)
%
% Notes:
% The object names subDataYears, subDataMonths, subDriversYears,
% subDriversMonths, are legacies of Trevor's script.  'Years' subsets are
% indeed for years (consecutive or not), but 'months' are now different
% possibilities (months, seasonal periods, all data, etc).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loadData=1;     % set to 1: process all obs from scratch
%2: load preprocessed obs
%0: obs already in workspace

% Choose 1 for night and 2 for day (below can change whether to use GF or OK version)
HD=2; 

% Choose 1 for a set of consecutive years (or single year), 0 for several nonconsecutive years.
year_consecutive=1; 

% Select years (start/end, or specific years) automatic
if year_consecutive==1
    % pick out specific start/stop years (note that when 1998 is included, it is nan (and thus excluded) for all subdatamonths periods)
    yearStart = 1999;
    yearEnd = 2013;
elseif year_consecutive==0
    % pick out specific nonconsecutive years (e.g. wet or dry years) 
    % yearsInclude = [2013]; 
end

%specify which month of data you want
month = 'winter'; %put 'all' if you want all months; 'arb' if you want arbitrary range (specify range below);

% 'snowmelt' for when NEE starts having very negative slope to when SWE becomes zero
% 'preMonsoon' for when SWE becomes zero to start of monsoon;
% 'monsoon' for start of monsoon to start of new snowpack
% 'post-monsoon' for end of monsoon to start of winter
% 'winter' for end of post-monsoon until snowmelt

%% Load data
if loadData==1
    
   % this will load LPA's processed Ameriflux data for Niwot Ridge
    fileOK_day=fileNames{1}; % Use with 'load' for non-gap-filled half-day 'Day' data
    fileGF_day=fileNames{2}; % Use with 'load' for gap-filled half-day 'Day' data
    fileOK_night=fileNames{3}; % Use with 'load' for gap-filled half-day 'night' data
    fileGF_night=fileNames{4}; % Use with 'load' for gap-filled half-day 'night' data
    
    % load the climate observations and modeled NEE.  Set 'fileOK' or 'fileGF'
    if HD==1
        NEEobsMod=importdata(strcat('../DataIn/flux',fileOK_night,'.txt'));
        driversHourly=importdata(strcat('../DataIn/climate',fileGF_night,'.txt'));
    elseif HD==2
        NEEobsMod=importdata(strcat('../DataIn/flux',fileOK_day,'.txt'));
        driversHourly=importdata(strcat('../DataIn/climate',fileGF_day,'.txt'));
    end
    
    % Since my processed Ameriflux data are already half-day averaged, 
    % don't need to do averaging here.  Thus I removed Trevor's 
    % section called 'convert the climate drivers from hourly to daily'
    driversDaily = driversHourly.data;  %This .data command accesses the data (excluding headers)
    
    
    % Set the different driver locations
    % change the names here to give meaningful i.d.'s 
    % (i.e. columns.driver1 to columns.PAR)
    % Note--for my Ameriflux data, columns 1 through 5 are Year, Mo, DD,
    % quantum, and GroupCount.
    
    columns.T21m=6;
    columns.ws21m=9;
    columns.wd21m=10;
    columns.ustar21m=11;
    columns.precipmm=13;
    columns.vpd=15;
    columns.Tsoil=17;
    columns.Rppfdin=21;
    columns.Rnet25=23;
    columns.RH8m=31;
    columns.h2osoil=32; % Soil moisure (column 32) is missing a lot of values
    columns.swe=34;
%     columns.RH2m=30; %This is all nan for 2013
%    columns.prevNEE=35;
%     columns.driver13=36;
%     columns.driver13=35;
%     columns.driver13=36;
%     columns.driver14=37;
%     columns.driver15=38;
 

    %% Subset the drivers and the data by year and then by month

% Loops to subset by year
subDataYears = zeros(1,size(NEEobsMod.data,2));
subDriversYears = zeros(1,size(driversDaily,2));
counter = 0;counter2 = 0;
if year_consecutive==1 %Subset by consecutive years
    for rr=1:length(NEEobsMod.data)
        if NEEobsMod.data(rr,1)>=yearStart && NEEobsMod.data(rr,1)<=yearEnd
            counter = counter+1;
            subDataYears(counter,:)=NEEobsMod.data(rr,:);
            %         subDataYears(rr,:)=NEEobsMod.data(rr,:);
        end
        if driversDaily(rr,1)>=yearStart && driversDaily(rr,1)<=yearEnd
            counter2 = counter2+1;
            subDriversYears(counter2,:)=driversDaily(rr,:);
            %         subDriversYears(rr,:)=driversDaily(rr,:);
        end
    end %of loop through all data
    
elseif year_consecutive==0 %Subset by nonconsecutive years
    for rr=1:length(NEEobsMod.data)
        if any(NEEobsMod.data(rr,1)==yearsInclude)
            counter = counter+1;
            subDataYears(counter,:)=NEEobsMod.data(rr,:);
            %         subDataYears(rr,:)=NEEobsMod.data(rr,:);
        end
        if any(driversDaily(rr,1)==yearsInclude)
            counter2 = counter2+1;
            subDriversYears(counter2,:)=driversDaily(rr,:);
            %         subDriversYears(rr,:)=driversDaily(rr,:);
        end   
    end %of loop through all data
end % of if year_consecutive == 1

% strcmpi command compares strings
% LPA note--maybe monthly option should be adjusted to include leap years?  Add
% something like if yearStart:yearEnd includes leap years, day start and
% stop dates change.
% Check out 'eomday' in matlab
% 365 days for 1999, 2001, 2002, 2003, 2005, 2006, 2007, 2009, 2010, 2011;
% 366 days for 2000, 2004, 2008, 2012; 

% By month
if strcmpi(month,'january')
    dayStart=1;dayStop=31;
elseif strcmpi(month,'february')
    dayStart=32;dayStop=59;
elseif strcmpi(month,'march')
    dayStart=60;dayStop=90;
elseif strcmpi(month,'april')
    dayStart=91;dayStop=120;
elseif strcmpi(month,'may')
    dayStart=121;dayStop=151;
elseif strcmpi(month,'june')
    dayStart=152;dayStop=181;
elseif strcmpi(month,'july')
    dayStart=182;dayStop=212;
elseif strcmpi(month,'august')
    dayStart=213;dayStop=243;
elseif strcmpi(month,'september')
    dayStart=244;dayStop=273;
elseif strcmpi(month,'october')
    dayStart=274;dayStop=304;
elseif strcmpi(month,'november')
    dayStart=305;dayStop=334;
elseif strcmpi(month,'december')
    dayStart=335;dayStop=365;
elseif strcmpi(month,'arb')
    dayStart=198; dayStop=244;
    
% Snow melt
elseif strcmpi(month,'snowmelt') 
    % Import start dates (output from script 'define_start_stop_dates.m').
    filename = '/Users/lpapgm/Dropbox/Niwot Ridge project/NR data/Data output from matlab/start_stop_from_climate_allyears_OKflags.txt';
    delimiterIn = '\t';
    headerlinesIn = 1;
    StartStop = importdata(filename,delimiterIn,headerlinesIn);
    % Initialize vectors
    Startpos=[];
    Stoppos = [];
    if year_consecutive==1
        yrs=unique(yearStart:1:yearEnd);
    elseif year_consecutive==0
        yrs=yearsInclude;
    end
    snowmeltInd=[];
    StartdoyInd=[];
    StopdoyInd=[];
    for y = 1:length(yrs);
        if yrs(y)==1998 % Since 1998 is not a complete year
            StartdoyInd(y)=nan;
            StopdoyInd(y)=nan;
        else
            snowmeltInd(y) = find(StartStop.data(:,1)==yrs(y));
            StartdoyInd(y)=find(subDriversYears(:,1)==yrs(y) & subDriversYears(:,3)==StartStop.data(snowmeltInd(y),3));
            StopdoyInd(y)=find(subDriversYears(:,1)==yrs(y) & subDriversYears(:,3)==StartStop.data(snowmeltInd(y),5));
        end
    end
    % Startpos = StartStop.data(snowmeltInd,2); % Can do it this way if using all data (1998-2012) and wanting index numbers for whole data
    % Stoppos = StartStop.data(snowmeltInd,4);  % Can do it this way if using all data (1998-2012) and wanting index numbers for whole data
    Startpos = StartdoyInd';
    Stoppos = StopdoyInd';
    DayStartMat= [yrs' Startpos Stoppos];  % DayStartMat is matrix of year, start date and stop date


    % Pre-monsoon
elseif strcmpi(month,'preMonsoon')
    % Import pre monsoon start dates from matrix of dates from script 'define_start_stop_dates.m'.
    filename = '/Users/lpapgm/Dropbox/Niwot Ridge project/NR data/Data output from matlab/start_stop_from_climate_allyears_OKflags.txt';
    delimiterIn = '\t';
    headerlinesIn = 1;
    StartStop = importdata(filename,delimiterIn,headerlinesIn);
    % Initialize and define things
    if year_consecutive==1
        yrs=unique(yearStart:1:yearEnd);
    elseif year_consecutive==0
        yrs=yearsInclude;
    end
    premonsoonInd=[];
    StartdoyInd=[];
    StopdoyInd=[];
    for y = 1:length(yrs);
        if yrs(y)==1998 % Since 1998 is not a complete year
            StartdoyInd(y)=nan;
            StopdoyInd(y)=nan;
        else
            premonsoonInd(y) = find(StartStop.data(:,1)==yrs(y));
            StartdoyInd(y)=find(subDriversYears(:,1)==yrs(y) & subDriversYears(:,3)==StartStop.data(premonsoonInd(y),5));
            StopdoyInd(y)=find(subDriversYears(:,1)==yrs(y) & subDriversYears(:,3)==StartStop.data(premonsoonInd(y),7));
        end
    end
    % Startpos = StartStop.data(premonsoonInd,4); % Can do it this way if using all data (1998-2012) and wanting index numbers for whole data
    % Stoppos = StartStop.data(premonsoonInd,6); % Can do it this way if using all data (1998-2012) and wanting index numbers for whole data
    Startpos = StartdoyInd';
    Stoppos = StopdoyInd';
    DayStartMat = [yrs' Startpos+1 Stoppos-1]; % add 1 to startpos to avoid overlap with snowmelt period, substract 1 from Stoppos so that the first rainy day post june 15 is counted as monsoon
    
    
    % Monsoon
elseif strcmpi(month,'monsoon')
    % Import monsoon start dates from matrix of dates from script 'define_start_stop_dates.m'.
    filename = '/Users/lpapgm/Dropbox/Niwot Ridge project/NR data/Data output from matlab/start_stop_from_climate_allyears_OKflags.txt';
    delimiterIn = '\t';
    headerlinesIn = 1;
    StartStop = importdata(filename,delimiterIn,headerlinesIn);
    % Initialize and define things
    if year_consecutive==1
        yrs=unique(yearStart:1:yearEnd);
    elseif year_consecutive==0
        yrs=yearsInclude;
    end
    monsoonInd=[];
    StartdoyInd=[];
    StopdoyInd=[];
    for i = 1:length(yrs);
        if yrs(i)==1998 % Since 1998 is not a complete year
            StartdoyInd(i)=nan;
            StopdoyInd(i)=nan;
        else
            monsoonInd(i) = find(StartStop.data(:,1)==yrs(i));
            StartdoyInd(i)=find(subDriversYears(:,1)==yrs(i) & subDriversYears(:,3)==StartStop.data(monsoonInd(i),7));
            StopdoyInd(i)=find(subDriversYears(:,1)==yrs(i) & subDriversYears(:,3)==StartStop.data(monsoonInd(i),9));
        end
    end
    Startpos = StartdoyInd';
    Stoppos = StopdoyInd';
    %Stoppos = StartStop.data(monsoonInd,8);
    DayStartMat = [yrs' Startpos Stoppos];
    clear i
    
    % Post-monsoon
elseif strcmpi(month,'post-monsoon')
    % Import post monsoon start dates from matrix of dates from script 'define_start_stop_dates.m'.
    filename = '/Users/lpapgm/Dropbox/Niwot Ridge project/NR data/Data output from matlab/start_stop_from_climate_allyears_OKflags.txt';
    delimiterIn = '\t';
    headerlinesIn = 1;
    StartStop = importdata(filename,delimiterIn,headerlinesIn);
    % Initialize vectors
    if year_consecutive==1
        yrs=unique(yearStart:1:yearEnd);
    elseif year_consecutive==0
        yrs=yearsInclude;
    end
    postInd=[];
    StartdoyInd=[];
    StopdoyInd=[];
    for i = 1:length(yrs);
        if yrs(i)==1998 % Since 1998 is not a complete year
            StartdoyInd(i)=nan;
            StopdoyInd(i)=nan;
        else
            postInd(i) = find(StartStop.data(:,1)==yrs(i));
            StartdoyInd(i)=find(subDriversYears(:,1)==yrs(i) & subDriversYears(:,3)==StartStop.data(postInd(i),9));
            StopdoyInd(i)=find(subDriversYears(:,1)==yrs(i) & subDriversYears(:,3)==StartStop.data(postInd(i),11));
        end
    end
    %     Startpos = StartStop.data(premonsoonInd,8); % Can do it this way if using all data (1998-2012) and wanting index numbers for whole data
    %     Stoppos = StartStop.data(premonsoonInd,10); % Can do it this way if using all data (1998-2012) and wanting index numbers for whole data
    Startpos = StartdoyInd';
    Stoppos = StopdoyInd';
    DayStartMat = [yrs' Startpos+1 Stoppos]; % add 1 to startpos to avoid overlap with monsoon period
    
    
    % Winter period
elseif strcmpi(month,'winter')
    % Import winter start dates from matrix of dates from script 'define_start_stop_dates.m'.
    filename = '/Users/lpapgm/Dropbox/Niwot Ridge project/NR data/Data output from matlab/start_stop_from_climate_allyears_OKflags.txt';
    delimiterIn = '\t';
    headerlinesIn = 1;
    StartStop = importdata(filename,delimiterIn,headerlinesIn);     % Note that indices in StartStop start at year 1998 (include ~2months).  This is why I use combination of doy and year with find later in the script
    % Initialize vectors
    winterInd=[];
    StartdoyInd=[];
    StopdoyInd=[];
    % Index method depends upon whether years are consecutive or not
    if year_consecutive ==1
        yrs=unique(yearStart:1:yearEnd);
        for i = 1:length(yrs);
            winterInd(i) = find(StartStop.data(:,1)==yrs(i));
        end
        for i = 1:length(yrs);
            if yrs(i)==1998
                StartdoyInd(i)=nan;
                StopdoyInd(i)=nan;
            elseif yrs(i) == 1999
                StartdoyInd(i)=62; % This should start it at first day of 1999
                StartdoyInd(i+1)=find(NEEobsMod.data(:,1)==yrs(i) & NEEobsMod.data(:,3)==StartStop.data(winterInd(i),11)); %start in fall of prev year (note the i+1)
                StopdoyInd(i)=find(NEEobsMod.data(:,1)==yrs(i) & NEEobsMod.data(:,3)==StartStop.data(winterInd(i),3)); %stop in spring of year i
                disp(['Winter period for 1998 is partial; only includes spring of 1999 part of winter 1998-1999'])
            else
                StartdoyInd(i+1)=find(NEEobsMod.data(:,1)==yrs(i) & NEEobsMod.data(:,3)==StartStop.data(winterInd(i),11)); %start in fall of prev year
                StopdoyInd(i)=find(NEEobsMod.data(:,1)==yrs(i) & NEEobsMod.data(:,3)==StartStop.data(winterInd(i),3)); %stop in spring of year i
            end
        end
        % Note after the 'for' loop, the 'winter period' refers to the period
        % beginning in fall of the previous year, to beginning of spring in
        % current year.  This is annoying because it means calling the final
        % winter by a year we don't have data for yet (because we have the fall
        % data, but not the spring data for whatever the last year is).  So [below] I
        % change the index in the definition for Startpos and Stoppos so that
        % the year refers to the year it was in the FALL.  LATER NOTE: the
        % earlier note was confusing.  By the time DayStartMat is created, a
        % continuous winter period (e.g. Oct-April) is referred to by the year
        % it was in Oct.  This means 2013 winter is not complete because it is
        % the last year of the dataset.
        %
        % Define stop positions for winter (consecutive years)
        % If last year included is last year of dataset, end that year's
        % winter at end of dataset (instead of spring because don't have spring data)
        % If first year (1999 or 1998) is included, stop at first stop date
        % to include 1999 part of winter 1998-1999
        if yearEnd==NEEobsMod.data(end,1) && yrs(1)==1999||yrs(1)==1998
            Stoppos = [StopdoyInd(1:end)'; length(NEEobsMod.data)];
            disp(['Winter period for last year of dataset is partial; only includes fall part of winter 2013-2014'])
        elseif yearEnd~=NEEobsMod.data(end,1) && yrs(1)==1999||yrs(1)==1998
            Last_winterInd = find(StartStop.data(:,1)==yrs(i)+1);
            Year_for_winter_end=yrs(i)+1;
            Last_for_Stoppos =find(NEEobsMod.data(:,1)==Year_for_winter_end & NEEobsMod.data(:,3)== StartStop.data(Last_winterInd,3));
            Stoppos = [StopdoyInd(1:end)'; Last_for_Stoppos];
        elseif yearEnd==NEEobsMod.data(end,1) && yrs(1)~=1999 && yrs(1)~=1998
            Stoppos = [StopdoyInd(2:end)'; length(NEEobsMod.data)];
            disp(['Winter period for last year of dataset is partial; only includes fall part of winter 2013-2014'])
        else
            Last_winterInd = find(StartStop.data(:,1)==yrs(i)+1);
            Year_for_winter_end=yrs(i)+1;
            Last_for_Stoppos =find(NEEobsMod.data(:,1)==Year_for_winter_end & NEEobsMod.data(:,3)== StartStop.data(Last_winterInd,3));
            Stoppos = [StopdoyInd(2:end)'; Last_for_Stoppos];
        end
        % Define start positions for winter
        % For consecutive years that include 1998/1999, need to start at
        % StartdoyInd(1), otherwise start at 2
        if yrs(1)==1999||yrs(1)==1998
            Startpos = StartdoyInd(1:end)';
        else
            Startpos = StartdoyInd(2:end)';
        end
        
        %%% Winter if years NOT consecutive...
    elseif year_consecutive==0
        yrs=yearsInclude;
        for i = 1:length(yrs);
            if yrs(i)==2013
                warning('There is no next year for the last year in the dataset (2013), see notes in winter section')
                % This winter nonconsecutive years code seems to work for all
                % years except 2013 (because there is no last year for
                % 2013).  Since winter 2013 is truncated anyway (does not
                % continue into 2014 since I don't have any 2014 data), I
                % probably won't use 2013 as a nonconsecutive winter period
                % anyway, so not fixing now.  See other notes below too
                % (search 2013)
            else
                winterInd(i) = find(StartStop.data(:,1)==yrs(i));
                next_year(i) = yrs(i)+1;
                next_year_Ind(i) = find(StartStop.data(:,1)==next_year(i));
            end
        end
        % Find start and stop dates, nonconsecutive years
        for i = 1:length(yrs);
            if yrs(i)==1998
                StartdoyInd(i)=nan;
                StopdoyInd(i)=nan;
            elseif yrs(i) == 1999
                StartdoyInd(i)=1; % This should start it in winter 1998, or first day of 1999 depending upon yearStart
                StartdoyInd(i+1)=find(NEEobsMod.data(:,1)==yrs(i) & NEEobsMod.data(:,3)==StartStop.data(winterInd(i),11)); %start in fall of prev year (note the i+1)
                StopdoyInd(i)=find(NEEobsMod.data(:,1)==next_year(i) & NEEobsMod.data(:,3)==StartStop.data(next_year_Ind(i),3)); %stop in spring of year i
                disp(['Winter period for 1998 is partial; only includes spring of 1999 part of winter'])
            else
                StartdoyInd(i+1)=find(NEEobsMod.data(:,1)==yrs(i) & NEEobsMod.data(:,3)==StartStop.data(winterInd(i),11)); %start in fall of prev year
                StopdoyInd(i)=find(NEEobsMod.data(:,1)==next_year(i) & NEEobsMod.data(:,3)==StartStop.data(next_year_Ind(i),3)); %stop in spring of year i
            end
        end
        % Define stop positions for winter for nonconsecutive years
        % Add the stop date for the 1999 part of 1998-1999 winter if 1998
        % OR 1999 are included;
        if yrs(length(yrs))~=NEEobsMod.data(end,1) && yrs(1)==1999||yrs(1)==1998
            winterStop1998doy = StartStop.data(find((StartStop.data(:,1))==1999),3);
            winterStop1998 = find(NEEobsMod.data(:,1)==1999 & NEEobsMod.data(:,3)==winterStop1998doy);
            Stoppos = [winterStop1998; StopdoyInd'];
            % If I ever decide I need 2013 included as a nonconsecutive winter year,
            % fix/finish the two 'elseif' statements below.  The actual bug is above this though
            %elseif yrs(length(yrs))==NEEobsMod.data(end,1) && yrs(1)==1999||yrs(1)==1998
            %winterStop1998doy = StartStop.data(find((StartStop.data(:,1))==1999),3);
            %winterStop1998 = find(NEEobsMod.data(:,1)==1999 & NEEobsMod.data(:,3)==winterStop1998doy);
            %Stoppos = [winterStop1998; StopdoyInd(1:end)'; length(subDriversYears)];
            %disp(['Winter period for last year of dataset is partial; only includes fall part of winter'])
            %elseif yrs(length(yrs))==NEEobsMod.data(end,1) && yrs(1)~=1999 && yrs(1)~=1998
        else
            Last_winterInd = find(StartStop.data(:,1)==yrs(i)+1);
            Year_for_winter_end=yrs(i)+1;
            Last_for_Stoppos =find(NEEobsMod.data(:,1)==Year_for_winter_end & NEEobsMod.data(:,3)== StartStop.data(Last_winterInd,3)); %I think this syntax is correct, but produces empty matrix because subDriversYears is subset that doesn't include last year plus one
            %Stoppos = [StopdoyInd(2:end)'; Last_for_Stoppos];
            Stoppos = [StopdoyInd'];
        end
        % For non-consecutive years that include 1998/1999, need to start at
        % StartdoyInd(1), otherwise start at 2
        if yrs(1)==1999||yrs(1)==1998
            Startpos = StartdoyInd(1:end)';
        else
            Startpos = StartdoyInd(2:end)'; % start at 2 becz Matlab creates a zero in first row due to 'StartdoyInd(i+1)' above (want to start in fall of each year)
        end
    end
    
    if yrs(1)==1999||yrs(1)==1998 % If first year is 1998 or 1999, start with early year 1999 as partial winter for winter 1998
        winteryrs = [1998; yrs'];
        DayStartMat = [winteryrs Startpos+1 Stoppos-1]; % add 1 to startpos to avoid
        % overlap with post-monsoon period, and substract 1 from stoppos to
        % avoid overlap with snowmelt.
        DayStartMat(1,2)=Startpos(1); % Don't need to add 1 to startpos for the first start date in dataset
    else
        winteryrs = yrs';
        DayStartMat = [winteryrs Startpos+1 Stoppos-1]; % add 1 to startpos to avoid
        % overlap with post-monsoon period, and substract 1 from stoppos to
        % avoid overlap with snowmelt.
    end
    
    if yrs(end) == 2013
        DayStartMat(end,3)=Stoppos(end); % Don't need to subtract 1 from stoppos for the last stop date in dataset
    end
end


% Apply the start and stop dates to the 'subDataYears' matrix
if strcmpi(month,'all')
    subDataMonths = subDataYears;
    subDriversMonths = subDriversYears;
elseif strcmpi(month,'january')||strcmpi(month,'february')||strcmpi(month,'march')...
        ||strcmpi(month,'april')||strcmpi(month,'may')||strcmpi(month,'june')||strcmpi(month,'july')...
        ||strcmpi(month,'august')||strcmpi(month,'september')...
        ||strcmpi(month,'october')||strcmpi(month,'november')||strcmpi(month,'december')...
        ||strcmpi(month,'arb')
    subDataMonths = []; subDriversMonths = [];
    for i=1:length(subDataYears)
        if subDataYears(i,3)>=dayStart && subDataYears(i,3)<=dayStop
            subDataMonths=[subDataMonths;subDataYears(i,:)];
        end
        if subDriversYears(i,3)>=dayStart && subDriversYears(i,3)<=dayStop
            subDriversMonths=[subDriversMonths;subDriversYears(i,:)];
        end
    end %of loop through all data
    
    % Use the DayStartMat day starts and stops to subset subDriversYears and
    % subDataYears (all eco_pheno_periods except winter)
elseif strcmpi(month,'neeNeg')||strcmpi(month,'snowmelt')||strcmpi(month,'preMonsoon')||strcmpi(month,'monsoon')||strcmpi(month,'post-monsoon')%||strcmpi(month,'winter')
    subDataMonths = []; subDriversMonths = [];
    for i=1:length(yrs)
        for j=1:length(subDataYears)
            if j>=DayStartMat(i,2) && j<=DayStartMat(i,3)
                subDataMonths=[subDataMonths;subDataYears(j,:)];
            end
            if j>=DayStartMat(i,2) && j<=DayStartMat(i,3)
                subDriversMonths=[subDriversMonths;subDriversYears(j,:)];
            end
        end
    end %of loop through all data
    
    % Because the 'winter' period needs winter data from the early part of
    % the year after yearEnd, subset NEEobsMod/driversDaily instead of
    % subDataYears/subDriversYears (actually I think I could directly subset
    % NEEobsMod and driversHourly for all eco_pheno_periods, since DayStartMat
    % relies upon unique combinations of year and doy...but this might be slower).
    % NOTE: this does not work for nonconsecutive year winters because it
    % loops through 16 times, which is necessary for the consecutive years
    % 'winter' scenario to include the late fall 2013.
elseif strcmpi(month,'winter')
    subDataMonths = []; subDriversMonths = [];
    for i=1:length(DayStartMat)
        for j=1:length(NEEobsMod.data)
            if j>=DayStartMat(i,2) && j<=DayStartMat(i,3)
                subDataMonths=[subDataMonths;NEEobsMod.data(j,:)];
            end
            if j>=DayStartMat(i,2) && j<=DayStartMat(i,3)
                subDriversMonths=[subDriversMonths;driversDaily(j,:)];
            end
        end
    end %of loop through all data
end %of if statement

% % Can delete this if statement if I find a better way to have matrix of
% % start/stop dates for making graphs.
% % Export data into tab-delimited file
% if strcmpi(month,'neeNeg')||strcmpi(month,'snowmelt')||strcmpi(month,'preMonsoon')||strcmpi(month,'monsoon')||strcmpi(month,'post-monsoon')
%     filenameout = strcat(month,'_DayStartMat'); % Output filename
%     filepathout = char('../../../../../NR data/Data output from matlab/'); %directory for output
%     outputfilepath = strcat(filepathout,filenameout);
%     header = {'%Year','start', 'stop'};
%     fid = fopen(outputfilepath, 'w');
%     if fid == -1; error('Cannot open file: %s', outfile); end
%     fprintf(fid, '%s\t', header{:});
%     fprintf(fid, '\n');
%     fclose(fid);
%     dlmwrite(outputfilepath,DayStartMat,'-append','delimiter','\t');
% end

save('../DataTmp/obs')

elseif loadData==2
    
    load ../DataTmp/obs.mat
end

clear i j r y;


