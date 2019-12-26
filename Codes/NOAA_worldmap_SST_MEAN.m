clear all

directory = 'C:\Users\pcrr188a\Desktop\NTU\ASE\YEAR 2 SEM 1\ES2001_AY17_18\ES2001 PROJECT\Data\NOAA Coral Bleaching Monitoring Products\50km Resolution\Yearly\';

hdf_list = dir([directory, '*.hdf']);
hdf_names = extractfield (hdf_list,'name');

figure

for aa = 1:length (hdf_names)
    clf
    hdf_str = char(hdf_names(aa));

    myFile = [directory, hdf_str];

    fileinfo = hdfinfo(myFile);

    mean_sst = hdfread (myFile, 'CRW_SST_MEAN');
    mean_sst(mean_sst==-7777)= NaN;
    mean_sst = mean_sst * 0.01;
    imagesc(mean_sst);

    shading flat
    colormap jet
    c = colorbar;
    c.Label.String = 'Mean Sea Surface Temperature (°C)';
    axis off
    
    
    year_v = [2001:1:2015];
    year_value = year_v (aa);
    year_str = string (year_value);
   
    title (['Map of Mean Sea Surface Temperature in Year ',year_str]);
    M (aa) = getframe ;
    
end

movie(M,1,5)

