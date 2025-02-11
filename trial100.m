% Clear workspace and command window
clc;
clear All;

% Define the layer array for the stratified medium (Air -> TiO2 -> Air)
layerArray{1} = {'air', 0, [0 0 0], 0, 1};       % Incident medium (air)
layerArray{2} = {'TiO2', 10000, [0 0 0], 1, 0};  % TiO2 layer (10 micrometers thick)
layerArray{3} = {'air', 0, [0 0 0], 0, 1};       % Exit medium (air)

% Define simulation parameters
wavelengths = 400;      % Wavelength in nanometers
Npts = 1000;             % Number of grid points in X and Y
maxAOI = 45;            % Maximum angle of incidence in degrees
bReflect = 0;           % Set to 0 for transmission matrix
bNorm = 1;              % Set to 1 for normalization
bConoscopic = 1;        % Set to 1 for conoscopic map

% Compute the Mueller matrix K-space map using the Berreman method
M = mmBerremanMap(layerArray, wavelengths, Npts, maxAOI, bReflect, bNorm, bConoscopic);

% Ensure the data is in the correct format (4x4xXxY) - M is already in this form
% Create an MPlot3D object and pass the data for visualization
pObj = MPlot3D(M, 'palette', 'HotCold Bright', 'gs', [-1 1]);

% Optionally, set some properties for the figure
pObj.width = 10;       % Width of the figure in inches
pObj.fontsize = 14;    % Font size in points
pObj.limz = 1e-3;      % Limit for color bars

% Plot the data
pObj.plot(M);

% Save the plot to a file (optional)
pObj.print('MPlot3D_output.eps');

% Display the plot in the MATLAB figure window
figure;
pObj.plot(M);
