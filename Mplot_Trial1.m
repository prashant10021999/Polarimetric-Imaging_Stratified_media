% Clear workspace and command window
clc;
clear all;

% Step 1: Define the layer structure (air -> TiO2 -> air)
layerArray{1} = {'air', 0, [0 0 0], 0, 1};         % Incident medium (air)
layerArray{2} = {'+quartz', 10000, [0 0 0], 1, 0};    % TiO2 layer, 10000 nm thick
layerArray{3} = {'air', 0, [0 0 0], 0, 1};         % Exit medium (air)

% Step 2: Define the wavelength (in nm)
wavelengths = 500;  % Use a single wavelength at 500 nm (visible light)

% Step 3: Set the grid size and maximum angle of incidence (AOI)
Npts = 100;       % 100x100 grid points in K-space
maxAOI = 60;      % Maximum angle of incidence of 60 degrees

% Step 4: Set the flags for reflection and normalization
bReflect = false;    % Set to false for transmission (we want to calculate transmission)
bNorm = true;        % Normalize the Mueller matrix

% Set whether to compute a conoscopic map
bConoscopic = false; % Set to false for a polar map

% Step 5: Call the mmBerremanMap function to compute the Mueller matrix
MM = mmBerremanMap(layerArray, wavelengths, Npts, maxAOI, bReflect, bNorm, bConoscopic);

% Step 6: Use the MPlot class to visualize the Mueller matrix

% Since 'wavelengths' is a scalar, create a placeholder X-axis based on K-space grid
kx_grid = linspace(-maxAOI, maxAOI, Npts);  % X-axis placeholder (K-space angles)

% No need to pass mmError as it is optional
pObj = MPlot(kx_grid, MM);

% Step 7: Plot the Mueller matrix elements in a 4x4 grid
pObj.plot(kx_grid, MM);

% Step 8: Optionally, save the plot to a file
pObj.print('MuellerMatrixPlot.eps');
