


animal_id = "100000002";
date = "20210127";
animal_model = "TEST_2_1CCED82";      %e.g. "ACI_PRESURGERY"





try
    fclose(device);
catch
end
close all;
clear all;

% device = serialport("COM4",9600)
device = serial('COM4');
device.Terminator = 'CR/LF';
fopen(device);
fprintf(device, 'K 1');
% configureTerminator(device,"CR/LF")
% writeline(device,"K 1")
% readline(device);


global Init_file;
global co2_data;
global co2_live;
Init_file=0;
%Aquire and output at the same time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
samp_rate=1000;                                %Sample rate for acquisition 
numInChans=5;                              %Number of chanels to acquire
%numOutChans=1;                              %Number of channels to output
SecondsToPlot=1;                            %Number of seconds to plot/save during the acquisition
%Duration=60;                               %Total number of seconds to acquire (if not continuous)
comment= char(strcat(date, "_", animal_model)); %Comment to include in filename
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
savepath = uigetdir('','Please select the parent folder for saving.');
savepath = char(strcat(savepath, "\", animal_id, "\"));

if ~exist(savepath)
    mkdir(savepath)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Set the filename to save:
name=[savepath comment];

%%
%Acquire Data:
numChans=numInChans;
s = daq.createSession('ni');                %Set up the analog input session:
% s.addAnalogInputChannel('cDAQ9191-1E96F2BMod1', 0:numChans-1, 'Voltage');   %May need to change the Device Name [square bracket to specify channels as vector]
s.addAnalogInputChannel('cDAQ9191-1CCED82Mod1', 0:numChans-1, 'Voltage');   %May need to change the Device Name [square bracket to specify channels as vector]

s.Rate = samp_rate;                         %Set sample rate
s.IsContinuous= true;                       %Set to continuous recording
%s.IsContinuous= false;  
%s.DurationInSeconds = Duration;                                                                                      %Total duration of acquisition if not continuous

%Plot the data as it comes in and write it to a binary file:
s.NotifyWhenDataAvailableExceeds = min([samp_rate*SecondsToPlot,samp_rate*s.DurationInSeconds]);    %Set the amount to plot
%lh = s.addlistener('DataAvailable', @(src, event) plot(event.TimeStamps, event.Data(:,1)));               %Plot the data

f1 = figure();
f2 = figure();
f3 = figure();
f4 = figure();
f5 = figure();
f6 = figure();


lh_plot1 = s.addlistener('DataAvailable', @(src, event) livePlotLeads(event.TimeStamps, event.Data(:,1), f1, 'Lead 1'));
lh_plot2 = s.addlistener('DataAvailable', @(src, event) livePlotLeads(event.TimeStamps, event.Data(:,2), f2, 'Lead 2'));
lh_plot3 = s.addlistener('DataAvailable', @(src, event) livePlotLeads(event.TimeStamps, event.Data(:,3), f3, 'Lead 3'));
lh_plot4 = s.addlistener('DataAvailable', @(src, event) livePlotLeads(event.TimeStamps, event.Data(:,4), f4, 'PPG'));
lh_plot5 = s.addlistener('DataAvailable', @(src, event) livePlotLeads(event.TimeStamps, event.Data(:,5), f5, 'Pressure'));
lh_plot6 = s.addlistener('DataAvailable', @(src, event) liveCO2(event.TimeStamps, device, f6, 'CO2'));

                                                                                                                                 
lh2 = s.addlistener('DataAvailable',@(src, event) logData(src, event, name));                         %Write the data
s.startBackground;                          %Start the acquisition
%s.startForeground;


%Clean up:
% s.wait
% delete(lh)
% delete(lh2)
% s.stop



