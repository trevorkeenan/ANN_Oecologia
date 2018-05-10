% This script calculates the 'population' standard deviation (normalized by
% n instead of n-1).  Can be used on workspaces of runs for each individual
% year or workspaces of coninuous years (e.g. 1999-2013).
% 
% In the case of the 10 model runs for single driver inputs, this is what 
% I want:
% std_all_r2_oneDriver_pop(1,driverIndex)=std(numruns_r2_oneDriver,1)
% But in many workspaces I have instead
% std_all_r2_oneDriver(1,driverIndex)=std(numruns_r2_oneDriver);
% This script works with saved workspaces to calculate what
% std_all_r2_benchmark_pop would be.  (I checked the math with the
% commented out example below).

%Uncomment to check if driver index changed (which it shouldn't if I used run_all_periods_each_year)
find(std_all_r2_oneDriver);
find(std_all_r2_b);

% Conversion from 'sample' std deviation to 'population' std deviation
% sqrt((s^2(n-1))/n) = ?
% where s is sample standard deviation, n is sample size, ? is population
% standard deviation.
% example=[1,2,3,8,7];
% var_s = var(example);
% var_sigma = var(example,1);
% std_s = std(example);
% std_sigma = std(example,1);
% n = 5;
% test_sigma=sqrt(((std_s^2)*(n-1)/n)); % works!

% Conversion for standard deviation for single inputs (from neuralNet_OneDriver)
std_pop=[];
for ss = 1:length(std_all_r2_oneDriver)
        std_pop_col_name=ss;
        std_s=std_all_r2_oneDriver(ss);
        n=numRuns;
        std_pop_val=sqrt(((std_s^2)*(n-1)/n));
        std_pop_col=[std_pop_col_name; std_pop_val];
        std_pop = [std_pop std_pop_col];
end

out=std_pop;
out(:,any(std_pop==0,1)) = [];
std_all_r2_oneDriver_pop_converted=out;

% Conversion for standard deviation for two inputs (from neuralNet_bestPlusOneDriver)
std_pop_b=[];
for ss = 1:length(std_all_r2_b)
        std_pop_col_name=ss;
        std_s=std_all_r2_b(ss);
        n=numRuns;
        std_pop_val=sqrt(((std_s^2)*(n-1)/n));
        std_pop_col=[std_pop_col_name; std_pop_val];
        std_pop_b = [std_pop_b std_pop_col];
end

out_b=std_pop_b;
out_b(:,any(std_pop_b==0,1)) = [];
std_all_r2_b_pop_converted=out_b;

% Calculate population standard deviation for benchmark
std_all_r2_benchmark_pop=std(numruns_r2_benchmark,1); %This is what I want--'population' standard deviation (normalized by n).
