% load the observations for Niwot Ridge.

% To do:
% 1) Select drivers.  If using data other than flux and climate
% '_allyears_OKflags_daylen_thresh0.5_Day,' then make sure that the columns
% selected as drivers assigned in this script are correct.
% 2) Subset Years that you want to use i
% 3) Set net1.trainParam.showWindow = true (to show extra plots) or false.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loadData=1;     % set to 1: process all obs from scratch
%2: load preprocessed obs
%0: obs already in workspace

if loadData==1
    
   % this will load observations and modeled results
    % from the NACP project for Niwot Ridge
    file=filename{1};
    
    % load the NACP observations and modeled NEE.
    annual_var=importdata(strcat('Annual_DataIn/',file));
%     driversHourly=importdata(strcat('../DataIn/',site,'forcing.txt'));
    
    % set the different driver locations
    % change the names here to give meaningful i.d.'s 
    % (i.e. columns.driver1 to columns.PAR)
    columns.Tmax=2;
    columns.Tmin=3;
    columns.Tmean=4;
    columns.cumPrecip=5;
    columns.cumPPFD=6;
    columns.cumVPD=7;
    columns.SWEmax=8;

    
        %% Pick out subsets of the drivers and the data by year and then by month
% pick out specific years
yearStart = 1999;
yearEnd = 2012;

sub_annual_var_data = zeros(1,size(annual_var.data,2));
counter = 0;
for i=1:length(annual_var.data)
    if annual_var.data(i,1)>=yearStart && annual_var.data(i,1)<=yearEnd
        counter = counter+1;
        sub_annual_var_data(counter,:)=annual_var.data(i,:);
    end
end %of loop through all data

    
    save('Annual_DataTmp/obs')
    
elseif loadData==2
    
    load Annual_DataTmp/obs.mat
end











