% Clear workspace and command window
clc;
clear All;
% Define the layer array
layerArray {1} = {'air', 0, [0 0 0], 0, 1};
layerArray {2} = {'TiO2', 10000, [0 0 0], 1, 0};  % TiO2 layer
layerArray {3} = {'air', 0, [0 0 0], 0, 1};

layerArray = {layerArray{1}, layerArray{2}, layerArray{3}};

% Define simulation parameters
wavelengths = 400; % Wavelengths in nanometers
Npts = 1000; % Number of grid points in X and Y
maxAOI = 45; % Maximum angle of incidence in degrees
bReflect = 0; % Set to true (1) for reflection matrix
bNorm = 1; % Set to true (1) for normalization
bConoscopic = 1; % Set to true(1) for conoscopic map



% Compute the Mueller matrix K-space map using mmBerremanMap function
M = mmBerremanMap(layerArray, wavelengths, Npts, maxAOI, bReflect, bNorm, bConoscopic);

% Now we will plot all 16 elements (4x4) of the Mueller matrix
figure;

% Find the global min and max for the color scale (to make plots consistent)
minVal = min(M(:));
maxVal = max(M(:));

% Loop through each element of the 4x4 Mueller matrix and plot them
for i = 1:4
    for j = 1:4
        % Arrange subplots in a 4x4 grid for each matrix element
        subplot(4, 4, (i-1)*4 + j); 
        
        % Plot the (i,j) element of the Mueller matrix using real data from M
        imagesc(squeeze(M(i, j, :, :, 1))); % Using the first wavelength for plotting
        
        % Set the color scale for each plot to be consistent
        caxis([minVal maxVal]);
        
        % Remove axis labels for a cleaner presentation
        set(gca, 'XTick', [], 'YTick', []);
    end
end

% Add a single colorbar on the side of the entire figure, applying to all subplots
h = colorbar;
h.Position = [0.93 0.1 0.02 0.8]; % Adjust the position of the colorbar

% Optionally add a global title for the entire figure
sgtitle('Mueller Matrix Elements for TiO2 Layer');