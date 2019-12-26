%% ES2001 MATLAB Project 
% Chia Chong Rong Reynold U1640743L
% 10th November 2017
%
% Script extracts and plots surveyed points in North Pacific based on severity
% code from bleaching database v1.0
%
% Clear all values from workspace
clear all

% Define directory
directory = 'C:\Users\pcrr188a\Desktop\NTU\ASE\YEAR 2 SEM 1\ES2001_AY17_18\ES2001 PROJECT\Data\BleachingDataBaseV1\';

% Define file name
file_name = 'Bleaching-database-V1.0.xlsx';

% Concatanate directory and file name
myFile = [directory, file_name];

% Use add path to extract data from a different folder than the code
addpath(directory)

% Use xlsread to read .xlsx file. Outputs will be num, txt and raw, which
% shows numerical values, text and whole raw unedited file within range
% respectively
[~,~,raw] = xlsread (myFile,'Bleaching database V1.0','A2:S7438');

% Create a structure which stores all values from xls file.

% Create header names. Make sure header names are in curly brackets {} as
% the names are strings of letters
bleach_fnames = {'country','loc','s_name','lat','lon','month','year',...
    'depth','s_code','percent_b','m_code','percent_m','s_type','source',...
    'name','cite','comments','entry','d_code'};

% Convert cell to structure by using cell2struct.
bleach_struct = cell2struct (raw,bleach_fnames,2);

% Latitude and longitude range for north pacific is a little tricky, since
% the pacific ocean spans around the longitude of -180 to 180. The
% following for loops will separate the north pacific into 2 portions, one
% from longitude 128.6865° to 180°, and another from -180° to -100° and
% keep latitude range same at 0° to 58.2115°.
% Indexes of data which are in these regions are found in these 2 separate
% for loops and concatenated into one single vector index.

% Define blank vector "index" which will store all indexes of stations
% which are within the latitude and longitude limits of North Pacific Ocean
% from the database.
index =[];

% Define index for full length of data structure.
for aa = 1: length(bleach_struct)
    
    % Test whether station is within lat and long limits for one section of
    % North Pacific
    if 0< bleach_struct(aa).lat && bleach_struct(aa).lat<58.2115 ...
        && 128.6865 < bleach_struct(aa).lon && bleach_struct(aa).lon < 180  
        
        % Concatenate index if index is within range into blank vector
        % created above.
        index = [index; aa];
        
    end
end

% Define index for full length of data structure.
for bb = 1:length (bleach_struct)
    
    % Test whether station is within lat and long limits for the other section of
    % North Pacific
    if 0< bleach_struct(bb).lat && bleach_struct(bb).lat<58.2115 ...
        && -180 < bleach_struct(bb).lon && bleach_struct(bb).lon < -100 
    
        % Concatenate index if index is within range into blank vector
        % created above.
        index = [index ; bb];
    end
end

% Extract out only the data from the North Pacific Ocean by using the
% indexes found above in the raw data from the xls file.
northpacific_data = raw (index, :) ;   

% Create field names for structure containing data of North Pacific to be
% created later.
northpacific_fnames = {'country','loc','s_name','lat','lon','month','year',...
    'depth','s_code','percent_b','m_code','percent_m','s_type','source',...
   'name','cite','comments','entry','d_code'};

% Use cell2struct to convert data from cell format to structure format,
% while specifying field names and '2' to create a 2 dimensional structure
northpacific_struct = cell2struct (northpacific_data,northpacific_fnames,2);

% Load in built coastlines into MATLAB
load coastlines;

% Create a figure and make it full screen.
fig = figure('units','normalized','outerposition',[0 0 1 1]);

% Define index for years of interest
for xx = 2000 : 1 : max([northpacific_struct.year])
    
    % Clear previous figure
    clf
    
    % Set axes of map by using Mercator projection, and set origin and map
    % lat and long limits such that only the North Pacific region is seen
    % in figure
    axesm ('MapProjection','Mercator','Origin',[0 180 0],'MapLatLimit',[-10 70],...
    'MapLonLimit',[120, -70])

    % Use geoshow to show coastlines with green color.
    geoshow(coastlat,coastlon,'color','green');
    
    % Use tightmap to snap map to edges
    tightmap on

    % Use colormap jet to increase range of colors of colorbar 
    colormap jet
    
    % Create colorbar and edit ticks such that it labels the severity code
    % with the percentage of bleaching
    c = colorbar('Ticks',[-1,0,1,2,3],'TickLabels',{'-1 - Unknown','0 - No Bleaching','1 - Mild (1-10% bleaching)','2 - Moderate (11-50% bleached)','3 - Severe (>50% bleached)'},'FontSize',10);
    
    % Label colorbar and set font size
    c.Label.String = 'Severity Code';
    c.Label.FontSize = 12;
    
    % Set background color as black
    set (gca,'color','black')

    % Use function find to find indexes of structure where the year coincides with 
    % the years of interest. Make sure to put structure in square brackets to concatenate
    % structure drawer into 1 vector so that function find can be used.
    ID = find ([northpacific_struct.year] == xx);
    
    % Use scatterm to plot all stations in North Pacific and their color is
    % determined by the severity code recorded at the specific station
    scatterm ([northpacific_struct(ID).lat], [northpacific_struct(ID).lon], 50, [northpacific_struct(ID).s_code]);
   
    % Convert specific year from double format to string format
    year_str = num2str (xx);
    
    % Concatenate specific year to title for each frame in .gif file to be
    % made
    title (['Plot of severity code data in North Pacific in year ', year_str],'FontSize',25);
    
    % Use getframe to get the current frame for each year
    frame = getframe (fig) ;
    
    % Use frame2im to retrun image data associated with movie frame
    im = frame2im(frame); 
    
    % Convert RGB image to indexed image,imind, and colormap, cm.
    [imind,cm] = rgb2ind(im,256); 
    
    % Write to the GIF File,  using imwrite
    
    % Append images to first image
    if xx == 2000
        
        % Use imwrite and specify name of .gif file. Loopcount inf causes
        % image to continuously loop
        imwrite(imind,cm,'np_scode.gif','gif', 'Loopcount',inf); 
    
    else
        % WriteMode and Append appends images to first image.
        imwrite(imind,cm,'np_scode.gif','gif','WriteMode','append');
    
    end 
    
end


