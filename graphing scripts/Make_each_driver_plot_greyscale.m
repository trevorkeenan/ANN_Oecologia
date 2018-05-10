%% Make greyscale plot for 'one-drivers' (single drivers)

% Notes:
% 1) See stackoverflow post: https://stackoverflow.com/questions/26965856/rotating-labels-and-superscript-in-matlab
% 2) The commented out code at bottom shows how to make the figure in
% default blue, based on Trevor's code (for reference).

% start figure
scrsz = get(0,'ScreenSize');
figure1 =figure('Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)/2.5]);

% make string of Xtick names (this is slow, so can comment out when not needed)
% XTL_prim=orderedDriver(:) If for loop defining XTL_prim is commented out, uncomment this
tmp1=orderedDriver(:);
XTL_prim={};
for z = 1:length(tmp1)
    if strcmpi(tmp1(z),'h2osoil')
        XTL_prim{z}='Soil moist. (m^3 m^-^3)';
    elseif strcmpi(tmp1(z),'Tsoil')
        XTL_prim{z}='Soil temp. (\circC)';
    elseif strcmpi(tmp1(z),'T21m')
        XTL_prim{z}='Air temp. (\circC)';
    elseif strcmpi(tmp1(z),'vpd')
        XTL_prim{z}='VPD (kPa)';
    elseif strcmpi(tmp1(z),'Rnet25')
        XTL_prim{z}='Net rad. (W m^-^2)';
    elseif strcmpi(tmp1(z),'ustar21m')
        XTL_prim{z}='U^* (m s^-^1)';
    elseif strcmpi(tmp1(z),'swe')
        XTL_prim{z}='SWE (mm)';
    elseif strcmpi(tmp1(z),'wd21m')
        XTL_prim{z}= 'Wind dir. (deg. from N)';
    elseif strcmpi(tmp1(z),'RH2m')
        XTL_prim{z}='Rel. Humidity';
    elseif strcmpi(tmp1(z),'RH8m')
        XTL_prim{z}='Rel. Humidity 8m';
    elseif strcmpi(tmp1(z),'precipmm')
        XTL_prim{z}='Precip (mm)';
    elseif strcmpi(tmp1(z),'ws21m')
        XTL_prim{z}='Wind speed (m^-^s)';
    elseif strcmpi(tmp1(z),'Rppfdin')
        XTL_prim{z}='In. PAR (\mumol m^-^2 s^-^1)';
    elseif strcmpi(tmp1(z),'prevNEE')
        XTL_prim{z}='Prev. NEE (\mumol m^-^2 s^-^1)';
    end
end

% Create axes and XTick properties
axes1 = axes('Parent',figure1,...
    'XTickLabel',XTL_prim,...
    'XTick',1:length(orderedDriver),...
    'XTickLabelRotation',45,...
    'FontSize',fsizeMed,'Position',[0.2 0.3 0.671 0.659]);
%    'FontSize',fsizeMed,'Position',[0.2 0.25 0.671 0.659]); %Play with [x, y, xsize, ysize] to get figure positioned well
hold(axes1,'all');

% hold on
eachH=bar(B);
xlim([0 length(orderedDriver)+1])
ylim([0 1])

% plot the best we can expect from the benchmark
l1=line([0;length(orderedDriver)+1],[r2_benchmark;r2_benchmark]);
set(l1,'LineStyle','--','color','k')

% Label axes and add title
ylabel('r^2')
%xlabel('Predictor')
%xlabel('Individual Drivers','FontName',fname) %May not need general x axis label
hold off
% title(strcat('a. ',month)) %for Oecologia, panel titles okay.  Move to upper left corner
% text(1,0.93,strcat('a.  ',month),...
%     'FontSize',fsizeMed); % can use 'title' command or simply text for title
if HD ==1 % nighttime (HD ==1) and daytime (HD ==2)
    if strcmpi(month,'all')
        text(1,0.95,'all periods nighttime',...
            'FontSize',fsizeMed); % can use 'title' command or simply text for title
    else
        text(1,0.95,strcat(month,' nighttime'),...
            'FontSize',fsizeMed); % can use 'title' command or simply text for title
    end
elseif HD ==2
    if strcmpi(month,'all')
        text(1,0.95,'all periods daytime',...
            'FontSize',fsizeMed); % can use 'title' command or simply text for title
    else
        text(1,0.95,strcat(month,' daytime'),...
            'FontSize',fsizeMed); % can use 'title' command or simply text for title
    end
end

% Change bar color
set(eachH,'facecolor',[0.4 0.4 0.4])

% Save figures (set in master_neuralNetDriverAnalysis)
if saveFigures==1
%    set(gcf, 'PaperPositionMode', 'auto'); %For some reason in 2014 version this makes graph run off page
%     set(gcf, 'PaperPositionMode', 'manual');
%     set(gcf, 'PaperUnits', 'inches');
%     set(gcf, 'PaperPosition', [1 4 8.0 4]);
   set(gcf, 'Position', [1 1 800 600]); % This sets size in pixels 
    if year_consecutive==1
        if exist('eco_pheno_periods','var')
            if HD ==1
                filename=strcat('./Graphs/compareAllPredict_grey_night_',month{1}); % If looping through all months, each month becomes a cell array
            elseif HD ==2
                filename=strcat('./Graphs/compareAllPredict_grey_day_',month{1}); % If looping through all months, each month becomes a cell array
            end
        else
            if HD ==1
                filename=strcat('./Graphs/compareAllPredict_grey_night_',month);
            elseif HD ==2
                filename=strcat('./Graphs/compareAllPredict_grey_day_',month);
            end
        end

    elseif year_consecutive==0
        if exist('eco_pheno_periods','var')
            if HD ==1
                filename=strcat('./Graphs/compareAllPredict_grey_night_',month{1},'_',num2str(yearsInclude)); % If looping through all months, each month becomes a cell array
            elseif HD ==2
                filename=strcat('./Graphs/compareAllPredict_grey_day_',month{1},'_',num2str(yearsInclude)); % If looping through all months, each month becomes a cell array
            end
        else
            if HD ==1
                filename=strcat('./Graphs/compareAllPredict_grey_night_',month,'_',num2str(yearsInclude));
            elseif HD ==2
                filename=strcat('./Graphs/compareAllPredict_grey_day_',month,'_',num2str(yearsInclude));
            end
        end
        %print(figure1,'-deps', filename);
    end
        print(figure1,'-deps', filename);
% save .eps figure
    % One method of removing most of the white space and saving; smart crop in graphic converter works best so far 
%         addpath('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/saveTightFigure')
%         outfilename = strcat(filename, '.eps');
%         saveTightFigure(outfilename)

% save Matlab fig (optional)
savefig(filename)
end

%% Old code for reference
%%%%%% PLOT
% NOTE: Can probably delete this since using greyscale plot.
% NOTE: This makes a plot with default blue bars and dotted lines to show
% each driver r^2
% scrsz = get(0,'ScreenSize');
% figure1 =figure('Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)/2.5]);
% 
% % Create axes
% axes1 = axes('Parent',figure1,...
%     'XTickLabel',orderedDriver(:),...
%     'XTick',1:length(orderedDriver),'FontSize',fsize,'Position',[0.2 0.25 0.671 0.659]); %Play with [x, y, xsize, ysize] to get figure positioned well
% hold(axes1,'all');
% 
% % hold on
% bar(B)
% xlim([0 length(orderedDriver)+1])
% 
% % plot the best we can expect from the benchmark
% l1=line([0;length(orderedDriver)+1],[r2_benchmark;r2_benchmark]);
% set(l1,'LineStyle','--','color','k')
% 
% xticklabel_rotate([],45,[],'Fontsize',fsize,'interpreter','none')
% % set(gca,'XTickLabel',orderedDriver)
% % ylim([0.7 1])
% ylabel('r^2')
% %xlabel('Predictor')
% xlabel('Individual Drivers','FontName',fname)
% hold off
% title('Each driver individually') %Need to remove figure titles for publication (but panel titles okay)
% 
% if saveFigures==1
%     set(gcf, 'PaperPositionMode', 'auto');
%     
%     filename=strcat('./Graphs/compareAllPredictors');
%     print(figure1,'-deps', filename);
% end