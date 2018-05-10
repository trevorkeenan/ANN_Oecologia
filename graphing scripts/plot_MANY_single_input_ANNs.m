% Extract and plot single-input ANNs
%
% Loren Albert, spring 2014
%
% This code will use a cell array of nets in the workspace.  It extracts 
% and plots the average response (output) versus the single input for many 
% ANNs.  Goal is to get smoother curves, and show standard error.  Adapted
% from plot_single_input_ANN.  Runs within many_OneDriver_forPlot

% To do: 
% 1) change name of net (net, net1, etc) for all the structure names in
% code if necessary. (Currently set up for use with neuralNet_OneDriver.m, with
% oneDriverNet)
% 2) Make sure necessary parts are in workspace (net, inuts...targets might
% also be useful for a comparison)
% 3) This script is run within 'many_OneDriver_forPlots' so check options
% there if necessary.
%
% To fix:
% 1) If I want to use consistent_x_ax == 1 (set in many_OneDriver_forPlot),
% then I need to double check the hard-coded axis limits (see comments that
% say 'check...then uncomment').  (Do the check when HD = 1 and
% seasonal period = 'all' with consecutive years 1999-2013, or look directly
% at the data before season & year subsetting).
%
% Notes:
% 'net1' in neuralNet_OneDriver script (and I think
% neuralNet_bestPlusOneDriver) sets up the architecture of the network, but
% is empty in places.  The 'net' object is actually trained (weight
% matrices filled, etc.)
% Useful link: http://stackoverflow.com/questions/19910982/matlab-fill-area-between-lines
% http://stackoverflow.com/questions/6245626/matlab-filling-in-the-area-between-two-sets-of-data-lines-in-one-figure

%% Loop through each of the single driver model runs 
% (note: PlotNumRuns set in many_OneDriver_forPlots)

% initialize matrix for ANN predictions (each row = predictions for a set
% number of points (pts) for one ANN)
pts = 300; % Define some number of x points for ANN predictions
each_response_y = zeros(length(oneDriverNets), pts);

for ppp = 1:length(oneDriverNets)

% Assign a new name to the net of interest in the workspace (currently set
% up to run with oneDriverNets from plot_MANY_single_input_ANNs
plot_net=oneDriverNets{ppp,1};
%plot_net=oneDriverNets{1,1};


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
% (don't want to do this for 100 models, so choose ppp == #) to check one
% or two
if ppp == 3
figure('Name','equation test')
net_outputs = sim(plot_net,inputs);
plot(net_equation_test,net_outputs)
end

% Make array of all ANN predictions (for averaging and standard dev.)
response_x = linspace(in_min,in_max,pts);
response_x_squashed = mapminmax(response_x);
first_layer_response = tansig(W1*response_x_squashed+B1*ones(1,size(response_x_squashed,2)));
second_layer_response = W2*first_layer_response+B2;
each_response_y(ppp,:) = mapminmax('reverse',second_layer_response,ts);

end

%% Calculate average of all ANN predictions, and standard deviation 
% (NEE version)
if TAR ==0
    if response_NEE == 1
        ave_response_y = mean(each_response_y,1);
        std_response_y = std(each_response_y,0,1); %The zero is a 'flag' command, see matlab documentation
        upper_std_response_y = ave_response_y+std_response_y;
        lower_std_response_y = ave_response_y-std_response_y;
    % (NEP version)    
    elseif response_NEE == 0
        NEP_ave_response_y = -1*mean(each_response_y,1);
        NEP_std_response_y = std(each_response_y,0,1); %The zero is a 'flag' command, see matlab documentation; std should be the same for NEP and NEE (no need for *-1)
        NEP_upper_std_response_y = NEP_ave_response_y+NEP_std_response_y;
        NEP_lower_std_response_y = NEP_ave_response_y-NEP_std_response_y;
    end
    % (H2O flux version; same as NEE version becz. not multiplied by -1)
elseif TAR==1
    ave_response_y = mean(each_response_y,1);
    std_response_y = std(each_response_y,0,1); %The zero is a 'flag' command, see matlab documentation
    upper_std_response_y = ave_response_y+std_response_y;
    lower_std_response_y = ave_response_y-std_response_y;
end
    %% Plot targets with ANN response function
    PlotSingleInfig = figure;
    
    % Add standard deviations
    % Note: this part makes lines for SD, later 'area' command fills between
    % upper and lower SD
    % (NEE version)
    if TAR ==0
        if response_NEE == 1
            Hupper_SDinANN = plot(response_x,upper_std_response_y,'-');
            hold on
            Hlower_SDinANN = plot(response_x,lower_std_response_y,'-');
            
            % Add shaded area between standard deviations
            shadearea=[lower_std_response_y; (upper_std_response_y-lower_std_response_y)]';
            Harea=area(response_x,shadearea);
            
            % Add targets (observed data)
            HpsinT = plot(inputs,targets,'o');
            
            % Add ANN function
            HpsinANN = plot(response_x,ave_response_y,'-');
            hold off
            
            % (NEP version)
        elseif response_NEE == 0
            Hupper_SDinANN = plot(response_x,NEP_upper_std_response_y,'-');
            hold on
            Hlower_SDinANN = plot(response_x,NEP_lower_std_response_y,'-');
            
            % Add shaded area between standard deviations
            shadearea=[NEP_lower_std_response_y; (NEP_upper_std_response_y-NEP_lower_std_response_y)]';
            Harea=area(response_x,shadearea);
            
            % Add targets (observed data)
            HpsinT = plot(inputs,-1*targets,'o');
            
            % Add ANN function
            HpsinANN = plot(response_x,NEP_ave_response_y,'-');
            hold off
        end
        
        % (H2O flux version; same as NEE version becz. not multiplied by -1)
    elseif TAR ==1
        Hupper_SDinANN = plot(response_x,upper_std_response_y,'-');
        hold on
        Hlower_SDinANN = plot(response_x,lower_std_response_y,'-');
        
        % Add shaded area between standard deviations
        shadearea=[lower_std_response_y; (upper_std_response_y-lower_std_response_y)]';
        Harea=area(response_x,shadearea);
        
        % Add targets (observed data)
        HpsinT = plot(inputs,targets,'o');
        
        % Add ANN function
        HpsinANN = plot(response_x,ave_response_y,'-');
        hold off
    end
    
    % Add axis labels and define limits
    % Get the variable name for the column number for the input driver
    psin_fns=fieldnames(columns); % Get field names
    psin_input_dr = psin_fns(struct2array(columns)==driverIndex);
    % Get the name with units for the driver, and define X limits based on
    % nighttime (HD ==1) and daytime (HD ==2)
    if strcmpi(psin_input_dr,'h2osoil')
        X_Label='Soil moist. (m^3 m^-^3)';
        if consistent_x_ax == 1
            if HD ==1             % Check these nighttime min/max now that 2013 is included, then uncomment
%                 xlim_min = 0.04;
%                 xlim_max = 0.59;
            elseif HD ==2
                xlim_min = 0.04;
                xlim_max = 0.59;
            end
        elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'Tsoil')
        X_Label='Soil temp. (\circC)';
        if consistent_x_ax == 1
            if HD ==1               % Check these nighttime min/max now that 2013 is included,  then uncomment
%                 xlim_min = -4.2;
%                 xlim_max = 12.8;
            elseif HD ==2
                xlim_min = -8;
                xlim_max = 14.85;
            end
        elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'T21m')
        X_Label='Air temp. (\circC)';
        if consistent_x_ax == 1
            if HD ==1            % Check these nighttime min/max now that 2013 is included,  then uncomment
%                 xlim_min = -29.83;
%                 xlim_max = 17.55;
            elseif HD ==2
                xlim_min = -29.2;
                xlim_max = 21.34;
            end
        elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'vpd')
        X_Label='VPD (kPa)';
        if consistent_x_ax == 1
            if HD ==1            % Check these nighttime min/max now that 2013 is included,  then uncomment
%                 xlim_min = 0;
%                 xlim_max = 1.67;
            elseif HD ==2
                xlim_min = 0;
                xlim_max = 2.12;
            end
        elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'Rnet25')
        X_Label='Net rad. (W m^-^2)';
        if consistent_x_ax == 1
            if HD ==1
                warning('still need to set consistent x axis limits in plot_many_single_input_ANNs')
            elseif HD ==2
                xlim_min = -30;
                xlim_max = 493;
            end
        elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'ustar21m')
        X_Label='U^* (m s^-^1)';
        if consistent_x_ax == 1
            if HD ==1
                warning('still need to set consistent x axis limits in plot_many_single_input_ANNs')
            elseif HD ==2
                xlim_min = .033;
                xlim_max = 2.89;
            end
        elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'swe')
        X_Label='SWE (mm)';
        if consistent_x_ax == 1
            if HD ==1           % Check these nighttime min/max now that 2013 is included,  then uncomment
                xlim_min = 0;
                xlim_max = 455;
            elseif HD ==2
                xlim_min = 0;
                xlim_max = 455;
            end
        elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'wd21m')
        X_Label= 'Wind dir. (deg. from N)';
        if consistent_x_ax == 1
            if HD ==1
                warning('still need to set consistent x axis limits in plot_many_single_input_ANNs')
            elseif HD ==2
                xlim_min = 0; %min is 12;
                xlim_max = 360; %max is 337;
            end
        elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'RH2m')
        X_Label='Rel. Humidity';
        if consistent_x_ax == 1
            warning('still need to set consistent x axis limits in plot_many_single_input_ANNs')
        elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'RH8m')
        X_Label='Rel. Humidity 8m';
        if consistent_x_ax == 1
            if HD ==1
            warning('still need to set consistent x axis limits in plot_many_single_input_ANNs')
            elseif HD ==2
                xlim_min = 4.8;
                xlim_max = 100;
            end
            elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'precipmm')
        X_Label='Precip (mm)';
        if consistent_x_ax == 1
            if HD ==1
            warning('still need to set consistent x axis limits in plot_many_single_input_ANNs')
            elseif HD ==2
                xlim_min = 0;
                xlim_max = 95;
            end
            elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'ws21m')
        X_Label='Wind speed (m^-^s)';
        if consistent_x_ax == 1
            if HD ==1
                warning('still need to set consistent x axis limits in plot_many_single_input_ANNs')
            elseif HD ==2
                xlim_min = 0;
                xlim_max = 20;
            end
        elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'Rppfdin')
        X_Label='In. PAR (\mumol m^-^2 s^-^1)';
        if consistent_x_ax == 1
            if HD ==1
                warning('still need to set consistent x axis limits in plot_many_single_input_ANNs')
            elseif HD ==2
                xlim_min = 12;
                xlim_max = 1300;
            end
        elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    elseif strcmpi(psin_input_dr,'prevNEE')
        X_Label='Previous NEE (\mumol m^-^2 s^-^1)';
        if consistent_x_ax == 1
            if HD ==1          % Check these nighttime min/max now that 2013 is included,  then uncomment
%                 xlim_min = -11.64;
%                 xlim_max = 3.03;
            elseif HD ==2
                xlim_min = -0.43;
                xlim_max = 6.65;
            end
        elseif consistent_x_ax == 0
            xlim_min = in_min;
            xlim_max = in_max;
        end
    end
    
    % Define Y limits based on whether night or day and whether NEE or NEP
    % or H2O flux.
    % (NEE version)
    if TAR ==0
        if response_NEE == 1
            if HD == 1
                ylim_min = -0.42;
                ylim_max =6.7;
            elseif HD ==2
                ylim_min = -10.85;
                ylim_max = 3.25;
            end
            % (NEP version)
        elseif response_NEE == 0
            if HD == 1
                ylim_min = -6.7;
                ylim_max = 0.42;
            elseif HD ==2
                ylim_min = -3.25;
                ylim_max = 10.85;
            end
        end
        % (H2O flux version)
    elseif TAR ==1
        if HD == 1
            ylim_min = -0.6;
            ylim_max = 3.5;
        elseif HD ==2
            ylim_min = 0;
            ylim_max = 5;
        end
    end
    % finally add labels and limits
    xlabel(X_Label,'FontName',fname,'Fontsize',fsize)
    if TAR ==0
        if response_NEE == 1
            ylabel('NEE','FontName',fname,'Fontsize',fsize)
        elseif response_NEE == 0
            ylabel('NEP','FontName',fname,'Fontsize',fsize)
        end
    elseif TAR ==1
        ylabel('H_2O flux (mmol m^{-2} s^{-1})','FontName',fname,'Fontsize',fsize)
    end
    xlim([xlim_min xlim_max])
    ylim([ylim_min ylim_max])
    
    
    % Add label for month and day/night
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*95;  %Position label 94% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    if HD == 1
        if strcmpi(month,'all') %if month = 'all' change to 'all periods'
            text(psin_txt_x,psin_txt_y,strcat('all periods',' nighttime'),...
                'FontSize',fsizeMed);
        else
            text(psin_txt_x,psin_txt_y,strcat(month,' nighttime'),...
                'FontSize',fsizeMed);
        end
    elseif HD == 2
        if strcmpi(month,'all') %if month = 'all' change to 'all periods'
            text(psin_txt_x,psin_txt_y,strcat('all periods',' daytime'),...
                'FontSize',fsizeMed);
        else
            text(psin_txt_x,psin_txt_y,strcat(month,' daytime'),...
                'FontSize',fsizeMed); % can use 'title' command or simply text for title
        end
    end
    
    % Adjust line and point properties
    set(HpsinT                          , ...   % Targets (observed daytime/nighttime averages)
        'Marker'          , 'o'           , ...
        'MarkerSize'      , 5             , ...
        'MarkerEdgeColor' , 'none'        , ...
        'MarkerFaceColor' , [.43 .43 .43]  );     % average ANN prediction
    set(HpsinANN                        , ...
        'LineWidth'       , 3             , ...
        'Color'           , [0 0 0]  );
    set(Hupper_SDinANN                  , ...   % Upper SD line (probably want to match area color betw. upper & lower SD)
        'LineWidth'     , 2             , ...
        'Color'         , [.87 .87 .87]  );
    set(Hlower_SDinANN                  , ...   % Lower SD line (probably want to match area color betw. upper & lower SD)
        'LineWidth'     , 2             , ...
        'Color'         , [.87 .87 .87]  );
    set(Harea(1),'FaceColor','none');           % Area below lower SD?
    set(Harea(2),'FaceColor',[.87 .87 .87]);       % Area between upper and lower SD
    set(Harea,'LineStyle', 'none')              % Line around shape
    
    % Adjust axes properties
    set(gca, ...
        'Box'         , 'off'     , ...
        'TickDir'     , 'out'     , ...
        'TickLength'  , [.02 .02] , ...
        'LineWidth'   , 1         , ...
        'FontSize',fsizeMed);
    
    % Set size in pixels
    %set(gcf, 'Position', [1 1 800 600]); % This should set size in pixels.
    %For some reason, having both this command and the set(gcf...) command
    %under 'Save figures' causes the eps to be cut-off (when .eps opened)
    
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
            
        else
            if HD == 1
                psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month,'Night',num2str(counter));
            elseif HD == 2
                psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month,'Day_',num2str(counter));
            end
        end
        %     % Include nonconsecutive years in title
    elseif year_consecutive==0
        if exist('eco_pheno_periods','var') %If looping through all eco pheno periods, 'month' is a cell
            if HD == 1
                psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month{1},'Night_',num2str(yearsInclude),'_',num2str(counter));
            elseif HD == 2
                psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month{1},'Day_',num2str(yearsInclude),'_',num2str(counter));
            end
            %print(PlotSingleInfig,'-depsc',psinFname); %I'm not sure what's different between depsc and depsc2
        else
            if HD == 1
                psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month,'Night_',num2str(yearsInclude),'_',num2str(counter));
            elseif HD == 2
                psinFname=strcat('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs/',month,'Day_',num2str(yearsInclude),'_',num2str(counter));
            end
        end
    end
    print(PlotSingleInfig,'-depsc',psinFname); %I'm not sure what's different between depsc and depsc2
    savefig(psinFname)
    

%% Declutter workspace
clear psinFname pts W1 W2 B1 B2 psin_ymax psin_ymin ph msg xlim_max xlim_min