% Clear workspace and command window
clc;
clear All;

% Define the layer array (Air -> TiO2 -> Air system)
layerArray{1} = {'air', 0, [0 0 0], 0, 1};       % Incident medium (air)
layerArray{2} = {'TiO2', 10000, [0 0 0], 1, 0};  % TiO2 layer (10 micrometers thick)
layerArray{3} = {'air', 0, [0 0 0], 0, 1};       % Exit medium (air)

layerArray = {layerArray{1}, layerArray{2}, layerArray{3}};  % Re-organize the layers

% Define simulation parameters
wavelengths = 400;      % Wavelength in nanometers
Npts = 100;             % Number of grid points in X and Y
maxAOI = 45;            % Maximum angle of incidence in degrees
bReflect = 0;           % Set to 0 for transmission matrix
bNorm = 1;              % Set to 1 for normalization
bConoscopic = 1;        % Set to 1 for conoscopic map

% Compute the Mueller matrix K-space map using the Berreman method
M = mmBerremanMap(layerArray, wavelengths, Npts, maxAOI, bReflect, bNorm, bConoscopic);

% Create a figure to plot all 16 elements (4x4) of the Mueller matrix
figure;

% Find the global min and max for the color scale (to make plots consistent)
minVal = min(M(:));   % Global minimum across all elements of the matrix
maxVal = max(M(:));   % Global maximum across all elements of the matrix

% Loop through each element of the 4x4 Mueller matrix and plot them
for i = 1:4
    for j = 1:4
        % Arrange subplots in a 4x4 grid for each matrix element
        subplot(4, 4, (i-1)*4 + j); 
        
        % Plot the (i,j) element of the Mueller matrix using real data from M
        imagesc(squeeze(M(i, j, :, :, 1)));  % Using the first wavelength for plotting
        
        % Set the color scale for each plot to be consistent
        caxis([minVal maxVal]);
        
        % Remove axis labels for a cleaner presentation
        set(gca, 'XTick', [], 'YTick', []);
        
        % Optionally add titles to each subplot for clarity
        title(['M' num2str(i) num2str(j)]);
    end
end

% Add a single colorbar on the side of the entire figure, applying to all subplots
h = colorbar;
h.Position = [0.93 0.1 0.02 0.8];  % Adjust the position of the colorbar

% Optionally add a global title for the entire figure
sgtitle('Mueller Matrix Elements for TiO2 Layer');
