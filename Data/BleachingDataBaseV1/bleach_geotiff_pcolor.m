%% ES2001 MATLAB Project 
% Chia Chong Rong Reynold U1640743L
% 7th November 2017
%
% Script attempts to extract and plot the probability of bleaching occurrence
% in a given year between 2000 and 2010 across the world’s warmwater coral reefs at
% 0.04° X 0.04° latitude-longitude resolution on a world map.
% Clear all values from workspace
%
% This script specifically uses function pcolor to create the map of
% probability. However, the problem with this method is that the map
% created is in pixel coordinates. 

% Clear all values from workspace.
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
    
    % pcolor is done to plot points on a grid, based on color. However, it is
    % a grid that is drawn in black lines. If there are too many points to be
    % plotted, the thickness of black lines will overwhelm the picture, and the
    % picture ends up as black. Use "shading flat" to remove these black lines
    pcolor(A);
    
    % Set shading of figure to flat
    shading flat
    
    % Use colormap jet to increase range of colors of colorbar 
    colormap jet
    
    % Create colorbar
    c =  colorbar;
    
    % Label colorbar and set font size
    c.Label.String = 'Bleaching Probability';
    c.Label.FontSize = 12;
    
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
        imwrite(imind,cm,'pcolor_prob.gif','gif', 'Loopcount',inf); 
    
    else
        % WriteMode and Append appends images to first image.
        imwrite(imind,cm,'pcolor_prob.gif','gif','WriteMode','append');
    
    end 
end
