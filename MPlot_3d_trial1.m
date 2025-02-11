% Clear workspace and command window
clc;
clear all;

% Define the TiO2 physical model (air -> TiO2 -> air)
layerArray{1} = {'air', 0, [0 0 0], 0, 1};         % Incident medium (air)
layerArray{2} = {'TiO2', 10000, [0 0 0], 1, 0};    % TiO2 layer, 10000 nm thick
layerArray{3} = {'air', 0, [0 0 0], 0, 1};         % Exit medium (air)

% Wavelengths and grid setup
wavelengths = 500;  % Single wavelength (500 nm)
Npts = 1000;         % 100x100 grid points
maxAOI = 60;        % Max angle of incidence 60 degrees
bReflect = false;   % Transmission
bNorm = true;       % Normalize the Mueller matrix
bConoscopic = false;% Polar map

% Compute the Mueller matrix using the mmBerremanMap function
MM = mmBerremanMap(layerArray, wavelengths, Npts, maxAOI, bReflect, bNorm, bConoscopic);

% Create the plot using MPlot3D with improved figure settings
pObj = MPlot3D(MM, 'palette', 'HotCold Bright', 'gs', [-1 1], 'fontsize', 16, ...
               'width', 8, 'hSpacing', 5, 'vSpacing', 5, 'cbw', 15);

% Adjust figure resolution for publication quality (600 DPI for example)
print(pObj.figHandle, 'PublicationQualityFigure.png', '-dpng', '-r600');
