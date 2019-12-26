%% ES2001 MATLAB Project 
% Chia Chong Rong Reynold U1640743L
% 9th November 2017
% 
% Script extracts and plots data from Annual Composites
% of Twice-Weekly 50-km Satellite Coral Bleaching Monitoring Products. 
% Parameters recorded at these data sets are Thermal Stress Levels, DHW, 
% SST, SST anomaly and hotspots.
% 
% This script specifically plots the Thermal Stress Alert Area Level on a
% world map.

% Clear all values from workspace
clear all

% Define directory
directory = 'C:\Users\pcrr188a\Desktop\NTU\ASE\YEAR 2 SEM 1\ES2001_AY17_18\ES2001 PROJECT\Data\NOAA Coral Bleaching Monitoring Products\50km Resolution\Yearly\';

% Use function dir and specify *.hdf to get a structure containing
% information of all .hdf files which contains the desired data in the
% folder. 
hdf_list = dir([directory, '*.hdf']);

% Use function extractfield and specify 'name' to extract names of all .hdf
% files in folder.
hdf_names = extractfield (hdf_list,'name');

% Create a figure and make it full screen
fig = figure('units','normalized','outerposition',[0 0 1 1]);

% Define index for full length of number of .hdf files in folder
for aa = 1:length (hdf_names)
    
    % Clear previous figure
    clf
    
    % Convert each .hdf file name from cell format to character format by
    % using function char
    hdf_str = char(hdf_names(aa));

    % Only when char is used will the file name be in the correct character
    % format for it to be concatenated with directory to form full path
    myFile = [directory, hdf_str];

    % Use function hdfinfo to get a structure fileinfo containing all information
    % about the specific hdf file.
    fileinfo = hdfinfo(myFile);
    
    % Use function hdfread to read .hdf file into MATLAB, and specify
    % data set you want to read from the .hdf file. The name of the data
    % can be found under fileinfo --> SDS --> Name 
    max_alertarea = hdfread (myFile, 'CRW_ALERTAREA_MAX');
    
    % In the same row as the data set of interest after clicking SDS, click
    % on the "Attributes" field and get the description of the data set
    % under "variable_info". 
    % In this case, thermal stress levels are only measured from 0 to 4.
    % Any values above 4 are converted to NaN.
    max_alertarea (max_alertarea>4)= NaN;
    
    % Use function imagesc to display the image with scaled colors.
    imagesc(max_alertarea);
    
    % Set shading of figure to flat
    shading flat
    
    % Use colormap jet to set colorbar to have a larger range of colors.
    colormap jet
    
    % Create colorbar. Change ticks such that the ticks label the different
    % levels of bleaching stress levels.
    c = colorbar ('Ticks',[0,1,2,3,4],'TickLabels',{'No Stress','Bleaching Watch','Bleaching Warning','Bleaching Alert 1','Bleaching Alert 2'},'FontSize',10);
    
    % Label colorbar and set font size
    c.Label.String = 'Bleaching Thermal Stress Level';
    c.Label.FontSize = 12;
    
    % Turn axis labels off
    axis off
    
    % Create a vector containing all years of interest for this project.
    year_v = [2001:1:2015];
    
    % Use first index of full length of .hdf files in folder and input into year
    % vector created to get the first year. This is done for each index.
    year_value = year_v (aa);
    
    % Convert year from double format to string
    year_str = string (year_value);
    
    % Include title and use year_str above to concatenate with title for
    % each image frame
    title (['Global map of Bleaching Thermal Stress Levels in Year ',year_str],'FontSize',25);
    
    % Use getframe to get the current frame for each year
    frame = getframe (fig) ;
    
    % Use frame2im to retrun image data associated with movie frame
    im = frame2im(frame); 
    
    % Convert RGB image to indexed image,imind, and colormap, cm.
    [imind,cm] = rgb2ind(im,500); 
    
    % Write to the GIF File, using imwrite
    
    % Append images to first image
    if aa == 1 
        
        % Use imwrite and specify name of .gif file. Loopcount inf causes
        % image to continuously loop
        imwrite(imind,cm,'alertarea_max.gif','gif', 'LoopCount',inf,'DelayTime',1); 
    
    else
        % WriteMode and Append appends images to first image.
        imwrite(imind,cm,'alertarea_max.gif','gif','WriteMode','append','DelayTime',2);
    
    end 
    
end



