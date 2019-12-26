%% ES2001 MATLAB Project 
% Chia Chong Rong Reynold U1640743L
% 8th November 2017
% 
% Script extracts and plots data from NOAA Coral Reef Watch Virtual
% Stations. Parameters recorded at these stations are SST, SST Anomaly,
% Hotspots and DHW. These plots on a map enhances the visualisation of the
% graph of climate change indicators against time as plotted by Ze Ming.
% 
% This script specifically plots data of Hotspots over the time period of 2000
% to 2015, and an animated .gif is created.

% Clear all values from workspace
clear all

% Define directory 
directory = 'C:\Users\pcrr188a\Desktop\NTU\ASE\YEAR 2 SEM 1\ES2001_AY17_18\ES2001 PROJECT\Data\NOAA bleaching data(zm)\bleaching data\';

% Use function dir and specify *.txt to get a structure containing
% information of all .txt files which contains the desired data in the
% folder. 
file_list = dir([directory, '*.txt']);

% Use function extractfield and specify 'name' to extract names of all .txt
% files in folder.
filenames = extractfield (file_list, 'name');

% Each .txt file contains data for SST, SST anomaly, DHW and Hotspots for each NOAA Coral Reef Watch Virtual
% Station over time, and the respective year, latitude and longitude of the
% station data is given in the same .txt file.

% To combine all the data from different .txt files into single vectors,
% empty vectors for latitude, longitude, year, and Hotspots are created. These
% vectors will be used to store all the relevant data later on.
lat_v = [];
lon_v = [];
year_v = [];
hotspot_v = [];

% Define index for full length of number of .txt files in folder
for aa = 1:1:length(filenames)
    
    % Convert each .txt file name from cell format to character format by
    % using function char
    file_str = char (filenames(aa));
    
    
    % Only when char is used will the file name be in the correct character
    % format for it to be concatenated with directory to form full path
    myFile = [directory, file_str];
    
    % Use textread to read data from each .txt file
    [BYYY, BM, BD, BH, EYYY, EM, ED, EH, SST, SSTANOM, HOTSPOT, DHW, lat, lon, Reef_Name] = textread(myFile, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %s','delimiter','|','headerlines',1);
    
    % Concatenate latitude , longitude, year and hotspot data from each .txt
    % file into each empty vector created above.
    lat_v = [lat_v; lat];
    lon_v = [lon_v; lon];
    year_v = [year_v; BYYY];
    hotspot_v = [hotspot_v;HOTSPOT];
    
    
end

% After combining all the data into single vectors, combine these vectors to
% create a single data matrix which contains all the latitudes,
% longitudes, hotspot and corresponding year of record
data_matrix = [lat_v lon_v year_v hotspot_v];

% Create a figure and make the figure full screen
fig = figure('units','normalized','outerposition',[0 0 1 1]);

% Define index from the smallest year, 2000 to largest year, 2017
for yy = min(year_v) : 1 : max(year_v)
    
    % Clear previous figure
    clf
    
    % Use function find to find the indexes where the 3rd column of the
    % data matrix created above, which contains the record years, is the
    % same as the each indexed year. For instance, for the first value of
    % yy, 2000, the function find will find all indexes in the 3rd column
    % where there is year 2000. This index can later be used to extract out
    % the corresponding latitude, longitude and hotspot data.
    index = find (data_matrix(:,3) == yy);
    
    % Set axes of map, using mercator projection and set origin, map
    % latitude and longitude limit such that only the area of North Pacific
    % is shown on the map
    axesm ('MapProjection','Mercator','Origin',[0 180 0],'MapLatLimit',[-10 50],...
    'MapLonLimit',[120, -70])

    % Set background color as black
    set (gca,'color','black')
    
    % Load inbuilt coastlines into MATLAB
    load coastlines
    
    % Use geoshow to show coast lines, with a green color
    geoshow(coastlat, coastlon,'color','g')
    
    % Use tightmap to snap map to edges
    tightmap on
    
    % Use colormap jet to set colorbar on map to have a larger range of
    % colors.
    colormap jet
    
    %  Create color bar
    c = colorbar ;
    
    % Label the colorbar and set font size
    c.Label.String = 'Bleaching Hotspots (°C)';
    c.Label.FontSize = 12;
    
    % Use scatterm to plot all latitude and longitude of each NOAA Coral Reef Watch Virtual
    % Station and color of each station plot depends on the hotspots of the
    % station of each year.
    scatterm (lat_v(index), lon_v(index), 50, hotspot_v(index));
    
    % Convert year from double format to string format so that the specific
    % year can be printed onto the title for each frame in the .gif file to
    % be made later on.
    year_str = num2str (yy);
    
    % Concatenate title with the specific year
    title (['Plot of Bleaching Hotspots of North Pacific Stations in ',year_str],'FontSize',25);
    
    % Use getframe to get the current frame for each year
    frame = getframe (fig) ;
    
    % Use frame2im to retrun image data associated with movie frame
    im = frame2im(frame); 
    
    % Convert RGB image to indexed image,imind, and colormap, cm.
    [imind,cm] = rgb2ind(im,256);
    
    % Write to the GIF File, using imwrite
    if yy == min(year_v) 
        imwrite(imind,cm,'npmap_hotspot.gif','gif', 'Loopcount',inf); 
    
    else
        
        imwrite(imind,cm,'npmap_hotspot.gif','gif','WriteMode','append');
    
     
    end
    
end


