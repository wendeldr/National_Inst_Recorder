function logData(src, evt, name)
% Add the time stamp and the data values to data. To write data sequentially,
% transpose the matrix.
global Init_file;
global co2_live;
Init_file=Init_file+1;
%   Copyright 2011 The MathWorks, Inc.





if isempty(co2_live)
    fid = fopen([name '_' num2str(Init_file) '.bin'],'w');                     %Open file and write
    data = [evt.TimeStamps, evt.Data]' ;
    fwrite(fid,data,'double');
    fclose(fid);
else
    co2_reform = interp1(co2_live(:, 1), co2_live(:, 2), evt.TimeStamps);
    for i = 1:length(co2_reform)
        if isnan(co2_reform(i))
            co2_reform(i) = co2_live(length(co2_live), 2);
        end
    end
    fid = fopen([name '_' num2str(Init_file) '.bin'],'w');                     %Open file and write
    data = [evt.Data, co2_reform];
    data = [evt.TimeStamps, data]' ;
    fwrite(fid,data,'double');
    fclose(fid);
end
end
