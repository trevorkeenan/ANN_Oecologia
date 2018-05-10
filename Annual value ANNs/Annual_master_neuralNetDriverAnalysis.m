% this script will...
% Run an ANN on the observations with:
%   1. All drivers together (benchmark)
%   2. Each driver individually (find the best)
%   3. Best + each driver individually (find the second best)

% written by T.F. Keenan, March 2013 (keenan_trevor@yahoo.ie)
% 
% Adapted by Loren Albert April 2014
% I wanted to try running an ANN on data from each year of data (annual
% values).  I adapted/debugged this script through section 2 where it makes
% the benchmark.  However, I don't think that there is enough data of
% annual values to make this work well.... r^2 of all data very low.
% Didn't keep debugging past that point.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% set the number of ANNs to run for each ensemble
numRuns=10;

saveFigures=1;

% set the name of the site (used for reading in data)
filename={'annual_values_ANN_input'};


% load the data if need be

if ~exist('NEEobsMod','var')
    run ./Annual_loadObsAndDrivers.m
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Benchmark the isoprene fluxes
%   This involves running the ANN with all available drivers to assess what
%   the best performance is.
%   Residuals can be thought of as data error

run ./Annual_neuralNet_benchmark.m

%%
figure1=figure;
% Create axes
axes1 = axes('Parent',figure1,'FontSize',20);
hold(axes1,'all');

plot(targets,'k.','LineWidth',2,'DisplayName','OBS')
hold on
plot(outputBenchmark,'r.','DisplayName','ANN')
l1=legend('show');
xlim([0 length(outputBenchmark)])
xlabel('Day since start')
ylabel('Daily NEE')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. Run with each Driver individually

run ./Annual_neuralNet_OneDriver.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. Select best Driver

[B,IX] = sort(r2,'descend');

IX(B==0)=[];
B(B==0)=[];

fields=fieldnames(columns);

for i = 1:numel(fields)
    columnValue(i)=columns.(fields{i});
end

for i=1:length(IX)
    IX2=(columnValue==IX(i));
    orderedDriver{i}=fields{IX2==1};
    
end

%%%%%% PLOT
scrsz = get(0,'ScreenSize');
figure1 =figure('Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)/2.5]);

fsize=22;
% Create axes
axes1 = axes('Parent',figure1,...
    'XTickLabel',orderedDriver(:),...
    'XTick',1:length(orderedDriver),'FontSize',fsize);
hold(axes1,'all');

% hold on
bar(B)
xlim([0 length(orderedDriver)+1])

% plot the best we can expect from the benchmark
l1=line([0;length(orderedDriver)+1],[r2_benchmark;r2_benchmark]);
set(l1,'LineStyle','--','color','k')

xticklabel_rotate([],45,[],'Fontsize',fsize,'interpreter','none')
% set(gca,'XTickLabel',orderedDriver)
% ylim([0.7 1])
ylabel('r^2')
xlabel('Predictor')
hold off
title('Each driver individually')

if saveFigures==1
    set(gcf, 'PaperPositionMode', 'auto');
    
    filename=strcat('./Graphs/compareAllPredictors');
    print(figure1,'-deps', filename);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. Run again with best driver and all other drivers

run ./Annual_neuralNet_bestPlusOneDriver.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. Order the best driver combinations

[Bb,IXb] = sort(r2b,'descend');

IXb(Bb==0)=[];
Bb(Bb==0)=[];

fields=fieldnames(columns);

for i = 1:numel(fields)
    columnValue(i)=columns.(fields{i});
end

for i=1:length(IXb)
    IX2b=(columnValue==IXb(i));
    orderedDriverb{i}=fields{IX2b==1};
    
end


%%%%%% PLOT
scrsz = get(0,'ScreenSize');
figure1 =figure('Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)/2.5]);

fsize=22;
% Create axes

tmp=orderedDriverb(:);
axes1 = axes('Parent',figure1,...
    'XTickLabel',tmp(:),...
    'XTick',1:length(orderedDriverb),'FontSize',fsize);
hold(axes1,'all');

% hold on
bar(Bb)
xlim([0 length(orderedDriverb)+1])

% plot the best we can expect from the benchmark
l1=line([0;length(orderedDriverb)+1],[r2_benchmark;r2_benchmark]);
set(l1,'LineStyle','--','color','k')

% plot the best we can expect from just one driver
l1=line([0;length(orderedDriverb)+1],[max(r2);max(r2)]);
set(l1,'LineStyle','--','color','k')

xticklabel_rotate([],45,[],'Fontsize',fsize,'interpreter','none');
ylim([0 1])
ylabel('r^2')
xlabel('Predictor')
title('Best driver + one')

hold off



if saveFigures==1
    set(gcf, 'PaperPositionMode', 'auto');
    
    filename=strcat('./Graphs/compareBestPlusOnePredictors');
    print(figure1,'-deps', filename);
end


%% Display some useful reference info
disp(['Year start: ', num2str(yearStart), '; Year end: ', num2str(yearEnd)])
disp(['Number of runs: ', num2str(numRuns)])
%disp([num2str(DayStartMat)]) %Would be good to make this conditional on existence
disp(['For each year, start date: ', num2str(yearStart), '; stop date: ', num2str(yearEnd)])
% Display names of drivers (code to make table is in 'loadObsAndDrivers')
Table_driver_names_num
