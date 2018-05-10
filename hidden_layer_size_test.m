% Hidden layer number test script
% Loren Albert
% Summer 2014
% Updated winter 2016
%
% This script is intended to find a good hidden layer size for ANNs for the
% Niwot Ridge ANN project.

% Instructions/to do:
% 1) comment out hidden layer size in all that are run by
% master_neuralNetDriverAnalysis that you want to apply this exploration to
%
% 2) set all relevant settings (month, drivers, etc in
% master_neuralNetDriverAnalysis and it's subscripts.
% 
% 3) comment/uncomment appropriate definition of hidden_size_summary_ds (see where it
% says 'use this for 12 drivers' or 'use this for 10 drivers' in two places
% below.
%
% 4) Figures need to be saved manually. The 'name_hid_test_fig' contains
% useful info to use as part of the .fig name.

cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/MatlabScripts_from_TK/notSoSimple')

%Thinking of looping it through all eco periods
%eco_pheno_periods={'winter','snowmelt','preMonsoon','monsoon','post-monsoon'};

% Create vector for use with for loop. Currently repeats each hidden layer size 10 times
temp1 = repmat((1:12),10,1);
hid_size_vec = reshape(temp1,120,1);

% Run master_neuralNetDriverAnalysis.m and extract hidden layer size,
% benchmark, and primary r^2
hidden_size_summary=zeros(14,length(hid_size_vec))'; %use this one for 12 drivers
% hidden_size_summary=zeros(12,length(hid_size_vec))'; %use this one for 10 drivers

%for hid = 1:15
for hid = 1:length(hid_size_vec)
    hiddenLayerSize = hid_size_vec(hid);
    run master_neuralNetDriverAnalysis.m
    hidden_size_summary(hid,1) = hiddenLayerSize;
    hidden_size_summary(hid,2) = r2_benchmark;
    hidden_size_summary(hid,3:(2+length(B))) = B(1,:);
    % Note that 'B' is already sorted so the first single driver r2 in that
    % object was from the 'best' single driver
end

%make function handle for population standard deviation 
%https://www.mathworks.com/matlabcentral/answers/181888-grpstats-flexibility-for-additional-functions
popStd_fh = @(y) std(y,1); % make a function handle that computes pop. std.

% Calculate means and population standard deviations from runs
% Use these two lines for 12 drivers:
hidden_size_summary_ds = mat2dataset(hidden_size_summary,'VarNames',{'hiddenLayerSize',...
'r2_benchmark','D1','D2','D3','D4','D5','D6','D7','D8','D9','D10','D11','D12'});
% Use these two lines for 10 drivers:
%hidden_size_summary_ds = mat2dataset(hidden_size_summary,'VarNames',{'hiddenLayerSize',...
% 'r2_benchmark','D1','D2','D3','D4','D5','D6','D7','D8','D9','D10'});
% Calculate stats For benchmark r^2
hidden_size_summary_stat = grpstats(hidden_size_summary_ds,'hiddenLayerSize',{'mean',popStd_fh, 'max'},'DataVars',{'r2_benchmark'});
hidden_size_summary_statd = double(hidden_size_summary_stat);
% Calculate stats For top single driver (could add other drivers, D2, D3, etc... ranked, see master_NeuralNetDriverAnalysis 'B' and 'IX' objects)
TopD_hid_size_stat = grpstats(hidden_size_summary_ds,'hiddenLayerSize',{'mean',popStd_fh, 'max'},'DataVars',{'D1'});
TopD_hid_size_stat_statd = double(TopD_hid_size_stat);

% Plot the performance versus hidden layer size for benchmark
f1 = figure();
errorbar(hidden_size_summary_statd(:,1),hidden_size_summary_statd(:,3), hidden_size_summary_statd(:,4),...
    'LineWidth',2,...
    'Color',[.4 .4 .4]);
hold on
plot(hidden_size_summary_statd(:,1),hidden_size_summary_statd(:,5),'.', 'MarkerSize', 12)
hold off
xlabel ('Nodes in Hidden Layer', 'fontsize', 14)
ylabel('Benchmark r^2', 'fontsize', 14)
set(gca, ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02])

% Plot the performance versus hidden layer size for top driver (D1)
f2 = figure();
errorbar(TopD_hid_size_stat_statd(:,1),TopD_hid_size_stat_statd(:,3), TopD_hid_size_stat_statd(:,4),...
    'LineWidth',2,...
    'Color',[.4 .4 .4]);
hold on
plot(TopD_hid_size_stat_statd(:,1),TopD_hid_size_stat_statd(:,5),'.', 'MarkerSize', 12)
hold off
xlabel ('Nodes in Hidden Layer', 'fontsize', 14)
ylabel('Single driver r^2', 'fontsize', 14)
set(gca, ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02])

% Review what these runs were and make name for a figure (right now copying
% and pasting with manual save)
name_hid_test_fig = strcat('hid_size_test_',month,'_HD',num2str(HD),'_TAR',num2str(TAR));
