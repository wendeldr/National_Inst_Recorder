function liveCO2(time, device, fig, name)
    global co2_data;
    global co2_live;
    figure(fig)
    %set(0, 'currentfigure', fig)
    data = char(fread(device, device.bytesavailable));
%     data2 = char(fread(device, device.bytesavailable));
    data = convertCharsToStrings(data);
    data = splitlines(data);
%     co2 = zeros(length(data), 1);
    co2 = double([]); 
    for i = 1:length(data)
        line = strsplit(data(i));
        if length(line) == 5
            co2(end+1, :) = str2double(line(3));
        end
    end
    co2 = co2 * 10;
    
    dTime = time(1000) - time(1);
    timeSplit = dTime / length(co2);
    factor = 0;
    % newTime = zeros(length(co2), 1);
    
%     co2(1) = co2(1);
%     for i = 1:length(co2)
%         newTime(i) = newTime(1) + factor;
%         factor = factor + timeSplit;
%     end
%     
    newTime(1) = time(1);
    for i = 1:length(co2)
        newTime(i) = newTime(1) + factor;
        factor = factor + timeSplit;
    end
    newTime = newTime + 1;
    
    
    window_length = 10; % in seconds
    newTime = newTime.';
    co2_live = [newTime, co2];
    if size(co2_data, 1) > (28 * (window_length - 1))
        x = size(co2_data, 1) - (28 * (window_length - 1));
        co2_data(1:x, :) = [];
    end
    co2_data = [co2_data; newTime, co2];
%     plot(newTime, co2);
    plot(co2_data(:, 1), co2_data(:, 2))
    ylim([min(co2_data(:, 2))-1, max(co2_data(:, 2))+1])
    title(name);
    ylabel('CO2 Concentration (ppm)')
    xlabel('Time (sec)')
% end