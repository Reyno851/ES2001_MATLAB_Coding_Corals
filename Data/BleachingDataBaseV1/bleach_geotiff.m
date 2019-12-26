%% ES2001 MATLAB Project 
% Chia Chong Rong Reynold U1640743L
% 7th November 2017
%
% Script attempts to extract and plot the probability of bleaching occurrence
% in a given year between 2000 and 2010 across the world’s warmwater coral reefs at
% 0.04° X 0.04° latitude-longitude resolution on a world map.

% Clear all values from workspace
clear all

% Define directory
directory = 'C:\Users\pcrr188a\Desktop\NTU\ASE\YEAR 2 SEM 1\ES2001_AY17_18\ES2001 PROJECT\Data\BleachingDataBaseV1\';

% Use function dir and specify *.tif to get a structure containing
% information of all .tif files which contains the desired data in the
% folder. 
geotiff_list = dir([directory, '*.tif']);

% Use function extractfield and specify 'name' to extract names of all .tif
% files in folder.
geotiff_names = extractfield (geotiff_list,'name');

% Create a figure and make it full screen
fig = figure ('units','normalized','outerposition',[0 0 1 1]);

% Define index for full length of number of .hdf files in folder
for aa = 1: length (geotiff_names)
    
    % Clear previous figure
    clf
    
    % Convert each .tif file name from cell format to character format by
    % using function char
    geotiff_str = char(geotiff_names(aa));
    
    % Only when char is used will the file name be in the correct character
    % format for it to be concatenated with directory to form full path
    myFile = [directory, geotiff_str];
    
    % Use georiffread to read .tif file into MATLAB. Since A is a 2x2 array,
    % file contains a grayscale image or data grid. R is a spatial
    % referencing object R.
    [A, R] = geotiffread (myFile);

    % Convert all values in A less than 0 to NaN since all values are probabilities
    % and are supposed to be from 0 to 1. Values less than 0 are assumed to be
    % corrupt values.
    A(A(:)<0) = NaN;

    % Next few steps will create a 3120x8640 matrix for each of the latitude ad
    % longitude. These matrices will then be superimposed on top of each other
    % and each latitude and longitude will have the value stored in A for each
    % pixel. The size of the latitude, longitude and A array should be the
    % same.
    
    % Firstly, get size of A
    A_size = size (A);
    
    % Get number of rows of A 
    A_rows = A_size (1);
    
    % Get number of columns of A
    A_columns = A_size (2);
    
    % Creating latitude matrix
    
    % Define latitude interval
    lat_interval = (90 - (-90) )/ A_rows;
    
    % Find the last latitude in the first column 
    lat_first_col_limit = 90 - (A_rows - 1)*lat_interval;
    
    % Use function colon to create a vector of all latitudes starting from 
    % top most latitude, at 90, to the last latitude found above, using the
    % latitude interval. Transpose the vector to create a column vector
    lat_first_col = (colon(90,-lat_interval,lat_first_col_limit))';
    
    % Use function repelem to repeat the elements of the first column the
    % same number of times as the number of columns of A, which is 8640
    % times. This is done because the latitudes do not change horizontally
    % across the matrix.
    lat_array = repelem(lat_first_col,1, A_columns);

    % Create longitude matrix
    
    % Define longitude interval
    lon_interval = (180 - (-180))/A_columns;
    
    % Find the last longitude in the first row
    lon_first_row_limit = -180 + (A_columns - 1)*lon_interval;
    
    % Use function colon to create a vector of all longitudes starting from 
    % left most latitude, at -180, to the last longitude found above, using the
    % longitude interval. 
    lon_first_row = colon(-180,lon_interval,lon_first_row_limit);
    
    % Use function repmat to replicate the first row of longitude the same
    % number of times as rows of A, which is 3240 times, starting from top
    % to bottom. This is done because the longitudes do not change
    % vertically from top to bottom of a matrix.
    lon_array = repmat(lon_first_row,A_rows,1);
    
    % Set axes of map and set projection to Mercator.
    axesm ('MapProjection','Mercator')
    
    % Load inbuilt coastlines into MATLAB
    load coastlines
    
    % Use geoshow to show coastlines
    geoshow (coastlat, coastlon);
    
    % Set shading of figure to flat
    shading flat
    
    % Use colormap jet to increase range of colors of colorbar 
    colormap jet
    c = colorbar ('Ticks',[-1:0.05:1]);
    
    % Label colorbar and set font size
    c.Label.String = 'Bleaching Occurrence Probability';
    c.Label.FontSize = 12;
    
    % Use tightmap to snap map to edges
    tightmap on
    
    % Create a vector containing all years of interest for this project.
    year_v = [2000, 2001, 2003:1:2006, 2008:1:2010];
    
    % Use first index of full length of .tif files in folder and input into year
    % vector created to get the first year. This is done for each index.
    year_value = year_v (aa);
    
    % Convert year from double format to string
    year_str = string (year_value);
    
    % Include title and use year_str above to concatenate with title for
    % each image frame
    title (['Map showing probability of bleaching occurrence in ', year_str, 'across world''s warmwater coral reefs'],'FontSize',20)
    
    % Use scatterm to plot all records based on latitude and longitude and
    % color of each plot is determined by the probability at each lat and
    % long specified in A. (:) is used to convert array format to vector
    % format so that scatterm can be used.
    scatterm(lat_array(:),lon_array(:),10,A(:),'.')

    % Use getframe to get the current frame for each year
    frame = getframe (fig) ;
    
    % Use frame2im to retrun image data associated with movie frame
    im = frame2im(frame); 
    
    % Convert RGB image to indexed image,imind, and colormap, cm.
    [imind,cm] = rgb2ind(im,256);
    
    % Write to the GIF File, using imwrite
    
    % Append images to first image
    if aa == 1  
        
         % Use imwrite and specify name of .gif file. Loopcount inf causes
        % image to continuously loop
        imwrite(imind,cm,'probability.gif','gif', 'Loopcount',inf); 
    
    else
        % WriteMode and Append appends images to first image.
        imwrite(imind,cm,'probability.gif','gif','WriteMode','append');
    
    end 
end
