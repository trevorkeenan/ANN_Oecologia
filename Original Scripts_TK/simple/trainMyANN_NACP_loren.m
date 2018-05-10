% this script will...
% 1. Load observation data for Niwot Ridge
%   Data from the NACP project
% 2. Train the ANN using all climate drivers

% Written by T.F. Keenan, March 2013 (keenan_trevor@yahoo.ie)
% Edited by Loren Albert for use with Ameriflux data (Ameriflux data was
% concatenated, matched to flags, and averaged to half days)
% Note: tutorial available with typing nnstart

% First set some flags to control what the script does

loadData=1;  % 1: load all data. 0: don't load data as the data has already been loaded (just to speed things up)
numANNs=10;  % set the number of neural networks you want to train

% set the name of the site (used for reading in data)
fileNames={'_allyears_OKflags_daylen_thresh0.5'} % This works
%fileNames={'_allyears_OKflags_daylen_thresh0.5_Day'}
%siteNames={'US-NR1'}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  1. Load the climate and flux data

% Loren's Code below
if loadData==1
    % this will load observations and modeled results
    % from the NACP project for Niwot Ridge
    file=fileNames{1};
    
    % load the NACP observations and modeled NEE.
    NEEobsMod=importdata(strcat('../DataIn/flux',file,'.txt'));
    driversHourly=importdata(strcat('../DataIn/climate',file,'.txt'));

% Trevor's code below
% if loadData==1
%     % this will load observations and modeled results
%     % from the NACP project for Niwot Ridge
%     site=siteNames{1};
%     
%     % load the NACP observations and modeled NEE.
%     NEEobsMod=importdata(strcat('../DataIn/',site,'_NEE.txt'));
%     driversHourly=importdata(strcat('../DataIn/',site,'forcing.txt'));
%     
%     % convert the climate drivers from hourly to daily
%     % some are half hourly
%     % LPA note: Matlab syntax--1:48:157000 means 1 to 157000 in steps of 48
%     stepSize=48;
%     countx=1;
%     driversDaily=zeros(size(driversHourly.data,1)/stepSize,10);
%     for i =1:stepSize:size(driversHourly.data,1)
%         driversDaily(countx,1:2)=driversHourly.data(i,1:2);
%         driversDaily(countx,3:end)=nanmean(driversHourly.data(i:i+stepSize-1,4:2:end),1); %T-air, windspeed, pressure
%         
%         % LPA note: Every other column is being included-the 4:2:end.  This
%         % works because of the order of columns such that some drivers are
%         % included (CO2 is excluded) and other drivers ignored because they
%         % will be summed next
%         
%         % precip should be sum, not mean
%         driversDaily(countx,6)=nansum(driversHourly.data(i:i+stepSize-1,10),1); %precip
%         driversDaily(countx,8)=nansum(driversHourly.data(i:i+stepSize-1,14),1); %R_global_in
%         driversDaily(countx,9)=nansum(driversHourly.data(i:i+stepSize-1,16),1); %R_longwave_in
%         
%         countx=countx+1;
%     end
%     
%     % remove the first year of
%     % the NR modeled data (no measurements)
%     NEEobsMod.data=NEEobsMod.data(366:end,:);
%     
% end

NEEobsMod.data=NEEobsMod; %This also makes NEEobsMod into a 'structure' but generates a warning and will generate an error in future versions.  See page 3-5 of Matlab version 7.0.4 release notes
%NEEobsMod.data=NEEobsMod(366:end,:); %Same as above but excludes year 1998
%NEEobsModStruct = struct; %Something like this and line below might work if the line above stops working in a future version
%NEEobsModStruct.data = NEEobsMod;

driversDaily = driversHourly; %Processed Ameriflux data is already half-day averaged
end

%%  1b. Pick out subsets of the drivers and the data by year and then by month
% pick out specific years
yearStart = 1999;
yearEnd = 2012;
%specify which month of data you want
month = 'all'; %put 'all' if you want all months; 'arb' if you want arbitrary range (specify range below)

subDataYears = zeros(1,size(NEEobsMod.data,2));
subDriversYears = zeros(1,size(driversDaily,2));
for i=1:length(NEEobsMod.data)
    if NEEobsMod.data(i,1)>=yearStart && NEEobsMod.data(i,1)<=yearEnd
        subDataYears(i,:)=NEEobsMod.data(i,:);
    end
    if driversDaily(i,1)>=yearStart && driversDaily(i,1)<=yearEnd
        subDriversYears(i,:)=driversDaily(i,:);
    end
    
end %of loop through all data

% strcmpi command compares strings
% LPA note--maybe this should be adjusted to include leap years?
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
    dayStart=121; dayStop=181;
end

if strcmpi(month,'all')
    subDataMonths = subDataYears;
    subDriversMonths = subDriversYears;
else
    subDataMonths = []; subDriversMonths = [];
    for i=1:length(subDataYears)
        if subDataYears(i,2)>=dayStart && subDataYears(i,2)<=dayStop
            subDataMonths=[subDataMonths;subDataYears(i,:)];
        end
        if subDriversYears(i,2)>=dayStart && subDriversYears(i,2)<=dayStop
            subDriversMonths=[subDriversMonths;subDriversYears(i,:)];
        end
    end %of loop through all data
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  2. TRAIN THE ANN ON THE DATA

% set what met data is used for the ANN
% to change the drivers used, simply change here
%annDrivers = driversDaily(:,3:10)'; %LPA note--this takes all rows, columns 3 to 10. The ' means transpose
%annDrivers = subDriversMonths(:,3:10)'; %use all drivers
annDrivers = subDriversMonths(:,[6,17,29])'; %Choose subset of drivers (LPA edited)
%annDrivers = subDriversMonths(:,6)'; %Choose subset of drivers (LPA edited)

% set what the ANN is trained to
%targets = NEEobsMod.data(:,3)';
targets = subDataMonths(:,5)'; %column 5 for processed Ameriflux data (LPA edited)

% set all missing data to NaN
% Note, in Trevor's original script, introducing Nans by the following
%     targets(targets==0.4840)=NaN; This is just to test 
%     sum(isnan(targets))
% Did not seem to cause any errors.
annDrivers(annDrivers==-999)=NaN;
annDrivers(annDrivers==-9999)=NaN;
targets(targets==-9999)=NaN;
targets(targets==-999)=NaN;

% Create a Fitting Network
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample

training=70; % 70
validating=15; % 15
testing=15; % 15

net.divideParam.trainRatio = training/100;
net.divideParam.valRatio = validating/100;
net.divideParam.testRatio = testing/100;

% For help on training function 'trainlm' type: help trainlm
% For a list of all training functions type: help nntrain
net.trainFcn = 'trainlm';  % Levenberg-Marquardt

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean squared error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist',...
    'plotregression', 'plotfit'};

net.trainParam.epochs = 50;
net.trainParam.goal = 0.001;

% it's usually a good idea to
% train more than one neural network
% and select the network with the best performance

for ii=1:numANNs %numANNs set above
    [net,tr] = train(net,annDrivers,targets);
    outputs = net(annDrivers);
    
    errors = gsubtract(targets,outputs);
    performance = perform(net,targets,outputs);
    
    % Recalculate Training, Validation and Test Performance
    % LPA note: see help trainMask
    trainTargets = targets .* tr.trainMask{1}; % .* is for matrix multiplication
    valTargets = targets  .* tr.valMask{1};
    testTargets = targets  .* tr.testMask{1};
    trainPerformance = perform(net,trainTargets,outputs);
    valPerformance = perform(net,valTargets,outputs);
    testPerformance(ii) = perform(net,testTargets,outputs);
    
    outputs1(ii,:) = outputs;
    clear outputs train errors performance trainTargets valTargets testTargets
    clear trainPerformance valPerformance
end


% use output from the best performing network

best=find(testPerformance==min(testPerformance));

outputs=outputs1(best,:);



ANN_NEE{1}=outputs;

%% Plot
figure1=figure;

% Create axes
axes1 = axes('Parent',figure1,'FontSize',16);
hold(axes1,'all');
plot(targets,'Marker','.','Color',[0 0 0],'LineStyle','none','DisplayName','Obs')
plot(outputs,'Marker','.','Color',[.4 0.97 0.95],'LineStyle','none','DisplayName','ANN')
xlabel(strcat('Half-days since January 1, ',num2str(yearStart)))
%xlabel('Day since start')
%xlabel('Half-Days Starting in January 1999')
ylabel('Net Ecosystem Exchange')
ylim([-11 7]);
l1=legend(axes1,'show');

% % Example for how to save an ANN
% %save('example1.mat','outputs1') %This saves the variable 'outputs1'
% save('example1.mat') %This saves all workspace variables, but file is kinda large (12.7 MB)
% load example1.mat
