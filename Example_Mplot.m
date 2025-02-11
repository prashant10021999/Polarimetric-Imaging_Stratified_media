clc;
clear all;

layerArray {1} = {'air', 0, [0 0 0], 0, 1};
layerArray {2} = {'TiO2', 1000000 , [0 0 0], 1, 0};
layerArray {3} = {'air', 0, [0 0 0], 0, 1};

layerArray = {layerArray{1}, layerArray{2}, layerArray{3}};

% Calculate transmission Mueller matrix spectra
wavelengths = 300:750;
M0 = mmPartialWave(layerArray, wavelengths, 0, 0, 0);
M10 = mmBerreman(layerArray, wavelengths, 0, 10, 0);
M20 = mmPartialWave(layerArray, wavelengths, 0, 20, 0);

% Concatenate matrices along the third dimension (assuming they have the same first two dimensions)
mmData = cat(5, M0, M10, M20);

% Plot the data
pObj = MPlot(wavelengths, mmData, ...
    'size', [800 500], ...
    'borderFactor', 3, ...
    'vSpace', 10, ...
    'title', '1 mm c-cut quartz in transmission', ...
    'legend', {'AOI', [0 10 20]}, ...
    'lineNV', {'LineWidth', 2}, ...
    'axNV', {'ColorOrder', cbrewer('qual', 'Set2', 3)});

% Print the figure to the current folder
pObj.print('MPlot_example1.eps');