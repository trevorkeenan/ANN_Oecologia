close all

%% Plot
figure1=figure('Menubar','none');

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

%output controls copied from http://stackoverflow.com/questions/7561999/how-to-set-the-plot-in-matlab-to-a-specific-size
%# centimeters units
X = 42.0;                  %# A3 paper size
Y = 29.7;                  %# A3 paper size
xMargin = 1;               %# left/right margins from page borders
yMargin = 1;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)

%# figure size displayed on screen (50% scaled, but same aspect ratio)
set(figure1, 'Units','centimeters', 'Position',[0 0 xSize ySize]/2)
movegui(figure1, 'center')

%# figure size printed on paper
set(figure1, 'PaperUnits','centimeters')
set(figure1, 'PaperSize',[X Y])
set(figure1, 'PaperPosition',[xMargin yMargin xSize ySize])
set(figure1, 'PaperOrientation','portrait')

%# export to PDF and open file
print -dpdf -r0 Example_ANN_graph.pdf
winopen Example_ANN_graph.pdf
