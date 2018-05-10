% This script will save the workspace variables for Niwot Ridge project
% This script is run inside the master_neuralNetDriverAnalysis script
% Workspaces are saved in directory set below.  Directory depends
% on whether using consecutive or non-consecutive years). Script automatically 
% changes which directory workspaces are saved in, based on
% options in 'loadObsAndDrivers'.  However, I still manually moved workspace
% files from 'Eco Pheno Workspaces' into subfolders.
% Note: ANN runs with water flux as the target variable have_H2O in name.
% Otherwise target was NEE.


if year_consecutive==0
    work_space_dir = '/Users/lpapgm/Desktop/Niwot Results draft2/Results graphs/non-consecutive years/Eco Pheno Workspaces';
elseif year_consecutive==1
    work_space_dir = '/Users/lpapgm/Desktop/Niwot Results draft2/Results graphs/Consecutive years/Eco Pheno Workspaces';
end

cd(work_space_dir)
if year_consecutive==1
    if exist('eco_pheno_periods','var')
        if TAR ==0
            if HD == 1
                monthfilename = strcat(eco_pheno_periods{kk},'_night_',' workspace');
            elseif HD == 2
                monthfilename = strcat(eco_pheno_periods{kk},'_day_',' workspace');
            end
        elseif TAR==1
            if HD == 1
                monthfilename = strcat(eco_pheno_periods{kk},'_night_H2O',' workspace');
            elseif HD == 2
                monthfilename = strcat(eco_pheno_periods{kk},'_day_H2O',' workspace');
            end
        end
    else
        if TAR ==0
            if HD == 1
                monthfilename = strcat(month,'_night_',' workspace');
            elseif HD == 2
                monthfilename = strcat(month,'_day_',' workspace');
            end
        elseif TAR==1
            if HD == 1
                monthfilename = strcat(month,'_night_H2O',' workspace');
            elseif HD == 2
                monthfilename = strcat(month,'_day_H2O',' workspace');
            end
        end
    end
    
elseif year_consecutive==0 %If using several nonconsecutive years, script adds years to name
    if exist('eco_pheno_periods','var')
        if TAR ==0
            if HD == 1
                monthfilename = strcat(eco_pheno_periods{kk},'_night_',' workspace',num2str(yearsInclude));
            elseif HD == 2
                monthfilename = strcat(eco_pheno_periods{kk},'_day_',' workspace',num2str(yearsInclude));
            end
        elseif TAR ==1
            if HD == 1
                monthfilename = strcat(eco_pheno_periods{kk},'_night_H2O',' workspace',num2str(yearsInclude));
            elseif HD == 2
                monthfilename = strcat(eco_pheno_periods{kk},'_day_H2O',' workspace',num2str(yearsInclude));
            end
        end
    else
        if TAR ==0
            if HD == 1
                monthfilename = strcat(month,'_night_',' workspace',num2str(yearsInclude));
            elseif HD == 2
                monthfilename = strcat(month,'_day_',' workspace',num2str(yearsInclude));
            end
        elseif TAR ==1
            if HD == 1
                monthfilename = strcat(month,'_night_H2O',' workspace',num2str(yearsInclude));
            elseif HD == 2
                monthfilename = strcat(month,'_day_H2O',' workspace',num2str(yearsInclude));
            end
        end
    end
end
save(monthfilename)
