%Quick save all channel data
close all;
clear;

%data_directory = 'X:\User Data\Anna Vogel\EP_Study_ECG_QTVI\20201105\DATA\20201105_88178_N';  % your directory
data_directory = uigetdir('','Please select a folder containing BIN files to be plotted.');


bin_files = dir(fullfile(data_directory,'*.bin'));
[~, reindex] = sort( str2double( regexp( {bin_files.name}, '\d+', 'match', 'once' )));
bin_files = bin_files(reindex) ;

col1 = [];
col2 = [];
col3 = [];
col4 = [];
col5 = [];
col6 = [];
col7 = [];
for i = 1:length(bin_files)
    curr_file = fullfile(bin_files(i).folder, bin_files(i).name);
    fileID = fopen(curr_file);                     %Open file and write
    data = fread(fileID, [7 inf], 'double');
    col1 = cat(1,col1,data(1,:)');
    col2 = cat(1,col2,data(2,:)');
    col3 = cat(1,col3,data(3,:)');
    col4 = cat(1,col4,data(4,:)');
    col5 = cat(1,col5,data(5,:)');
    col6 = cat(1,col4,data(6,:)');
    col7 = cat(1,col5,data(7,:)');
    fclose(fileID);
end
fprintf("Current path is:  %s\n\n", data_directory);

% Appends data to a single array:
    % col 1 = time (seconds) = NEED TO CONFIRM
    % col 2 = channel 1 (CONFIRM SIGNAL IN SCINTICA RODENT SURGICAL MONITOR)
    % col 3 = channel 2 (CONFIRM SIGNAL IN SCINTICA RODENT SURGICAL MONITOR)
    % col 4 = channel 3 (CONFIRM SIGNAL IN SCINTICA RODENT SURGICAL MONITOR)
    % col 5 = channel 4 (CONFIRM SIGNAL IN SCINTICA RODENT SURGICAL MONITOR)
save_array = [col1, col2, col3, col4, col5, col6, col7];

% converts the array to table format for easy export
save_table = array2table(save_array);

save_table.Properties.VariableNames = [ "col1", "col2", "col3", "col4", "col5","col6", "col7"];

savename = fullfile(data_directory, "Channel_Data.csv");

writetable(save_table, savename);