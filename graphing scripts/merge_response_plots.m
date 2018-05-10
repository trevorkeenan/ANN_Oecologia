% This script is for merging existing NEP (or NEE) response figs (e.g produced
% from many_OneDriver_ForPlot for different periods/years). Graphs from first 3
% sections are probably not going to be used (they were practice!)
%
% Table of contents (NEEDS UPDATING)
% Section 1: merge all monsoon and all Day (precipitation responses)
% Section 2: Merge monsoon 2013 and monsoon 2010 figs with all monsoon fig (precipitation responses)
% Section 3: Merge monsoon 2013 and monsoon 2010 figs with all monsoon fig (PPFD responses)
% Section 4: Show different seasons data points in all DAY NEP data air temperature response
% Section 5: Show different seasons data points in all NIGHT NEP data temperature response
% Section 6: Show different seasons data points in all DAY NEP data soil temperature response
% Section 7: Show different seasons data points in all Night NEP data soil temperature response
% Section 8: Show different seasons data points in all DAY NEP data soil moisture response
% Section 9: Show different seasons data points in all Night NEP data soil moisture response
% Section 10: Show different seasons data points in all DAY NEP data VPD response
% Section 11: Show different seasons data points in all Night NEP data VPD response
% Section 12: Show different seasons data points in all DAY NEP data RH response
% Section 13: Show different seasons data points in all Night NEP data RH response
% Section 14: Show different seasons data points in all DAY EP data PAR response
% Section 15: Daytime ET response to air temperature, different seasons data points
% Section 16: Nighttime ET response to air temperature, different seasons data points
% Section 17: Daytime ET response to u*, different seasons data points
% Section 18: Nighttime ET response to u*, different seasons data points
% Section 19: Daytime ET response to relative humidity, different seasons data points
% Section 20: nighttime ET response to relative humidity, different seasons data points
% Section 21: Daytime ET response to PAR, different seasons data points

% To do:
% 1) Directories are set for 'Niwot Results draft2' folder, with existing figures, to be found in
% dropbox.  (Note that 'NEP response' subfolder used to be called 'Without
% soil moisture,' and I have updated the directories but not yet tried
% running this again).
% 2) Change exported figure width and height if necessary

% Notes:
% 1) It seems that all print commands with .eps save extra white space
% in R2014B.  Manually saving .eps does not have this problem, so just
% saving .fig for now.
% 2) Right now script only saves figures that I think I will show (relevant
% as primary or secondary drivers based on table)
% 3) Could show 'warm' and 'cool' year snowmelts for NEP?
% 4) During the revision, reviewer 1 asked for day and night to have same
% x-axes, so those are now hard-coded (used to be based on matlab defaults
% fom 'all data' figure).  Search for hard-coded in all caps to find where
% these are defined if data changes and the limits thus need to be changed.

% Resources:
% http://stackoverflow.com/questions/13276009/how-to-merge-two-figure-files-into-a-single-file
% http://www.mit.edu/people/abbe/matlab/handle.html
% http://matlabgeeks.com/tips-tutorials/findobj_graphics_properties/
% http://stackoverflow.com/questions/23729369/matlab-textbox-alpha-does-not-adjust-all-background-color/23734273#23734273
% colorbrewer2.org
% http://www.mathworks.com/matlabcentral/fileexchange/3668-breakaxis
% http://www.mathworks.com/matlabcentral/answers/101806-how-can-i-insert-my-matlab-figure-fig-files-into-multiple-subplots
% https://stackoverflow.com/questions/3600945/printing-a-matlab-plot-in-exact-dimensions-on-paper/3601094#3601094
% http://www.mathworks.com/help/matlab/creating_plots/save-figure-at-specific-size-and-resolution.html
% http://www.mathworks.com/matlabcentral/answers/162283-why-is-the-figure-in-my-eps-file-generated-using-matlab-r2014b-in-the-wrong-position-and-with-extra

close all
clear all

% Some nice color options
pale_yellow = [1, 1, 204/255];
medium_blue = [65/255, 182/255, 196/255];
peachy_orange = [253/255, 174/255, 97/255];
brbg_brown1 = [140/255, 81/255, 10/255];
brbg_brown2 = [216/255, 179/255, 101/255];
brbg_tan = [246/255, 232/255, 195/255];
brbg_blue1 = [199/255, 234/255, 229/255];
brbg_blue2 = [90/255, 180/255, 172/255];
brbg_blue3 = [1/255, 102/255, 94/255];

% Define colors
% 2013 Monsoon
mon2013_col = peachy_orange;
% 2010 Monsoon
mon2010_col = medium_blue;

% Set figure length and width for sections 4 to... Units are....
figxwidth = 8.2;
figywidth = 8.623;

% Decide whether to label insets.  (Note that the letters might need to be
% changed based on if the plots are in panels. Basically this is a way 
% to keep this code although minor revisions said
% not to label these insets). If label_insets == 1 then inset labels will
% show
label_insets = 0;

% Set directory for export
fig_dir = '/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/period colors/with insets';
%fig_dir = '/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/period colors/with insets';


%% Section 1: merge all monsoon and all Day (precipitation responses)

% Load 'bottom' figure (figure to be copied onto)
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/all day workspace response curves')
AllDay = open('allDay5.fig');

% Load 'top' figure
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/monsoon day workspace response curves')
monsoonAll = open('monsoonDay5.fig');

%Make any changes to top figure before copying
h1 = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(h1,'MarkerFaceColor','Green');
% Make error bars transparent?

ax1 = get(AllDay, 'Children');
ax2 = get(monsoonAll, 'Children');


for i = 1 : numel(ax2) 
   ax2Children = get(ax2(i),'Children');
   copyobj(ax2Children, ax1(i));
end

close all
%% Section 2: Merge monsoon 2013 and monsoon 2010 figs with all monsoon fig (precipitation responses)
% % Commenting out because for Oecologia re-submission version, I didn't re-make the
% % required workspaces.
% 
% % Load 'bottom' figure (figure to be copied onto)
% cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/monsoon day workspace response curves')
% monsoonAll = open('monsoonDay5.fig');
% 
% 
% % Load 'middle' figure (figure to be copied onto)
% %cd('/Users/lpapgm/Desktop/Niwot Results draft2/Results graphs/non-consecutive years/Response curves/2010 Monsoon Day')
% cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/non-consecutive years/Response curves/2010 Monsoon Day')
% monsoon2010 = open('monsoonDay_2010_5.fig');
% 
% % Make changes to middle figure before copying
% h1 = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
% set(h1,'MarkerFaceColor',mon2010_col);
% % Make area transparent (doesn't work)
% % ha1 = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]); %find 'points' (only line with marker)
% % set(ha1, 'FaceAlpha',0.5) % unfortunately alpha doesn't seem to work in 2014b
% 
% 
% % Load 'top' figure
% cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/non-consecutive years/Response curves/2013 Monsoon Day')
% monsoon2013 = open('monsoonDay_2013_5.fig');
% 
% % Make changes to middle figure before copying
% h2 = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
% set(h2,'MarkerFaceColor',mon2013_col);
% 
% % Get 'children' from all figures
% ax1 = get(monsoonAll, 'Children');
% ax2 = get(monsoon2010, 'Children');
% ax3 = get(monsoon2013, 'Children');
% 
% % % This method copies figures 2 and 3 onto figure 1
% % for i = 1 : numel(ax2) 
% %    ax2Children = get(ax2(i),'Children');
% %    copyobj(ax2Children, ax1(i));
% % end
% % 
% % for i = 1 : numel(ax3) 
% %    ax3Children = get(ax3(i),'Children');
% %    copyobj(ax3Children, ax1(i));
% % end
% % 
% % % Then delete children or edit axes in combined figure
% % mergedChildren = get(ax1(:),'Children');
% % % delete 2nd two text boxes
% % delete(mergedChildren([8,15]));
% 
% % This copies over specific 'children' from axes 1 and 2
% ax2Children = get(ax2(:),'Children');
% ax3Children = get(ax3(:),'Children');
% % copy over colored scatter points
% copyobj(ax2Children(3), ax1(:));
% copyobj(ax3Children(3), ax1(:));
% 
% close all
%% Section 3: Merge monsoon 2013 and monsoon 2010 figs with all monsoon fig (PPFD responses)
% Load 'bottom' figure (figure to be copied onto)
% % Commenting out because for Oecologia re-submission version, I didn't re-make the
% % required workspaces.
% 
% cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/monsoon day workspace response curves')
% monsoonAllPPFD = open('monsoonDay8.fig');
% 
% 
% % Load 'middle' figure (figure to be copied onto)
% %cd('/Users/lpapgm/Desktop/Niwot Results draft2/Results graphs/non-consecutive years/Response curves/2010 Monsoon Day')
% cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/non-consecutive years/Response curves/2010 Monsoon Day')
% monsoon2010PPFD = open('monsoonDay_2010_8.fig');
% 
% % Make changes to middle figure before copying
% h1 = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
% set(h1,'MarkerFaceColor',mon2010_col);
% % Make area transparent (doesn't work)
% % ha1 = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]); %find 'points' (only line with marker)
% % set(ha1, 'FaceAlpha',0.5) % unfortunately alpha doesn't seem to work in 2014b
% 
% 
% % Load 'top' figure
% cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/non-consecutive years/Response curves/2013 Monsoon Day')
% monsoon2013PPFD = open('monsoonDay_2013_8.fig');
% 
% % Make changes to middle figure before copying
% h2 = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
% set(h2,'MarkerFaceColor',mon2013_col);
% 
% % Get 'children' from all figures
% ax1 = get(monsoonAllPPFD, 'Children');
% ax2 = get(monsoon2010PPFD, 'Children');
% ax3 = get(monsoon2013PPFD, 'Children');
% 
% % % This method copies figures 2 and 3 onto figure 1
% % for i = 1 : numel(ax2) 
% %    ax2Children = get(ax2(i),'Children');
% %    copyobj(ax2Children, ax1(i));
% % end
% % 
% % for i = 1 : numel(ax3) 
% %    ax3Children = get(ax3(i),'Children');
% %    copyobj(ax3Children, ax1(i));
% % end
% % 
% % % Then delete children or edit axes in combined figure
% % mergedChildren = get(ax1(:),'Children');
% % % delete 2nd two text boxes
% % delete(mergedChildren([8,15]));
% 
% % This copies over specific 'children' from axes 1 and 2
% ax2Children = get(ax2(:),'Children');
% ax3Children = get(ax3(:),'Children');
% % copy over colored scatter points
% copyobj(ax2Children(3), ax1(:));
% copyobj(ax3Children(3), ax1(:));
% 
% % Add legend
% 
% close all
%% Section 4: Show different seasons data points in all DAY data air temperature response
% Open all day air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/all day workspace response curves')
AllDayT = open('allDay1.fig');
% Xlim = xlim; %Original x limits
Xlim = [-23.7 21.5]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
Ylim = ylim;
Day_inset_Ymin = Ylim(1); %Day y limits only need to be set once for NEP becz same for all day figs (x varies by variable)
Day_inset_Ymax = Ylim(2);
% Add units to y-axis label for NEP
AllDayT_ylabel=get(gca,'YLabel');
set(AllDayT_ylabel, 'String','NEP_{daytime} (\mumol m^{-2} s^{-1})')
% Spell out x-axis label
AllDayT_xlabel=get(gca,'XLabel');
set(AllDayT_xlabel, 'String','Air temperature (\circC)')
% Make the standard deviation a darker gray
AllDayT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(AllDayT_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/winter day workspace response curves')
winterDayT = open('winterDay1.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
winterDayT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(winterDayT_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/snowmelt day workspace response curves')
SMDayT = open('snowmeltDay1.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
SMDayT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(SMDayT_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/premonsoon day workspace response curves')
PreMDayT = open('preMonsoonDay1.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
PreMDayT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(PreMDayT_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/monsoon day workspace response curves')
monDayT = open('monsoonDay1.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
monDayT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(monDayT_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/post-monsoon day workspace response curves')
postMDayT = open('post-monsoonDay1.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
hpoMDayT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hpoMDayT_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(AllDayT, 'Children');
ax2 = get(winterDayT, 'Children');
ax3 = get(SMDayT, 'Children');
ax4 = get(PreMDayT, 'Children');
ax5 = get(monDayT, 'Children');
ax6 = get(postMDayT, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(AllDayT)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*8;    %Position label 8% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);
            
% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend
% figure(AllDayT)
% %legend(ax1Children(1:5),'Post-monsoon','Monsoon','Pre-monsoon','Snowmelt','Winter','Location','west','Box','off') %old, for reference
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
% set(legend,'Position',[.139 .375 .198 .145]);


% % Could Add ANN line from snow-melt period like this
% copyobj(ax3Children(7), ax1(:)); %Need to figure out right layer

% Inset: Add ANN line(s) & SD from periods of interest
figure(AllDayT) % Make 'underlying' figure for inset current
inset = axes('Position',[.17 .58 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
% A way to make the inset by itself:
%figure()
%inset = axes('Position',[.11 .11 .8 .8]); 
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([Day_inset_Ymin Day_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = AllDayT;
fig_name = 'AllDayT';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
% D = fig.PaperPosition;
% fig.PaperSize = [D(3) D(4)];
% savefig(fig, 'AllDayT.fig')
% saveas(fig,'test.eps','psc2');
% print(fig,'-depsc2',fig_name); %I'm not sure what's different between depsc and depsc2
% Note, it seems that all print commands with .eps save extra white space
% in R2014B.  Manually saving .eps does not have this problem, so just
% saving .fig for now.
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children Xlim inset_Xmin inset_Xmax %might want to clear other objects with re-used names too
close(winterDayT, SMDayT, PreMDayT, monDayT, postMDayT)

%% Section 5: Show different seasons data points in all NIGHT data temperature response
% Open all Night air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/all Night workspace response curves')
AllNightT = open('allNight1.fig');
% Xlim = xlim; % Original x limits
Xlim = [-23.7 21.5]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
Ylim = ylim;
Night_inset_Ymin = Ylim(1); %night y limits only need to be set once becz same for all day figs (x varies by variable)
Night_inset_Ymax = Ylim(2);
% Add units to y-axis label for NEP
AllNightT_ylabel=get(gca,'YLabel');
set(AllNightT_ylabel, 'String','NEP_{nighttime} (\mumol m^{-2} s^{-1})')
% Spell out x-axis label
AllNightT_xlabel=get(gca,'XLabel');
set(AllNightT_xlabel, 'String','Air temperature (\circC)')
% Make the standard deviation a darker gray
AllNightT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(AllNightT_SD, 'FaceColor',[0.7, 0.7, 0.7]);

% Open winter air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/winter Night workspace response curves')
winterNightT = open('winterNight1.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
winterNightT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(winterNightT_SD, 'FaceColor',[0.7, 0.7, 0.7]);

% Open Snow Melt air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/snowmelt Night workspace response curves')
SMNightT = open('snowmeltNight1.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
SMNightT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(SMNightT_SD, 'FaceColor',[0.7, 0.7, 0.7]);

% Open pre-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night no SWE 1999-2013/pre-monsoon Night workspace response curves')
PreMNightT = open('preMonsoonNight1.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
PreMNightT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(PreMNightT_SD, 'FaceColor',[0.7, 0.7, 0.7]);

% Open monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night no SWE 1999-2013/monsoon Night workspace response curves')
monNightT = open('monsoonNight1.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
monNightT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(monNightT_SD, 'FaceColor',[0.7, 0.7, 0.7]);

% Open post-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/post-monsoon Night workspace response curves')
postMNightT = open('post-monsoonNight1.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
postMNightT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(postMNightT_SD, 'FaceColor',[0.7, 0.7, 0.7]);

% name axes for all figures
ax1 = get(AllNightT, 'Children');
ax2 = get(winterNightT, 'Children');
ax3 = get(SMNightT, 'Children');
ax4 = get(PreMNightT, 'Children');
ax5 = get(monNightT, 'Children');
ax6 = get(postMNightT, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(AllNightT)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*8;    %Position label 8% along x axis
text(psin_txt_x,psin_txt_y,'b)',...
                'FontSize',16);
            
% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])

% Add legend
figure(AllNightT)
legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
set(legend,'Position',[.2 .5 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(AllNightT) % Make 'underlying' figure for inset current
inset = axes('Position',[.16 .168 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
%Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
ylim([-5 Night_inset_Ymax+.5])
% %define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'d. Period ANNs',...
        'FontSize',16);
else
end
            
% Set figure size and save as .fig
cd(fig_dir)
fig = AllNightT;
fig_name = 'AllNightT';
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children Xlim inset_Xmin inset_Xmax %might want to clear other objects with re-used names too
close(winterNightT, SMNightT, PreMNightT, monNightT, postMNightT)
%% Section 6: Show different seasons data points in all DAY data soil temperature response
% Open all day air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/all day workspace response curves')
AllDayST = open('allDay7.fig');
%Xlim = xlim; % Original x limits
Xlim = [-4.2 14.9]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to y-axis label for NEP
AllDayST_ylabel=get(gca,'YLabel');
set(AllDayST_ylabel, 'String','NEP_{daytime} (\mumol m^{-2} s^{-1})')
% Spell out x-axis label
AllDayST_xlabel=get(gca,'XLabel');
set(AllDayST_xlabel, 'String','Soil temperature (\circC)')
% Make the standard deviation a darker gray
allDayST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(allDayST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/winter day workspace response curves')
winterDayST = open('winterDay7.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
winterDayST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(winterDayST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/snowmelt day workspace response curves')
SMDayST = open('snowmeltDay7.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
SMDayT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(SMDayT_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/premonsoon day workspace response curves')
PreMDayST = open('preMonsoonDay7.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
hprMDayT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hprMDayT_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/monsoon day workspace response curves')
monDayST = open('monsoonDay7.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
hmTDayT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hmTDayT_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/post-monsoon day workspace response curves')
postMDayST = open('post-monsoonDay7.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
hpoMDayT_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hpoMDayT_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(AllDayST, 'Children');
ax2 = get(winterDayST, 'Children');
ax3 = get(SMDayST, 'Children');
ax4 = get(PreMDayST, 'Children');
ax5 = get(monDayST, 'Children');
ax6 = get(postMDayST, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(AllDayST)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);
            
% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])

% % Add legend
% figure(AllDayST)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis
% set(legend,'Position',[.139 .375 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(AllDayST) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .168 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([Day_inset_Ymin Day_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = AllDayST;
fig_name = 'AllDaySoilT';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children inset_Xmin inset_Xmax %might want to clear other objects with re-used names too

%% Section 7: Show different seasons data points in all Night data soil temperature response
% Open all Night air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/all Night workspace response curves')
AllNightST = open('allNight7.fig');
%Xlim = xlim; % Original x limits
Xlim = [-4.2 14.9]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to y-axis label for NEP
AllNightST_ylabel=get(gca,'YLabel');
set(AllNightST_ylabel, 'String','NEP_{nighttime} (\mumol m^{-2} s^{-1})')
% Spell out x-axis label
AllNightST_xlabel=get(gca,'XLabel');
set(AllNightST_xlabel, 'String','Soil temperature (\circC)')
% Make the standard deviation a darker gray
AllNightST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(AllNightST_SD, 'FaceColor',[0.7, 0.7, 0.7]);

% Open winter air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/winter Night workspace response curves')
winterNightST = open('winterNight7.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
hwNightST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hwNightST_SD, 'FaceColor',[0.7, 0.7, 0.7]);

% Open Snow Melt air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/snowmelt Night workspace response curves')
SMNightST = open('snowmeltNight7.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
hsmNightST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hsmNightST_SD, 'FaceColor',[0.7, 0.7, 0.7]);

% Open pre-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night no SWE 1999-2013/pre-monsoon Night workspace response curves')
PreMNightST = open('preMonsoonNight7.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
hprMNightST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hprMNightST_SD, 'FaceColor',[0.7, 0.7, 0.7]);

% Open monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night no SWE 1999-2013/monsoon Night workspace response curves')
monNightST = open('monsoonNight7.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
hmNightST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hmNightST_SD, 'FaceColor',[0.7, 0.7, 0.7]);

% Open post-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/post-monsoon Night workspace response curves')
postMNightST = open('post-monsoonNight7.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
hpoMNightST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hpoMNightST_SD, 'FaceColor',[0.7, 0.7, 0.7]);

% name axes for all figures
ax1 = get(AllNightST, 'Children');
ax2 = get(winterNightST, 'Children');
ax3 = get(SMNightST, 'Children');
ax4 = get(PreMNightST, 'Children');
ax5 = get(monNightST, 'Children');
ax6 = get(postMNightST, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(AllNightST)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'b)',...
                'FontSize',16);
            
% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])

% Add legend
figure(AllNightST)
legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
set(legend,'Position',[.14 .5 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(AllNightST) % Make 'underlying' figure for inset current
inset = axes('Position',[.16 .168 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
%Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
ylim([-5 Night_inset_Ymax+.5])
% %define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'d. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = AllNightST;
fig_name = 'AllNightSoilT';
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children Xlim inset_Xmin inset_Xmax %might want to clear other objects with re-used names too

%% Section 8: Show different seasons data points in all DAY data soil moisture response
% Open all day air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/all day workspace response curves')
AllDaySM = open('allDay11.fig');
%Xlim = xlim; % Original x limits
Xlim = [0.042 0.59]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to y-axis label for NEP
AllDaySM_ylabel=get(gca,'YLabel');
set(AllDaySM_ylabel, 'String','NEP_{daytime} (\mumol m^{-2} s^{-1})')
% Make the standard deviation a darker gray
allDaySM_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(allDaySM_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/winter day workspace response curves')
winterDaySM = open('winterDay11.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
hwDaySM_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hwDaySM_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/snowmelt day workspace response curves')
SMDaySM = open('snowmeltDay11.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
hsmDaySM_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hsmDaySM_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/premonsoon day workspace response curves')
PreMDaySM = open('preMonsoonDay11.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
hprMDaySM_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hprMDaySM_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/monsoon day workspace response curves')
monDaySM = open('monsoonDay11.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
hmTDaySM_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hmTDaySM_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/post-monsoon day workspace response curves')
postMDaySM = open('post-monsoonDay11.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
hpoMDaySM_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hpoMDaySM_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(AllDaySM, 'Children');
ax2 = get(winterDaySM, 'Children');
ax3 = get(SMDaySM, 'Children');
ax4 = get(PreMDaySM, 'Children');
ax5 = get(monDaySM, 'Children');
ax6 = get(postMDaySM, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(AllDaySM)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*10;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);
            
% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])

% % Add legend (overlaps with inset for daytime soil moisture)
% figure(AllDaySM)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis
% set(legend,'Position',[.65 .35 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(AllDaySM) % Make 'underlying' figure for inset current
%inset = axes('Position',[.59 .168 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
inset = axes('Position',[.59 .18 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([Day_inset_Ymin Day_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = AllDaySM;
fig_name = 'AllDaySoilMoist';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children inset_Xmin inset_Xmax %might want to clear other objects with re-used names too
%% Section 9: Show different seasons data points in all Night data soil moisture response
% Open all Night air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/all Night workspace response curves')
AllNightSM = open('allNight9.fig');
%Xlim = xlim; % Original x limits
Xlim = [0.042 0.59]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to y-axis label for NEP
AllNightSM_ylabel=get(gca,'YLabel');
set(AllNightSM_ylabel, 'String','NEP_{nighttime} (\mumol m^{-2} s^{-1})')
% Spell out x-axis label
AllNightT_xlabel=get(gca,'XLabel');
set(AllNightT_xlabel, 'String','Soil Moisture (m^3 m^{-3})')
% Make the standard deviation a darker gray
allNightSM_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(allNightSM_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/winter Night workspace response curves')
winterNightSM = open('winterNight9.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
hwNightSM_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hwNightSM_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/snowmelt Night workspace response curves')
SMNightSM = open('snowmeltNight9.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
hsmNightSM_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hsmNightSM_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night no SWE 1999-2013/pre-monsoon Night workspace response curves')
PreMNightSM = open('preMonsoonNight9.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
hprMNightSM_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hprMNightSM_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night no SWE 1999-2013/monsoon Night workspace response curves')
monNightSM = open('monsoonNight9.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
hmTNightSM_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hmTNightSM_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/post-monsoon Night workspace response curves')
postMNightSM = open('post-monsoonNight9.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
hpoMNightSM_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hpoMNightSM_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(AllNightSM, 'Children');
ax2 = get(winterNightSM, 'Children');
ax3 = get(SMNightSM, 'Children');
ax4 = get(PreMNightSM, 'Children');
ax5 = get(monNightSM, 'Children');
ax6 = get(postMNightSM, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(AllNightSM)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*10;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'b)',...
                'FontSize',16);

% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend
% figure(AllNightSM)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis
% set(legend,'Position',[.65 .18 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(AllNightSM) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .2 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%ylim([Night_inset_Ymin Night_inset_Ymax])
ylim([-5 Night_inset_Ymax+.5])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'d. Period ANNs',...
        'FontSize',16);
else
end
            
% Set figure size and save as .fig
cd(fig_dir)
fig = AllNightSM;
fig_name = 'AllNightSoilMoist';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

%% Section 10: Show different seasons data points in all DAY VPD response
% Open all day air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/all day workspace response curves')
AllDayVPD = open('allDay6.fig');
%Xlim = xlim; % Original x limits
Xlim = [0.01 2.3]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to y-axis label for NEP
AllDayVPD_ylabel=get(gca,'YLabel');
set(AllDayVPD_ylabel, 'String','NEP_{daytime} (\mumol m^{-2} s^{-1})')
% Make the standard deviation a darker gray
allDayVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(allDayVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/winter day workspace response curves')
winterDayVPD = open('winterDay6.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
winterDayVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(winterDayVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/snowmelt day workspace response curves')
SMDayVPD = open('snowmeltDay6.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
hsmDayVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hsmDayVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/premonsoon day workspace response curves')
PreMDayVPD = open('preMonsoonDay6.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
hprMDayVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hprMDayVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/monsoon day workspace response curves')
monDayVPD = open('monsoonDay6.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
hmTDayVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hmTDayVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/post-monsoon day workspace response curves')
postMDayVPD = open('post-monsoonDay6.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
hpoMDayVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hpoMDayVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(AllDayVPD, 'Children');
ax2 = get(winterDayVPD, 'Children');
ax3 = get(SMDayVPD, 'Children');
ax4 = get(PreMDayVPD, 'Children');
ax5 = get(monDayVPD, 'Children');
ax6 = get(postMDayVPD, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(AllDayVPD)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);

% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% Add legend
figure(AllDayVPD)
legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
legend('boxoff') %This works, but only when ax1 is current axis
set(legend,'Position',[.67 .75 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(AllDayVPD) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .168 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
ylim([Day_inset_Ymin Day_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = AllDayVPD;
fig_name = 'AllDayVPD';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children inset_Xmin inset_Xmax %might want to clear other objects with re-used names too

%% Section 11: Show different seasons data points in all Night VPD response
% Open all Night air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/all Night workspace response curves')
AllNightVPD = open('allNight6.fig');
%Xlim = xlim; % Original x limits
Xlim = [0.01 2.3]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to y-axis label for NEP
AllNightVPD_ylabel=get(gca,'YLabel');
set(AllNightVPD_ylabel, 'String','NEP_{nighttime} (\mumol m^{-2} s^{-1})')
% Make the standard deviation a darker gray
allNightVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(allNightVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/winter Night workspace response curves')
winterNightVPD = open('winterNight6.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
hwNightVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hwNightVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/snowmelt Night workspace response curves')
SMNightVPD = open('snowmeltNight6.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
hsmNightVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hsmNightVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night no SWE 1999-2013/pre-monsoon Night workspace response curves')
PreMNightVPD = open('preMonsoonNight6.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
hprMNightVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hprMNightVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night no SWE 1999-2013/monsoon Night workspace response curves')
monNightVPD = open('monsoonNight6.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
hmNightVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hmNightVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/post-monsoon Night workspace response curves')
postMNightVPD = open('post-monsoonNight6.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
hpoMNightVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hpoMNightVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(AllNightVPD, 'Children');
ax2 = get(winterNightVPD, 'Children');
ax3 = get(SMNightVPD, 'Children');
ax4 = get(PreMNightVPD, 'Children');
ax5 = get(monNightVPD, 'Children');
ax6 = get(postMNightVPD, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(AllNightVPD)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*20;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'b)',...
                'FontSize',16);

% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])

% % Could Add ANN line from snow-melt period
% copyobj(ax3Children(7), ax1(:)); %Need to figure out right layer

% Add legend
%legend(ax1Children(1:5),'Post-monsoon','Monsoon','Pre-monsoon','Snowmelt','Winter','Location','west','Box','off')

% Inset: Add ANN line(s) & SD from periods of interest
figure(AllNightVPD) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .168 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
ylim([Night_inset_Ymin Night_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'d. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = AllNightVPD;
fig_name = 'AllNightVPD';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children inset_Xmin inset_Xmax %might want to clear other objects with re-used names too
%% Section 12: Show different seasons data points in all DAY RH response
% Open all day air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/all day workspace response curves')
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/all day workspace response curves')
AllDayRH = open('allDay10.fig');
%Xlim = xlim; % Original x limits
Xlim = [4 100]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to y-axis label for NEP
AllDayRH_ylabel=get(gca,'YLabel');
set(AllDayRH_ylabel, 'String','NEP_{daytime} (\mumol m^{-2} s^{-1})')
% Change x-axis label for Relative humidity (it was abbreviated before)
ETAllDayRH_ylabel=get(gca,'XLabel');
set(ETAllDayRH_ylabel, 'String','Relative Humidity')

% Open winter air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/winter day workspace response curves')
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/winter day workspace response curves')
winterDayRH = open('winterDay10.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);

% Open Snow Melt air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/snowmelt day workspace response curves')
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/snowmelt day workspace response curves')
SMDayRH = open('snowmeltDay10.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);

% Open pre-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/premonsoon day workspace response curves')
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/premonsoon day workspace response curves')
PreMDayRH = open('preMonsoonDay10.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);

% Open monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/monsoon day workspace response curves')
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/monsoon day workspace response curves')
monDayRH = open('monsoonDay10.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);

% Open post-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/post-monsoon day workspace response curves')
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/post-monsoon day workspace response curves')
postMDayRH = open('post-monsoonDay10.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);

% name axes for all figures
ax1 = get(AllDayRH, 'Children');
ax2 = get(winterDayRH, 'Children');
ax3 = get(SMDayRH, 'Children');
ax4 = get(PreMDayRH, 'Children');
ax5 = get(monDayRH, 'Children');
ax6 = get(postMDayRH, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(AllDayRH)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);

            % Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend--how to fit it??  It overlaps data...leaving box on for now
% % Add legend
% figure(AllDayRH)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% %legend('boxoff') %This works, but only when ax1 is current axis
% set(legend,'Position',[.67 .75 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(AllDayRH) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .62 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([Day_inset_Ymin Day_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = AllDayRH;
fig_name = 'AllDayRH';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

%% Section 13: Show different seasons data points in all Night RH response
% Open all Night air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/all Night workspace response curves')
AllNightRH = open('allNight8.fig');
%Xlim = xlim; % Original x limits
Xlim = [4 100]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to y-axis label for NEP
AllNightRH_ylabel=get(gca,'YLabel');
set(AllNightRH_ylabel, 'String','NEP_{nighttime} (\mumol m^{-2} s^{-1})')
% Change x-axis label for Relative humidity (it was abbreviated before)
ETAllNightRH_xlabel=get(gca,'XLabel');
set(ETAllNightRH_xlabel, 'String','Relative Humidity (%)')

% Open winter air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/winter Night workspace response curves')
winterNightRH = open('winterNight8.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);

% Open Snow Melt air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/snowmelt Night workspace response curves')
SMNightRH = open('snowmeltNight8.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);

% Open pre-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night no SWE 1999-2013/pre-monsoon Night workspace response curves')
PreMNightRH = open('preMonsoonNight8.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);

% Open monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night no SWE 1999-2013/monsoon Night workspace response curves')
monNightRH = open('monsoonNight8.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);

% Open post-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/post-monsoon Night workspace response curves')
postMNightRH = open('post-monsoonNight8.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);

% name axes for all figures
ax1 = get(AllNightRH, 'Children');
ax2 = get(winterNightRH, 'Children');
ax3 = get(SMNightRH, 'Children');
ax4 = get(PreMNightRH, 'Children');
ax5 = get(monNightRH, 'Children');
ax6 = get(postMNightRH, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(AllNightRH)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'b)',...
                'FontSize',16);

% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])

% % Could Add ANN line from snow-melt period
% copyobj(ax3Children(7), ax1(:)); %Need to figure out right layer

% Add legend
%legend(ax1Children(1:5),'Post-monsoon','Monsoon','Pre-monsoon','Snowmelt','Winter','Location','west','Box','off')
% Inset: Add ANN line(s) & SD from periods of interest
figure(AllNightRH) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .18 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([Night_inset_Ymin Night_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'d. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = AllNightRH;
fig_name = 'AllNightRH';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

%% Section 14: Show different seasons data points in all DAY PAR response
% Open all day air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/all day workspace response curves')
AllDayPAR = open('allDay8.fig');
Xlim = xlim; %No night PAR as driver, so leaving limits as default
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to y-axis label for NEP
AllDayPAR_ylabel=get(gca,'YLabel');
set(AllDayPAR_ylabel, 'String','NEP_{daytime} (\mumol m^{-2} s^{-1})')
AllDayPAR_xlabel=get(gca,'XLabel');
set(AllDayPAR_xlabel, 'String','Incoming PAR (\mumol m^{-2} s^{-1})')
% Make the standard deviation a darker gray
allDayPar_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(allDayPar_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/winter day workspace response curves')
winterDayPAR = open('winterDay8.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
winterDayPar_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(winterDayPar_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/snowmelt day workspace response curves')
SMDayPAR = open('snowmeltDay8.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
hsmDayPar_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hsmDayPar_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/premonsoon day workspace response curves')
PreMDayPAR = open('preMonsoonDay8.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
hprMDayPar_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hprMDayPar_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day no SWE 1999-2013/monsoon day workspace response curves')
monDayPAR = open('monsoonDay8.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
hmTDayPar_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hmTDayPar_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/post-monsoon day workspace response curves')
postMDayPAR = open('post-monsoonDay8.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
hpoMDayPar_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hpoMDayPar_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(AllDayPAR, 'Children');
ax2 = get(winterDayPAR, 'Children');
ax3 = get(SMDayPAR, 'Children');
ax4 = get(PreMDayPAR, 'Children');
ax5 = get(monDayPAR, 'Children');
ax6 = get(postMDayPAR, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(AllDayPAR)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);

% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend
% figure(AllDayPAR)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis
% set(legend,'Position',[.16 .7 .198 .145]);

% Could Add ANN line from monsoon period 
% % Option 1: on top of graph
% h2 = copyobj(ax5Children(4), ax1(:)); %standard deviation layer
% h3 = copyobj(ax5Children(2), ax1(:)); %ANN layer
% uistack(h2,'bottom') %move standard to bottom
% set(h3,'LineStyle',':')
% Option 2: as an inset--this was practice, can replace based on example in section 4
% figure(AllDayPAR) % Make 'underlying' figure current
% inset = axes('Position',[.15 .7 .2 .2]); %Create graphics object [left bottom width height] units normalized to graph
% box on
% h5sd = copyobj(ax5Children(4), inset); %standard deviation layer
% h5ann = copyobj(ax5Children(2), inset); %ANN layer
% set(h5ann,'Color',brbg_blue2);

% Inset: Add ANN line(s) & SD from periods of interest
figure(AllDayPAR) % Make 'underlying' figure for inset current
inset = axes('Position',[.17 .58 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([Day_inset_Ymin Day_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = AllDayPAR;
fig_name = 'AllDayPAR';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

close(winterDayPAR, SMDayPAR, PreMDayPAR, monDayPAR, postMDayPAR) %close all but axis 1


%% Section X: Show different seasons data ponts in all Night SWE response
% Open all Night snow water equivalent response
% NOTE: this SWE graph is'nt good for a 'template' for others because
% doesn't include all periods (no pre-monsoon and monsoon)
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/all Night workspace response curves')
AllNightSWE = open('allNight10.fig');
%Xlim = xlim; % Original x limits
Xlim = [0 455]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to y-axis label for NEP
AllNightSWE_ylabel=get(gca,'YLabel');
set(AllNightSWE_ylabel, 'String','NEP_{nighttime} (\mumol m^{-2} s^{-1})')
% Change x-axis label for snow water equivalent (it was abbreviated before)
ETAllNightSWE_xlabel=get(gca,'XLabel');
set(ETAllNightSWE_xlabel, 'String','Snow Water Equivalent (mm)')
% Make the standard deviation a darker gray
AllNightSWE_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(AllNightSWE_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter snow water equivalent response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/winter Night workspace response curves')
winterNightSWE = open('winterNight10.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
winterNightSWE_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(winterNightSWE_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt snow water equivalent response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/snowmelt Night workspace response curves')
SMNightSWE = open('snowmeltNight10.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
hsmNightSWE_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hsmNightSWE_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon snow water equivalent response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Night with SWE 1999-2013/post-monsoon Night workspace response curves')
postMNightSWE = open('post-monsoonNight10.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
hpoMNightSWE_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hpoMNightSWE_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(AllNightSWE, 'Children');
ax2 = get(winterNightSWE, 'Children');
ax3 = get(SMNightSWE, 'Children');
ax6 = get(postMNightSWE, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(5); %ANN line is currently 5th (in this SWE version)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(4)) %normally this is (6) but this SWE version has fewer layers
figure(AllNightSWE)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'b)',...
                'FontSize',16);

% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])

% % Could Add ANN line from snow-melt period
% copyobj(ax3Children(7), ax1(:)); %Need to figure out right layer

% Add legend
%legend(ax1Children(1:5),'Post-monsoon','Monsoon','Pre-monsoon','Snowmelt','Winter','Location','west','Box','off')
% Inset: Add ANN line(s) & SD from periods of interest
figure(AllNightSWE) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .18 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([Night_inset_Ymin Night_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*62;  %Position label 72% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'d. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = AllNightSWE;
fig_name = 'AllNightSWE';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

%% Section XX: Show different seasons data points in all DAY SWE response
% Open all day snow water equivalent response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/all day workspace response curves')
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/all day workspace response curves')
AllDaySWE = open('allDay12.fig');
%Xlim = xlim; % Original x limits
Xlim = [0 455]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to y-axis label for NEP
AllDaySWE_ylabel=get(gca,'YLabel');
set(AllDaySWE_ylabel, 'String','NEP_{daytime} (\mumol m^{-2} s^{-1})')
% Change x-axis label for Snow water equivalent (it was abbreviated before)
ETAllDaySWE_ylabel=get(gca,'XLabel');
set(ETAllDaySWE_ylabel, 'String','Snow water equivalent (mm)')
% Make the standard deviation a darker gray
ETAllDaySWE_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETAllDaySWE_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter snow water equivalent response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/winter day workspace response curves')
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/winter day workspace response curves')
winterDaySWE = open('winterDay12.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
EThwDaySWE_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThwDaySWE_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt snow water equivalent response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/snowmelt day workspace response curves')
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/snowmelt day workspace response curves')
SMDaySWE = open('snowmeltDay12.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
EThsmDaySWE_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThsmDaySWE_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon snow water equivalent response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/post-monsoon day workspace response curves')
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/NEP response/Day with SWE 1999-2013/post-monsoon day workspace response curves')
postMDaySWE = open('post-monsoonDay12.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
EThpoMDaySWE_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThpoMDaySWE_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(AllDaySWE, 'Children');
ax2 = get(winterDaySWE, 'Children');
ax3 = get(SMDaySWE, 'Children');
ax6 = get(postMDaySWE, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(5); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(4))
figure(AllDaySWE)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);

            % Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend--how to fit it??  It overlaps data...leaving box on for now
% % Add legend
% figure(AllDaySWE)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% %legend('boxoff') %This works, but only when ax1 is current axis
% set(legend,'Position',[.67 .75 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(AllDaySWE) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .62 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([Day_inset_Ymin Day_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = AllDaySWE;
fig_name = 'AllDaySWE';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

%% Section 15: Daytime ET response to air temperature, different seasons data points
% open response of ET to air temperature
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O all day workspace response')
ETAllDayT = open('allDay1.fig');
%Xlim = xlim; % Original x limits
Xlim = [-23.6 21.4]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
Ylim = ylim;
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
ET_Day_inset_Ymin = Ylim(1); %Day y limits only need to be defined once for ET becz same for all day figs (x varies by variable)
ET_Day_inset_Ymax = Ylim(2);
% Spell out y-axis label
ETAllDayT_ylabel=get(gca,'YLabel');
set(ETAllDayT_ylabel, 'String','ET_{daytime} (mmol m^{-2} s^{-1})')
% Spell out x-axis label
ETAllDayT_xlabel=get(gca,'XLabel');
set(ETAllDayT_xlabel, 'String','Air temperature (\circC)')
% Make the standard deviation a darker gray
ETallDayST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETallDayST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O winter day workspace response')
ETwinterDayT = open('winterDay1.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
ETwDayST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETwDayST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O snowmelt day workspace response')
ETSMDayT = open('snowmeltDay1.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
ETSMDayST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETSMDayST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O premonsoon day workspace response')
ETPreMDayT = open('preMonsoonDay1.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
hprMDayST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hprMDayST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O monsoon day workspace response')
ETmonDayT = open('monsoonDay1.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
hmTDayST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hmTDayST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon air temperature response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O post-monsoon day workspace response')
ETpostMDayT = open('post-monsoonDay1.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
hpoMDayST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(hpoMDayST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(ETAllDayT, 'Children');
ax2 = get(ETwinterDayT, 'Children');
ax3 = get(ETSMDayT, 'Children');
ax4 = get(ETPreMDayT, 'Children');
ax5 = get(ETmonDayT, 'Children');
ax6 = get(ETpostMDayT, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(ETAllDayT)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);
            
% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend
% figure(ETAllDayT)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
% set(legend,'Position',[.2 .5 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(ETAllDayT) % Make 'underlying' figure for inset current
inset = axes('Position',[.18 .57 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([ET_Day_inset_Ymin ET_Day_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = ETAllDayT;
fig_name = 'ETAllDayT';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

close(ETwinterDayT, ETSMDayT, ETPreMDayT, ETmonDayT, ETpostMDayT) %close all but axis 1

%% Section 16: Nighttime ET response to air temperature, different seasons data points
% Open all Night ET air temperature response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O all night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O all night workspace response')
ETAllNightT = open('allNight1.fig');
%Xlim = xlim; % Original x limits
Xlim = [-23.6 21.4]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
Ylim = ylim;
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
Night_inset_Ymin = Ylim(1); %night y limits only need to be set once becz same for all day figs (x varies by variable)
Night_inset_Ymax = Ylim(2);
% Spell out y-axis label
ETAllNightT_ylabel=get(gca,'YLabel');
set(ETAllNightT_ylabel, 'String','ET_{nighttime} (mmol m^{-2} s^{-1})')
% Spell out x-axis label
ETAllNightT_xlabel=get(gca,'XLabel');
set(ETAllNightT_xlabel, 'String','Air temperature (\circC)')
% Make the standard deviation a darker gray
ETallNightST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETallNightST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter air temperature response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O winter night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O winter night workspace response')
ETwinterNightT = open('winterNight1.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
ETwinterNightST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETwinterNightST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt air temperature response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O snowmelt night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O snowmelt night workspace response')
ETSMNightT = open('snowmeltNight1.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
ETSMNightST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETSMNightST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon air temperature response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O premonsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O premonsoon night workspace response')
ETPreMNightT = open('preMonsoonNight1.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
EThprMNightST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThprMNightST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon air temperature response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O monsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O monsoon night workspace response')
ETmonNightT = open('monsoonNight1.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
EThmTNightST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThmTNightST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon air temperature response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O post-monsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O post-monsoon night workspace response')
ETpostMNightT = open('post-monsoonNight1.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
EThpoMNightST_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThpoMNightST_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(ETAllNightT, 'Children');
ax2 = get(ETwinterNightT, 'Children');
ax3 = get(ETSMNightT, 'Children');
ax4 = get(ETPreMNightT, 'Children');
ax5 = get(ETmonNightT, 'Children');
ax6 = get(ETpostMNightT, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(ETAllNightT)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'b)',...
                'FontSize',16);
            
% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% Add legend
figure(ETAllNightT)
legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
set(legend,'Position',[.17 .68 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(ETAllNightT) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .61 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
%Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
ylim([Night_inset_Ymin Night_inset_Ymax])
% ylim([-5 Night_inset_Ymax+.5])
% %define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'d. Period ANNs',...
        'FontSize',16);
else
end
            
% Set figure size and save as .fig
cd(fig_dir)
fig = ETAllNightT;
fig_name = 'ETAllNightT';
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children Xlim inset_Xmin inset_Xmax %might want to clear other objects with re-used names too
close(ETwinterNightT, ETSMNightT, ETPreMNightT, ETmonNightT, ETpostMNightT)

%% Section 17: Daytime ET response to u*, different seasons data points
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O all day workspace response')
ETAllDayU = open('allDay4.fig');
%Xlim = xlim; % Original x limits
Xlim = [0.03 2.9]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
Ylim = ylim;
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Edit y-axis label for u*
ETAllDayU_ylabel=get(gca,'YLabel');
set(ETAllDayU_ylabel, 'String','ET_{daytime} (mmol m^{-2} s^{-1})')
% Edit x-axis label for u*
ETAllDayU_xlabel=get(gca,'XLabel');
set(ETAllDayU_xlabel, 'String','u_* (m s^{-1})')
% Make the standard deviation a darker gray
ETallDayU_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETallDayU_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter u* response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O winter day workspace response')
ETwinterDayU = open('winterDay4.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
EThwDayU_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThwDayU_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt u* response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O snowmelt day workspace response')
ETSMDayU = open('snowmeltDay4.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
EThsmDayU_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThsmDayU_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon u* response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O premonsoon day workspace response')
ETPreMDayU = open('preMonsoonDay4.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
EThprMDayU_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThprMDayU_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon u* response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O monsoon day workspace response')
ETmonDayU = open('monsoonDay4.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
EThmTDayU_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThmTDayU_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon u* response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O post-monsoon day workspace response')
ETpostMDayU = open('post-monsoonDay4.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
EThpoMDayU_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThpoMDayU_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(ETAllDayU, 'Children');
ax2 = get(ETwinterDayU, 'Children');
ax3 = get(ETSMDayU, 'Children');
ax4 = get(ETPreMDayU, 'Children');
ax5 = get(ETmonDayU, 'Children');
ax6 = get(ETpostMDayU, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(ETAllDayU)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);

% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend
% figure(ETAllDayU)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
% set(legend,'Position',[.2 .5 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(ETAllDayU) % Make 'underlying' figure for inset current
inset = axes('Position',[.6 .61 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([ET_Day_inset_Ymin ET_Day_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = ETAllDayU;
fig_name = 'ETAllDayU';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

close(ETwinterDayU, ETSMDayU, ETPreMDayU, ETmonDayU, ETpostMDayU) %close all but axis 1

%% Section 18: Nighttime ET response to u*, different seasons data points
% Open all Night ET air temperature response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O all night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O all night workspace response')
ETAllNightU = open('allNight4.fig');
%Xlim = xlim; % Original x limits
Xlim = [0.03 2.9]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
Ylim = ylim;
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
Night_inset_Ymin = Ylim(1); %night y limits only need to be set once becz same for all day figs (x varies by variable)
Night_inset_Ymax = Ylim(2);
% Edit x label
ETAllNightU_xlabel=get(gca,'XLabel');
set(ETAllNightU_xlabel, 'String','u_* (m s^{-1})')
% Edit y label
ETAllNightU_ylabel=get(gca,'YLabel');
set(ETAllNightU_ylabel, 'String','ET_{nighttime} (mmol m^{-2} s^{-1})')
% Make the standard deviation a darker gray
ETallNightU_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETallNightU_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O winter night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O winter night workspace response')
ETwinterNightU = open('winterNight4.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
ETwinterNightU_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETwinterNightU_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O snowmelt night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O snowmelt night workspace response')
ETSMNightU = open('snowmeltNight4.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
EThsmNightU_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThsmNightU_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O premonsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O premonsoon night workspace response')
ETPreMNightU = open('preMonsoonNight4.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
EThprMNightU_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThprMNightU_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O monsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O monsoon night workspace response')
ETmonNightU = open('monsoonNight4.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
EThmTNightU_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThmTNightU_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O post-monsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O post-monsoon night workspace response')
ETpostMNightU = open('post-monsoonNight4.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
EThpoMNightU_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThpoMNightU_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(ETAllNightU, 'Children');
ax2 = get(ETwinterNightU, 'Children');
ax3 = get(ETSMNightU, 'Children');
ax4 = get(ETPreMNightU, 'Children');
ax5 = get(ETmonNightU, 'Children');
ax6 = get(ETpostMNightU, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(ETAllNightU)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'b)',...
                'FontSize',16);

% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% Add legend
figure(ETAllNightU)
legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
set(legend,'Position',[.17 .68 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(ETAllNightU) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .61 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
%Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
ylim([Night_inset_Ymin Night_inset_Ymax])
% %define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'d. Period ANNs',...
        'FontSize',16);
else
end
            
% Set figure size and save as .fig
cd(fig_dir)
fig = ETAllNightU;
fig_name = 'ETAllNightU';
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children Xlim inset_Xmin inset_Xmax %might want to clear other objects with re-used names too
%close(ETwinterNightU, ETSMNightU, ETPreMNightU, ETmonNightU, ETpostMNightU)

%% Section 19: Daytime ET response to relative humidity, different seasons data points
% (Probably for supplemental)
% Response of ET to relative humidity
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O all day workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O all day workspace response')
ETAllDayRH = open('allDay10.fig');
%Xlim = xlim; % Original x limits
Xlim = [4.8 100]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
Ylim = ylim;
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to x-axis label for Relative humidity
ETAllDayRH_xlabel=get(gca,'XLabel');
set(ETAllDayRH_xlabel, 'String','Relative Humidity')
% Add units to y-axis label for Relative humidity
ETAllDayRH_ylabel=get(gca,'YLabel');
set(ETAllDayRH_ylabel, 'String','ET_{daytime} (mmol m^{-2} s^{-1})')
% Make the standard deviation a darker gray
ETAllDayRH_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETAllDayRH_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter RH response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O winter day workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O winter day workspace response')
ETwinterDayRH = open('winterDay10.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
ETwinterDayRH_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETwinterDayRH_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt RH response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O snowmelt day workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O snowmelt day workspace response')
ETSMDayRH = open('snowmeltDay10.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
EThsmDayRH_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThsmDayRH_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon RH response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O premonsoon day workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O premonsoon day workspace response')
ETPreMDayRH = open('preMonsoonDay10.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
EThprMDayRH_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThprMDayRH_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon RH response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O monsoon day workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O monsoon day workspace response')
ETmonDayRH = open('monsoonDay10.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
EThmTDayRH_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThmTDayRH_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon RH response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O post-monsoon day workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O post-monsoon day workspace response')
ETpostMDayRH = open('post-monsoonDay10.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
EThpoMDayRH_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThpoMDayRH_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(ETAllDayRH, 'Children');
ax2 = get(ETwinterDayRH, 'Children');
ax3 = get(ETSMDayRH, 'Children');
ax4 = get(ETPreMDayRH, 'Children');
ax5 = get(ETmonDayRH, 'Children');
ax6 = get(ETpostMDayRH, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(ETAllDayRH)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);
            
% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend
% figure(ETAllDayRH)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
% set(legend,'Position',[.2 .5 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(ETAllDayRH) % Make 'underlying' figure for inset current
inset = axes('Position',[.18 .57 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([ET_Day_inset_Ymin ET_Day_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = ETAllDayRH;
fig_name = 'ETAllDayRH';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

%close(ETwinterDayRH, ETSMDayRH, ETPreMDayRH, ETmonDayRH, ETpostMDayRH) %close all but axis 1

%% Section 20: nighttime ET response to relative humidity, different seasons data points
% (Probably for supplemental)
% Open all Night ET air temperature response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O all night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O all night workspace response')
ETAllNightRH = open('allNight8.fig');
%Xlim = xlim; % Original x limits
Xlim = [4.8 100]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
Ylim = ylim;
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
Night_inset_Ymin = Ylim(1); %night y limits only need to be set once becz same for all day figs (x varies by variable)
Night_inset_Ymax = Ylim(2);
% Edit x-axis label for Relative humidity
ETAllNightRH_xlabel=get(gca,'XLabel');
set(ETAllNightRH_xlabel, 'String','Relative Humidity (%)')
% Edit y-axis label for Relative humidity
ETAllNightRH_ylabel=get(gca,'YLabel');
set(ETAllNightRH_ylabel, 'String','ET_{nighttime} (mmol m^{-2} s^{-1})')
% Make the standard deviation a darker gray
ETAllNightRH_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETAllNightRH_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O winter night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O winter night workspace response')
ETwinterNightRH = open('winterNight8.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
EThwNightRH_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThwNightRH_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O snowmelt night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O snowmelt night workspace response')
ETSMNightRH = open('snowmeltNight8.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
EThsmNightRH_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThsmNightRH_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O premonsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O premonsoon night workspace response')
ETPreMNightRH = open('preMonsoonNight8.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
EThprMNightRH_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThprMNightRH_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O monsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O monsoon night workspace response')
ETmonNightRH = open('monsoonNight8.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
ETmonNightRH_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETmonNightRH_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O post-monsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O post-monsoon night workspace response')
ETpostMNightRH = open('post-monsoonNight8.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
EThpoMNightRH_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThpoMNightRH_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(ETAllNightRH, 'Children');
ax2 = get(ETwinterNightRH, 'Children');
ax3 = get(ETSMNightRH, 'Children');
ax4 = get(ETPreMNightRH, 'Children');
ax5 = get(ETmonNightRH, 'Children');
ax6 = get(ETpostMNightRH, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(ETAllNightRH)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'b)',...
                'FontSize',16);

% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend
% figure(ETAllNightRH)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
% set(legend,'Position',[.15 .67 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(ETAllNightRH) % Make 'underlying' figure for inset current
inset = axes('Position',[.19 .55 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
%Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
ylim([-5 Night_inset_Ymax+.5])
% %define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'d. Period ANNs',...
        'FontSize',16);
else
end
            
% Set figure size and save as .fig
cd(fig_dir)
fig = ETAllNightRH;
fig_name = 'ETAllNightRH';
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children Xlim inset_Xmin inset_Xmax %might want to clear other objects with re-used names too
%close(ETwinterNightRH, ETSMNightRH, ETPreMNightRH, ETmonNightRH, ETpostMNightRH)

%% Section 21: Daytime ET response to PAR, different seasons data points
% (Probably for supplemental)
% Response of ET to PAR

cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O all day workspace response')
ETAllDayPAR = open('allDay8.fig');
Xlim = xlim; %Since PaR is not a night driver, leaving original xlim
Ylim = ylim;
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to x-axis label for PAR
ETAllDayPAR_xlabel=get(gca,'XLabel');
set(ETAllDayPAR_xlabel, 'String','Incoming PAR (\mumol m^{-2} s^{-1})')
% Edit y-axis label
ETAllDayPAR_ylabel=get(gca,'YLabel');
set(ETAllDayPAR_ylabel,'String','ET_{daytime} (mmol m^{-2} s^{-1})')
% Make the standard deviation a darker gray
ETallDayPAR_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETallDayPAR_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter PAR response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O winter day workspace response')
ETwinterDayPAR = open('winterDay8.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
ETwinterDayPAR_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETwinterDayPAR_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt PAR response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O snowmelt day workspace response')
ETSMDayPAR = open('snowmeltDay8.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
EThsmDayPAR_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThsmDayPAR_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon PAR response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O premonsoon day workspace response')
ETPreMDayPAR = open('preMonsoonDay8.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
EThprMDayPAR_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThprMDayPAR_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon PAR response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O monsoon day workspace response')
ETmonDayPAR = open('monsoonDay8.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
EThmTDayPAR_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThmTDayPAR_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon PAR response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O post-monsoon day workspace response')
ETpostMDayPAR = open('post-monsoonDay8.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
EThpoMDayPAR_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThpoMDayPAR_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(ETAllDayPAR, 'Children');
ax2 = get(ETwinterDayPAR, 'Children');
ax3 = get(ETSMDayPAR, 'Children');
ax4 = get(ETPreMDayPAR, 'Children');
ax5 = get(ETmonDayPAR, 'Children');
ax6 = get(ETpostMDayPAR, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(ETAllDayPAR)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);
            
% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend
% figure(ETAllDayPAR)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
% set(legend,'Position',[.2 .5 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(ETAllDayPAR) % Make 'underlying' figure for inset current
inset = axes('Position',[.18 .57 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([ET_Day_inset_Ymin ET_Day_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = ETAllDayPAR;
fig_name = 'ETAllDayPAR';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

close(ETwinterDayPAR, ETSMDayPAR, ETPreMDayPAR, ETmonDayPAR, ETpostMDayPAR) %close all but axis 1

%% Section 22: Nighttime ET response to wind speed, different seasons data points
% (Probably for supplemental)
% Open all Night ET air Wind speed response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O all night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O all night workspace response')
ETAllNightWS = open('allNight2.fig');
Xlim = xlim; % Original x limits
Xlim = [.33 19.5]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
Ylim = ylim;
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
Night_inset_Ymin = Ylim(1); %night y limits only need to be set once becz same for all day figs (x varies by variable)
Night_inset_Ymax = Ylim(2);
% Edit x-axis label for Wind speed
ETAllNightWS_xlabel=get(gca,'XLabel');
set(ETAllNightWS_xlabel, 'String','Wind speed (m s^{-1})')
% Edit y-axis label for Wind speed
ETAllNightWS_ylabel=get(gca,'YLabel');
set(ETAllNightWS_ylabel, 'String','ET_{nighttime} (mmol m^{-2} s^{-1})')
% Make the standard deviation a darker gray
ETAllNightWS_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETAllNightWS_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O winter night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O winter night workspace response')
ETwinterNightWS = open('winterNight2.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
EThwNightWS_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThwNightWS_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O snowmelt night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O snowmelt night workspace response')
ETSMNightWS = open('snowmeltNight2.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
EThsmNightWS_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThsmNightWS_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O premonsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O premonsoon night workspace response')
ETPreMNightWS = open('preMonsoonNight2.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
EThprMNightWS_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThprMNightWS_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O monsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O monsoon night workspace response')
ETmonNightWS = open('monsoonNight2.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
EThmTNightWS_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThmTNightWS_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O post-monsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O post-monsoon night workspace response')
ETpostMNightWS = open('post-monsoonNight2.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
EThpoMNightWS_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThpoMNightWS_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(ETAllNightWS, 'Children');
ax2 = get(ETwinterNightWS, 'Children');
ax3 = get(ETSMNightWS, 'Children');
ax4 = get(ETPreMNightWS, 'Children');
ax5 = get(ETmonNightWS, 'Children');
ax6 = get(ETpostMNightWS, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(ETAllNightWS)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'b)',...
                'FontSize',16);

% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend
% figure(ETAllNightWS)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
% set(legend,'Position',[.15 .67 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(ETAllNightWS) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .61 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph 
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
%Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
ylim([-5 Night_inset_Ymax+.5])
% %define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'d. Period ANNs',...
        'FontSize',16);
else
end
            
% Set figure size and save as .fig
cd(fig_dir)
fig = ETAllNightWS;
fig_name = 'ETAllNightWS';
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children Xlim inset_Xmin inset_Xmax %might want to clear other objects with re-used names too
close(ETwinterNightWS, ETSMNightWS, ETPreMNightWS, ETmonNightWS, ETpostMNightWS)

%% Section 23: Daytime ET response to wind speed, different seasons data points
% (Probably for supplemental)
% Response of ET to PAR

cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O all day workspace response')
ETAllDayWS = open('allDay2.fig');
%Xlim = xlim; % original
Xlim = [.33 19.5]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
Ylim = ylim;
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
% Add units to x-axis label for WS
ETAllDayWS_xlabel=get(gca,'XLabel');
set(ETAllDayWS_xlabel, 'String','Wind Speed (m s^{-1})')
% Edit y-axis label
ETAllDayWS_ylabel=get(gca,'YLabel');
set(ETAllDayWS_ylabel,'String','ET_{daytime} (mmol m^{-2} s^{-1})')
% Make the standard deviation a darker gray
ETAllDayWS_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETAllDayWS_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter WS response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O winter day workspace response')
ETwinterDayWS = open('winterDay2.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
ETwinterDayWS_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETwinterDayWS_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt WS response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O snowmelt day workspace response')
ETSMDayWS = open('snowmeltDay2.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
ETSMDayWS_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETSMDayWS_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon WS response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O premonsoon day workspace response')
ETPreMDayWS = open('preMonsoonDay2.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
EThprMDayWS_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThprMDayWS_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon WS response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O monsoon day workspace response')
ETmonDayWS = open('monsoonDay2.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
EThmTDayWS_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThmTDayWS_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon WS response
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O post-monsoon day workspace response')
ETpostMDayWS = open('post-monsoonDay2.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
ETpostMDayWS_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETpostMDayWS_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(ETAllDayWS, 'Children');
ax2 = get(ETwinterDayWS, 'Children');
ax3 = get(ETSMDayWS, 'Children');
ax4 = get(ETPreMDayWS, 'Children');
ax5 = get(ETmonDayWS, 'Children');
ax6 = get(ETpostMDayWS, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(ETAllDayWS)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);
            
% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend
% figure(ETAllDayWS)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
% set(legend,'Position',[.2 .5 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(ETAllDayWS) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .61 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
% %Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
%xlim([-6 inset_Xmax])
ylim([ET_Day_inset_Ymin ET_Day_inset_Ymax])
% define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end

% Set figure size and save as .fig
cd(fig_dir)
fig = ETAllDayWS;
fig_name = 'ETAllDayWS';
% set(gcf,'PaperPositionMode','manual', 'PaperUnits','centimeters','PaperPosition', [10 10 figxwidth figywidth]) %One possibility, but it seems to include some white space and make figure too small
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

close(ETwinterDayWS, ETSMDayWS, ETPreMDayWS, ETmonDayWS, ETpostMDayWS)


%% Section 24: Nighttime ET response to VPD, different seasons data points
% (Probably for supplemental)
% Open all Night ET air Wind speed response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O all night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O all night workspace response')
ETAllNightVPD = open('allNight6.fig');
Xlim = xlim; % Original x limits
%Xlim = [0.01 2.3]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
Ylim = ylim;
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
Night_inset_Ymin = Ylim(1); %night y limits only need to be set once becz same for all day figs (x varies by variable)
Night_inset_Ymax = Ylim(2);
% Edit x-axis label for Wind speed
ETAllNightVPD_xlabel=get(gca,'XLabel');
set(ETAllNightVPD_xlabel, 'String','VPD (kPa)')
% Edit y-axis label for Wind speed
ETAllNightVPD_ylabel=get(gca,'YLabel');
set(ETAllNightVPD_ylabel, 'String','ET_{nighttime} (mmol m^{-2} s^{-1})')
% Make the standard deviation a darker gray
ETallNightVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETallNightVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O winter night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O winter night workspace response')
ETwinterNightVPD = open('winterNight6.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
ETwinterNightVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETwinterNightVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O snowmelt night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O snowmelt night workspace response')
ETSMNightVPD = open('snowmeltNight6.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
EThsmNightVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThsmNightVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O premonsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O premonsoon night workspace response')
ETPreMNightVPD = open('preMonsoonNight6.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
EThprMNightVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThprMNightVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O monsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night no SWE 1999-2013/H2O monsoon night workspace response')
ETmonNightVPD = open('monsoonNight6.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
EThmTNightVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThmTNightVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O post-monsoon night workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Night with SWE 1999-2013/H2O post-monsoon night workspace response')
ETpostMNightVPD = open('post-monsoonNight6.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
EThpoMNightVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThpoMNightVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(ETAllNightVPD, 'Children');
ax2 = get(ETwinterNightVPD, 'Children');
ax3 = get(ETSMNightVPD, 'Children');
ax4 = get(ETPreMNightVPD, 'Children');
ax5 = get(ETmonNightVPD, 'Children');
ax6 = get(ETpostMNightVPD, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(ETAllNightVPD)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'b)',...
                'FontSize',16);

% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend
% figure(ETAllNightVPD)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
% set(legend,'Position',[.15 .67 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(ETAllNightVPD) % Make 'underlying' figure for inset current
inset = axes('Position',[.59 .61 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph 
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
%Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
ylim([-5 Night_inset_Ymax+.5])
% %define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'d. Period ANNs',...
        'FontSize',16);
else
end
            
% Set figure size and save as .fig
cd(fig_dir)
fig = ETAllNightVPD;
fig_name = 'ETAllNightVPD';
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children Xlim inset_Xmin inset_Xmax %might want to clear other objects with re-used names too
close(ETwinterNightVPD, ETSMNightVPD, ETPreMNightVPD, ETmonNightVPD, ETpostMNightVPD)

%% Section 25: Daytime ET response to VPD, different seasons data points

% (Probably for supplemental)
% Open all Day ET air VPD
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O all day workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O all day workspace response')
ETAllDayVPD = open('allDay6.fig');
Xlim = xlim; % Original x limits
%Xlim = [0.01 2.3]; % Make x-limits the same for day and night (for reviewer 1). HARD-CODED
Ylim = ylim;
inset_Xmin = Xlim(1);
inset_Xmax = Xlim(2);
Day_inset_Ymin = Ylim(1); %day y limits only need to be set once becz same for all day figs (x varies by variable)
Day_inset_Ymax = Ylim(2);
% Edit x-axis label for Wind speed
ETAllDayVPD_xlabel=get(gca,'XLabel');
set(ETAllDayVPD_xlabel, 'String','VPD (kPa)')
% Edit y-axis label for Wind speed
ETAllDayVPD_ylabel=get(gca,'YLabel');
set(ETAllDayVPD_ylabel, 'String','ET_{Daytime} (mmol m^{-2} s^{-1})')
% Make the standard deviation a darker gray
ETallDayVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(ETallDayVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open winter u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O winter day workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O winter day workspace response')
ETwinterDayVPD = open('winterDay6.fig');
% Make changes to period figures before copying onto all data figure
hw = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hw,'MarkerFaceColor',brbg_brown1);
% Make the standard deviation a darker gray
EThwDayVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThwDayVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open Snow Melt u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O snowmelt day workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O snowmelt day workspace response')
ETSMDayVPD = open('snowmeltDay6.fig');
% Make changes to period figures before copying onto all data figure
hsm = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hsm,'MarkerFaceColor',brbg_brown2);
% Make the standard deviation a darker gray
EThsmDayVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThsmDayVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open pre-monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O premonsoon day workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O premonsoon day workspace response')
ETPreMDayVPD = open('preMonsoonDay6.fig');
% Make changes to period figures before copying onto all data figure
hprM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hprM,'MarkerFaceColor',brbg_blue1);
% Make the standard deviation a darker gray
EThprMDayVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThprMDayVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O monsoon day workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day no SWE 1999-2013/H2O monsoon day workspace response')
ETmonDayVPD = open('monsoonDay6.fig');
% Make changes to period figures before copying onto all data figure
hmT = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hmT,'MarkerFaceColor',brbg_blue2);
% Make the standard deviation a darker gray
EThmTDayVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThmTDayVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% Open post-monsoon u* response
%cd('/Users/lalbert/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O post-monsoon day workspace response')
cd('/Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/response curves/ET response/H2O Day with SWE 1999-2013/H2O post-monsoon day workspace response')
ETpostMDayVPD = open('post-monsoonDay6.fig');
% Make changes to period figures before copying onto all data figure
hpoM = findobj(gcf,'Type','Line','Marker','o','LineStyle','none'); %find 'points' (only line with marker)
set(hpoM,'MarkerFaceColor',brbg_blue3);
% Make the standard deviation a darker gray
EThpoMDayVPD_SD = findobj(gcf,'Type','Area','FaceColor',[0.8700 0.8700 0.8700]);
set(EThpoMDayVPD_SD, 'FaceColor',[0.8, 0.8, 0.8]);

% name axes for all figures
ax1 = get(ETAllDayVPD, 'Children');
ax2 = get(ETwinterDayVPD, 'Children');
ax3 = get(ETSMDayVPD, 'Children');
ax4 = get(ETPreMDayVPD, 'Children');
ax5 = get(ETmonDayVPD, 'Children');
ax6 = get(ETpostMDayVPD, 'Children');

% Get 'children' from all figures to have something copied
ax2Children = get(ax2(:),'Children');
ax3Children = get(ax3(:),'Children');
ax4Children = get(ax4(:),'Children');
ax5Children = get(ax5(:),'Children');
ax6Children = get(ax6(:),'Children');

% copy over colored scatter points
copyobj(ax2Children(3), ax1(:));
copyobj(ax3Children(3), ax1(:));
copyobj(ax4Children(3), ax1(:));
copyobj(ax5Children(3), ax1(:));
copyobj(ax6Children(3), ax1(:));

% Move all periods ANN line on top of points
ax1Children = get(ax1(:),'Children');
h = ax1Children(7); %ANN line is currently 7th (layer?)
uistack(h,'top')

% Edit text label on axis 1 by deleting (then replacing?)
delete(ax1Children(6))
figure(ETAllDayVPD)
psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*97;  %Position label 97% up y axis
psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/100)*2;    %Position label 2% along x axis
text(psin_txt_x,psin_txt_y,'a)',...
                'FontSize',16);

% Set main figure x-axis
xlim([Xlim(1) Xlim(2)])
            
% % Add legend
% figure(ETAllDayVPD)
% legend(ax1Children(5:-1:1),'Winter','Snowmelt','Pre-monsoon','Monsoon','Post-monsoon','Box','off')
% legend('boxoff') %This works, but only when ax1 is current axis. figure(AllDayT) should make it current
% set(legend,'Position',[.15 .67 .198 .145]);

% Inset: Add ANN line(s) & SD from periods of interest
figure(ETAllDayVPD) % Make 'underlying' figure for inset current
inset = axes('Position',[.6 .17 .3 .3]); %Create graphics object [left bottom width height] units normalized to graph 
set(gca, ...
    'Box'         , 'on'     , ...
    'TickDir'     , 'out'     ); %set axis properties
h2sd = copyobj(ax2Children(4), inset); %standard deviation layer winter
h3sd = copyobj(ax3Children(4), inset); %standard deviation layer snowmelt
h4sd = copyobj(ax4Children(4), inset); %standard deviation layer Premonsoon
h5sd = copyobj(ax5Children(4), inset); %standard deviation layer mon
h6sd = copyobj(ax6Children(4), inset); %standard deviation layer postM
h2ann = copyobj(ax2Children(2), inset); %ANN layer winter
set(h2ann,'Color',brbg_brown1);
h3ann = copyobj(ax3Children(2), inset); %ANN layer snowmelt
set(h3ann,'Color',brbg_brown2);
h4ann = copyobj(ax4Children(2), inset); %ANN layer Premonsoon
set(h4ann,'Color',brbg_blue1);
h5ann = copyobj(ax5Children(2), inset); %ANN layer monsoon
set(h5ann,'Color',brbg_blue2);
h6ann = copyobj(ax6Children(2), inset); %ANN layer postmonsoon
set(h6ann,'Color',brbg_blue3);
%Set inset x and y limits.
xlim([inset_Xmin inset_Xmax]) %same as all data ANN plot
ylim([-5 Day_inset_Ymax+.5])
% %define where to place text and add text there
if label_insets == 1
    psin_txt_y = min(ylim) + ((max(ylim)-min(ylim))/100)*92;  %Position label 92% up y axis
    psin_txt_x = min(xlim) + ((max(xlim)-min(xlim))/10);    %Position label 10% along x axis
    text(psin_txt_x,psin_txt_y,'b. Period ANNs',...
        'FontSize',16);
else
end
            
% Set figure size and save as .fig
cd(fig_dir)
fig = ETAllDayVPD;
fig_name = 'ETAllDayVPD';
set(gcf, 'PaperPositionMode', 'auto'); % Makes figure same size as on screen , but saves with white space  
savefig(fig, fig_name)

clear fig ax1 ax2 ax3 ax4 ax5 ax6 ax1Children ax2Children ax3Children ax4Children...
    ax5Children ax6Children Xlim inset_Xmin inset_Xmax %might want to clear other objects with re-used names too
close(ETwinterDayVPD, ETSMDayVPD, ETPreMDayVPD, ETmonDayVPD, ETpostMDayVPD)
