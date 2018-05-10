%% Make stacked plot for best driver plus 1
% This script used to be in master_neuralNetDriverAnalysis.m, but made it a
% subscript because it became very long

% Notes
% 1) Using 'try' and 'catch' because sometimes it is useful to include all
% drivers in driverIndex in neuralNet_bestPlusOne, but then the stacked
% graph doesn't work.
% 2) Commented out code at end is code for old best plus one plot (for
% reference)

try
nMat=length(B);
rbMat=repmat(max(B),[1 nMat]);
% find difference betw best and 2 driver combos (performance improvement)
Bb_diff=Bb-max(B);
rbBMat=[0 Bb_diff];
stackMat=[rbMat;rbBMat]';

%%%%%% PLOT
scrsz = get(0,'ScreenSize');
figure1 =figure('Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)/2.5]);

% Choose font size and name 
fname2='Arial';

% make string of Xtick names (this is slow, so can comment out when not needed)
% XTL_prim=orderedDriver(:) If for loop defining XTL_prim is commented out, uncomment this
% tmp=orderedDriverb(:);
tmp2=['best'; orderedDriverb(:)]; 
XTL_sec={};
for z = 1:length(tmp2)
    if strcmpi(tmp2(z),'best')
        XTL_sec{z}=strcat('Best: ',orderedDriver{1});
    elseif strcmpi(tmp2(z),'h2osoil')
        XTL_sec{z}='Soil moist. (m^3 m^-^3)';
    elseif strcmpi(tmp2(z),'Tsoil')
        XTL_sec{z}='Soil temp. (\circC)';
    elseif strcmpi(tmp2(z),'T21m')
        XTL_sec{z}='Air temp. (\circC)';
    elseif strcmpi(tmp2(z),'vpd')
        XTL_sec{z}='VPD (kPa)';
    elseif strcmpi(tmp2(z),'Rnet25')
        XTL_sec{z}='Net rad. (W m^-^2)';
    elseif strcmpi(tmp2(z),'ustar21m')
        XTL_sec{z}='U^* (m s^-^1)';
    elseif strcmpi(tmp2(z),'swe')
        XTL_sec{z}='SWE (mm)';
    elseif strcmpi(tmp2(z),'wd21m')
        XTL_sec{z}= 'Wind dir. (deg. from N)';
    elseif strcmpi(tmp2(z),'RH2m')
        XTL_sec{z}='Rel. Humidity';
    elseif strcmpi(tmp2(z),'RH8m')
        XTL_sec{z}='Rel. Humidity 8m';
    elseif strcmpi(tmp2(z),'precipmm')
        XTL_sec{z}='Precip (mm)';
    elseif strcmpi(tmp2(z),'ws21m')
        XTL_sec{z}='Wind speed (m^-^s)';
    elseif strcmpi(tmp2(z),'Rppfdin')
        XTL_sec{z}='In. PAR (\mumol m^-^2 s^-^1)';
    elseif strcmpi(tmp2(z),'prevNEE')
        XTL_sec{z}='Prev. NEE (\mumol m^-^2 s^-^1)';
    end
end

% Create axes and X tick properties
axes1 = axes('Parent',figure1,...
    'XTickLabel',XTL_sec,...
    'XTick',1:length(tmp2),...
    'FontSize',fsizeMed,...
    'XTickLabelRotation',45,...
    'FontSize',fsizeMed,'Position',[0.2 0.3 0.671 0.659]);
    % 'XTickLabel',tmp(:),...   %Switch to this if for loop defining  XTL_sec is commented out
%     'XTick',1:length(orderedDriverb),'FontSize',fsize);
hold(axes1,'all');

% Make stacked bar plot
stackH=bar(stackMat,'stack');
xlim([0 length(orderedDriver)+1])
ylim([0 1])

% plot the best we can expect from the benchmark
l1=line([0;length(orderedDriverb)+1],[r2_benchmark;r2_benchmark],'Color','k','LineWidth',1);
set(l1,'LineStyle','--','color','k')

% Add labels and title
ylabel('r^2','FontName',fname2)
% xlabel('Predictor','FontName',fname2) %I don't think X axis needs it's own label
%title('Best driver + one','FontName',fname2)
if HD == 1 % nighttime (HD ==1) and daytime (HD ==2)
    if strcmpi(month,'all')
        text(1,0.95,'all periods nighttime',...
            'FontSize',fsizeMed); % can use 'title' command or simply text for title
    else
        text(1,0.95,strcat(month,' nighttime'),...
            'FontSize',fsizeMed);
    end
elseif HD ==2
    if strcmpi(month,'all')
        text(1,0.95,'all periods daytime',...
            'FontSize',fsizeMed); % can use 'title' command or simply text for title
    else
        text(1,0.95,strcat(month,' daytime'),...
            'FontSize',fsizeMed);
    end
end

% Change colors
P=findobj(gca,'type','patch');
myC= [0.4 0.4 0.4;0.15 0.15 0.15];
for k=1:2 %Since there are just two colors in this graph
  set(stackH(k),'facecolor',myC(k,:))
end

% Add legend
stackLEG=legend('Dominant driver','Performance improvement','Location','NorthOutside');
% See also: http://www.mathworks.com/matlabcentral/answers/106257-set-legend-color-in-stacked-bar-plot
% remove box around legend
set(stackLEG,'Box','off',...
    'Location','NorthOutside');
    % 'Location','NorthEast'); %Depending on graph this might overlap, but oecologia wants legends in graph
    %'Position',[0.5 0.5 0.5 0.5]); %This is based on position in window, not graph axes. ([left bottom width height])
% Change text properties
LEG = findobj(stackLEG,'type','text');
set(LEG,'FontSize',18,...
    'FontName',fname2);

% Save as eps
if saveFigures==1
    %set(gcf, 'PaperPositionMode', 'auto');
    set(gcf, 'Position', [1 1 800 600]); % This sets size in pixels
    if year_consecutive==1
        if exist('eco_pheno_periods','var')
            if HD ==1
                filename=strcat('./Graphs/SecondaryStack_night_',month{1});
            elseif HD ==2
                filename=strcat('./Graphs/SecondaryStack_day_',month{1});
            end
        else
            if HD ==1
                filename=strcat('./Graphs/SecondaryStack_night_',month);
            elseif HD ==2
                filename=strcat('./Graphs/SecondaryStack_day_',month);
            end
        end
    elseif year_consecutive==0
        if exist('eco_pheno_periods','var')
            if HD ==1
                filename=strcat('./Graphs/SecondaryStack_night_',month{1},'_',num2str(yearsInclude));
            elseif HD ==2
                filename=strcat('./Graphs/SecondaryStack_day_',month{1},'_',num2str(yearsInclude));
            end
        else
            if HD ==1
                filename=strcat('./Graphs/SecondaryStack_night_',month,'_',num2str(yearsInclude));
            elseif HD ==2
                filename=strcat('./Graphs/SecondaryStack_day_',month,'_',num2str(yearsInclude));
            end
        end
    end
    % save .eps figure
    print(figure1,'-deps', filename); %See Make_each_driver_plot_greyscale for one method of reducing white space
    % save Matlab fig (optional)
    savefig(filename)
end

catch ME
    warning(['Could not make stacked plot.  Double check driverIndex in neuralNet_bestPlusOne'])
end

%%%%%% Old best plus one PLOT
% NOTE: Can probably delete this since using greyscale plot.
% NOTE: This makes a plot with default blue bars and dotted lines to show
% best driver plus each other driver.  Saved name does not
% include years used if year_consecutive==0 (for an example of how to
% change this, see Make_each_driver_plot_greyscale).

% scrsz = get(0,'ScreenSize');
% figure1 =figure('Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)/2.5]);
% 
% % Create axes
% 
% tmp=orderedDriverb(:);
% axes1 = axes('Parent',figure1,...
%     'XTickLabel',tmp(:),...
%     'XTick',1:length(orderedDriverb),'FontSize',fsize);
% hold(axes1,'all');
% 
% % hold on
% bar(Bb)
% xlim([0 length(orderedDriverb)+1])
% 
% % plot the best we can expect from the benchmark
% l1=line([0;length(orderedDriverb)+1],[r2_benchmark;r2_benchmark]);
% set(l1,'LineStyle','--','color','k')
% 
% % plot the best we can expect from just one driver
% l1=line([0;length(orderedDriverb)+1],[max(r2);max(r2)]);
% set(l1,'LineStyle','--','color','k')
% 
% xticklabel_rotate([],45,[],'Fontsize',fsize,'interpreter','none');
% ylim([0 1])
% ylabel('r^2')
% xlabel('Predictor')
% title('Best driver + one')
% 
% hold off
% 
% if saveFigures==1
%     set(gcf, 'PaperPositionMode', 'auto');
%     if exist('eco_pheno_periods','var')
%         if HD ==1
%             filename=strcat('./Graphs/compareBestPlusOnePredict_night_',month{1});
%         elseif HD ==2
%             filename=strcat('./Graphs/compareBestPlusOnePredict_day_',month{1});
%         end
%     else
%         if HD ==1
%             filename=strcat('./Graphs/compareBestPlusOnePredict_night_',month(1));
%         elseif HD ==2
%             filename=strcat('./Graphs/compareBestPlusOnePredict_day_',month(1));
%         end
%     end
%     print(figure1,'-deps', filename);
% end