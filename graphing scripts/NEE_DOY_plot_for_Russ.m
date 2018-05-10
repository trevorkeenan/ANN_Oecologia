% Loren Albert
% Fall 2015
%
% Script to plot NEE versus DOY (sums of half hourly data) for Niwot Ridge
% for Russ.

figure('color','white','PaperOrientation','portrait');
hRuss=plot(Sum_NEP_DS(:,4));

% Add labels for bottom graph
xlabel('Days','Fontsize', SmallFont)
ylabel('Net ecosystem exchange', 'Fontsize', SmallFont)