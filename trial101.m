% Clear workspace and command window
clc;
clear All;

% Define the layer array for the stratified medium (Air -> TiO2 -> Air)
layerArray{1} = {'air', 0, [0 0 0], 0, 1};       % Incident medium (air)
layerArray{2} = {'TiO2', 10000, [0 0 0], 1, 0};  % TiO2 layer (10 micrometers thick)
layerArray{3} = {'air', 0, [0 0 0], 0, 1};       % Exit medium (air)

% Define simulation parameters
wavelengths = 400;      % Wavelength in nanometers
Npts = 100;             % Number of grid points in X and Y
maxAOI = 45;            % Maximum angle of incidence in degrees
bReflect = 0;           % Set to 0 for transmission matrix
bNorm = 1;              % Set to 1 for normalization
bConoscopic = 1;        % Set to 1 for conoscopic map

% Compute the Mueller matrix K-space map using the Berreman method
M = mmBerremanMap(layerArray, wavelengths, Npts, maxAOI, bReflect, bNorm, bConoscopic);

% Ensure the data is in the correct format (4x4xXxY)
% Create an MPlot3D object and pass the data for visualization
pObj = MPlot3D(M, 'palette', 'HotCold Bright', 'gs', [-1 1]);

% Set custom properties for the plot
pObj.width = 12;        % Increase figure width for more space between plots
pObj.fontsize = 16;     % Increase font size for colorbars and titles
pObj.hSpacing = 10;     % Increase horizontal spacing between subplots
pObj.vSpacing = 10;     % Increase vertical spacing between subplots
pObj.limz = 1e-3;       % Limit for color bar scale

% Plot the data
pObj.plot(M);

% Set custom colormap (optional)
colormap(pObj.axesHandles(1,1), 'jet');  % Example: use 'jet' colormap

% Set axis equal for uniform aspect ratio and add titles
for i = 1:4
    for j = 1:4
        subplot(4, 4, (i-1)*4 + j);
        axis equal;    % Ensure plots have equal aspect ratio
        title(['M' num2str(i) num2str(j)], 'FontSize', 12);  % Add titles to subplots
    end
end

% Set figure size, resolution, and save as high-res image
set(gcf, 'PaperPositionMode', 'auto');
print(gcf, 'MPlot3D_output_highres.png', '-dpng', '-r300');  % Save as high-resolution PNG

% Optionally display the plot in the MATLAB figure window
figure;
pObj.plot(M);
