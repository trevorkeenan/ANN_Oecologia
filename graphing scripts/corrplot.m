function h = corrplot(x,varlbl,vx)
%   h = corrplot(X,VARLBL,VX) draws correlation coefficients with 95 %
%   confidence intervals for simultaneous complete observations. (Refer to 
%   the corrcoef function with options 'rows'/'complete'.)
%   The data is a matrix X with variables as columns
%   and rows as observations. VARLBL is the variable names as a cell vector 
%   of strings. IF VARLBL is absent or empty, corrplot assigns variable
%   names. If VX is 'f', only the correlation between the first variable
%   (column) is plotted. If VX is 'a', all combinations are plotted. Default
%   is 'f';
%
% LPA note: script from http://www.mathworks.com/matlabcentral/fileexchange/35674-corrplot/content/cp/corrplot.m
% % Example 1:
%   x = rand(40,3);     % some data: 3 variables with 40 observations each
%   p = randperm(3*40); % generate random numbers up to the number of elements in x
%   x(p(1:10)) = nan;   % delete ten elements in x taken randomly
%   corrplot(x)         % let corrplot do the rest
%
% % Example 2:
%   corrplot(x,[],'a')  % all possible combinations of the variables
%
% % Example 3:
%   corrplot(x,{'Ilex' 'Pinus' 'Betula'},'a')   % naming the variables
%
% % Real example:
% % Load population data for Sweden 1749-1800. The data is from Statistics
% % Sweden, www.scb.se
%   load folk.mat
% % The first column is the year, the second is population at the end of
% % the year, the third is number of born and the fourth the number of
% % deceased. First, we must compute the change in population rather than
% % the population itself. Lets make a copy of folk
%
% x = folk;
%
% % Exchange the population for the difference in population. For the first year
% % 1749 we must insert nan since we dont know the population 1748.
%
% x(:,2) = [nan; diff(folk(:,2))];
%
% % Let us investigate the pairwise correlations, all possibilities
%
% corrplot(x(:,2:4),{'popchange' 'born' 'dead'},'a')
%
% % As expected there is a positice correlation between the change in
% % population and the number of born children. The correlation between the
% % number of dead and the population change is even stronger and
% % well-determined as can be seen on the small confidence interval. There
% % appears to be a slight negative correlation between the number of born
% % and the number of dead which is somewhat surprising. Let us look directly
% % at the data for a clue
%
% plot(x(:,1),x(:,2:4)), legend('popchange','born','dead')
%
% % The plot reveals a deviating year 1773. There was a terrible famine in
% % Sweden that year. To see the effect of this year alone, lets study the
% % correlation without it
%
% corrplot(x(x(:,1) ~= 1773,2:4),{'popchange' 'born' 'dead'},'a')
%
% % The correlation between born and dead has changed visibly towards weaker, 
% % however not necessarily significantly on this level of confidence. Lets
% % investigate if the population changes only because people are born and
% % die by subtracting those and comparing. Since we primarily want to check
% % the correlation of the population change, we choose a reduced number of
% % correlation bars with the 'f' option
%
% corrplot([x(:,2:4), x(:,3)-x(:,4)],{'popchange' 'born' 'dead' 'born-dead'},'f')
%
% % By zooming in on the last bar we can see that it is slightly below 1.
% % This is beacause born-dead dont account for the whole change. Migration
% % contributes. In the period 1875-1925 migration dominates and
% % changes the correlation pattern completely. (You find these data in
% % the variable more_folk.)

%   Lasse Johansson, AQ System 2012-03-15, lasse@aqs.se

nvar = size(x,2);
if nvar == 1
    disp('X must have at least two variables (columns) for the correlation to make sense')
    return
end
if nargin == 1
    for jj = 1:nvar
        varlbl{jj} = num2str(jj);
    end
    vx = 'f';
elseif nargin == 2
    for jj = 1:nvar
        lbl{jj} = [varlbl{1},'&',varlbl{jj}];
    end
    vx = 'f';
elseif nargin == 3
    if isempty(varlbl)
        for jj = 1:nvar
            varlbl{jj} = num2str(jj);
        end
    end
end
[r,~,rlo,rup] = corrcoef(x,'rows','complete');
rlo = rlo -r;
rup = rup -r;

switch lower(vx)
    case 'f'
        N = 1;
    case 'a'
        N = nvar-1;
end

Y = []; L = []; U = [];
m = 1;
for jj = 1:N
    Y = [Y, r(jj,jj+1:nvar)];
    L = [L, rlo(jj,jj+1:nvar)];
    U = [U, rup(jj,jj+1:nvar)];    
    for kk = jj+1:nvar
        lbl{m} = [varlbl{jj},'&',varlbl{kk}];
        m = m+1;
    end
    X = 1:length(Y);
end

hh = errorbar(X,Y,L,U,'s');
set(gca, 'xtick', X, 'xticklabel',lbl)
if nargout == 1
    h = hh;
end

