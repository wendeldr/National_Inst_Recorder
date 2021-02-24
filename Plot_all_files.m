close all;
clear;

data_directory = 'C:\Users\Anna\Desktop\New folder\';  % your directory



bin_files = dir(fullfile(data_directory,'*.bin'));
[~, reindex] = sort( str2double( regexp( {bin_files.name}, '\d+', 'match', 'once' )));
bin_files = bin_files(reindex) ;

col1 = [];
col2 = [];
col3 = [];
col4 = [];
col5 = [];
for i = 1:length(bin_files)
    curr_file = fullfile(bin_files(i).folder, bin_files(i).name);
    fileID = fopen(curr_file);                     %Open file and write
    data = fread(fileID, [5 inf], 'double');
    col1 = cat(1,col1,data(1,:)');
    col2 = cat(1,col2,data(2,:)');
    col3 = cat(1,col3,data(3,:)');
    col4 = cat(1,col4,data(4,:)');
    col5 = cat(1,col5,data(5,:)');
    fclose(fileID);
end

figure()
plot(col1, col2);
title('col2');

figure()
plot(col1, col3);
title('col3');

figure()
plot(col1, col4);
title('col4');

figure()
plot(col1, col5);
title('88178_N');