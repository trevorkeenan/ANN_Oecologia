% Extract and plot single-input ANNs
%
% Loren Albert, spring 2014
%
% This code will use a net in the workspace.  It extracts and plots the
% response (output) versus the single input.

% To do: 
% 1) change name of net (net, net1, etc) for all the structure names in
% code. (Currently set up for use with neuralNet_OneDriver.m, with
% oneDriverNet)
% 2) Make sure necessary parts are in workspace (net, inuts...targets might
% also be useful for a comparison)
%
% Notes:
% 'net1' in neuralNet_OneDriver script (and I think
% neuralNet_bestPlusOneDriver) sets up the architecture of the network, but
% is empty in places.  The 'net' object is actually trained (weight
% matrices filled, etc.)

%% Changeable options

% Assign a new name to the net of interest in the workspace (currently set
% up to run with oneDriverNet{best,1} from for loop in neuralNet_OneDriver.m).  
% Could probably use ANNs in 'oneDriverBestNet' as well.
% plot_net=net;
plot_net=oneDriverNet{best,1};


%% Learn about the ANN

% Double check transfer functions
plot_net.layers{1}.transferFcn
plot_net.layers{2}.transferFcn

% Double check number of layers
plot_net.numLayers
plot_net.numInputs

% Double check number of inputs


%% Extract weights and biases from Matlab net
W1 = plot_net.IW{1,1};
W2 = plot_net.LW{2,1};
B1 = plot_net.b{1};
B2 = plot_net.b{2};

%% Scale data from -1 to 1 (for tansig) for use with ANN equation
in_min = min(inputs);   % Just to check, and for use in figures
in_max = max(inputs);   % Just to check, and for use in figures
[in_squashed,PS] = mapminmax(inputs);

%% Put together pieces to make net equation
first_layer = tansig(W1*in_squashed+B1*ones(1,size(inputs,2)));
net_equation=W2*first_layer+B2;

%% Reverse the processing from -1 to 1 to scale to min and max of targets
[target_squashed,ts] = mapminmax(targets);
net_equation_test = mapminmax('reverse',net_equation,ts);

%% Make sure net equation outputs match outputs given by matlab
figure('Name','equation test')
net_outputs = sim(plot_net,inputs);
plot(net_equation_test,net_outputs)

%% (Optional) plot targets vs. outputs
% figure('Name','quick look target vs. outputs')
% plot(inputs,targets,'ro')
% hold on
% plot(inputs,net_equation_test,'o')
% hold off

%% Plot targets with ANN response function
%figure('Name','ANN function')
PlotSingleInfig = figure;
HpsinT = plot(inputs,targets,'o');

% Add title (optional... note that oecologia doesn't want titles)
% psin_title=strcat('ANN function ',driversHourly.colheaders(driverIndex));
% title(psin_title)

% Add ANN function
hold on
pts = 300;
response_x = linspace(in_min,in_max,pts);
response_x_squashed = mapminmax(response_x);
first_layer_response = tansig(W1*response_x_squashed+B1*ones(1,size(response_x_squashed,2)));
second_layer_response = W2*first_layer_response+B2;
response_y = mapminmax('reverse',second_layer_response,ts);
HpsinANN = plot(response_x,response_y,'-');
hold off

% Add axis labels and define limits
% Want the variable name for the column number for the input driver
psin_fns=fieldnames(columns); % Get field names
psin_input_dr = psin_fns(struct2array(columns)==driverIndex); 
ylabel('NEE','FontName',fname,'Fontsize',fsize)
xlabel(psin_input_dr,'FontName',fname,'Fontsize',fsize)
% psin_ymin = -0.5;
% psin_ymax = 2;
% ylim([psin_ymin psin_ymax]) %Could set y limits

% Add label for month and day/night
% First figure out consistent x and y coordinates to get text in upper left
% psin_txt_y = 9*(((psin_ymax-psin_ymin)/20)*(psin_ymax-psin_ymin));
% psin_txt_x = ((max(xlim)-min(xlim))/20)*max(xlim)-min(xlim);
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/10)*9;  %Position label 90% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
if HD == 1
    text(psin_txt_x,psin_txt_y,strcat(month,' Night time'),...
        'FontSize',fsizeMed);
elseif HD == 2
    text(psin_txt_x,psin_txt_y,strcat(month,' Day time'),...
        'FontSize',fsizeMed); % can use 'title' command or simply text for title
end

% Adjust line and point properties
set(HpsinT                          , ...
  'Marker'          , 'o'           , ...
  'MarkerSize'      , 4             , ...
  'MarkerEdgeColor' , 'none'        , ...
  'MarkerFaceColor' , [.6 .6 .6]  );
set(HpsinANN                        , ...
  'LineWidth'       , 3             , ...
  'Color'           , [0 0 0]  );

% Adjust axes properties
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'LineWidth'   , 1         );

% Save figures
set(gcf, 'PaperPositionMode', 'auto');
% Could add yearStart and yearEnd to the file names for year_consecutive ==1
if year_consecutive==1
    if exist('eco_pheno_periods','var') %If looping through all eco pheno periods, 'month' is a cell
        if HD == 1
            psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month{1},'Night',num2str(counter));
        elseif HD == 2
            psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month{1},'Day',num2str(counter));
        end
        print(PlotSingleInfig,'-depsc',psinFname); %I'm not sure what's different between depsc and depsc2
    else
        if HD == 1
            psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month,'Night',num2str(counter));
        elseif HD == 2
            psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month,'Day',num2str(counter));
        end
        print(PlotSingleInfig,'-depsc',psinFname); %I'm not sure what's different between depsc and depsc2
    end
%     % Include nonconsecutive years in title
elseif year_consecutive==0
    if exist('eco_pheno_periods','var') %If looping through all eco pheno periods, 'month' is a cell
        if HD == 1
            psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month{1},'Night_',num2str(yearsInclude),'_',num2str(counter));
        elseif HD == 2
            psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month{1},'Day_',num2str(yearsInclude),'_',num2str(counter));
        end
        print(PlotSingleInfig,'-depsc',psinFname); %I'm not sure what's different between depsc and depsc2
    else
        if HD == 1
            psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month,'Night_',num2str(yearsInclude),'_',num2str(counter));
        elseif HD == 2
            psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month,'Day_',num2str(yearsInclude),'_',num2str(counter));
        end
        print(PlotSingleInfig,'-depsc',psinFname); %I'm not sure what's different between depsc and depsc2
    end
end
    


% Declutter workspace
clear psinFname pts W1 W2 B1 B2 psin_ymax psin_ymin