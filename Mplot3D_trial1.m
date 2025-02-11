% Clear workspace and command window
clc;
clear all;

% Step 1: Define the layer structure (air -> TiO2 -> air)
layerArray{1} = {'air', 0, [0 0 0], 0, 1};        % Incident medium (air)
layerArray{2} = {'TiO2', 10000, [0 0 0], 1, 0};   % TiO2 layer, 10000 nm thick
layerArray{3} = {'air', 0, [0 0 0], 0, 1};        % Exit medium (air)

% Step 2: Define the wavelength (in nm)
wavelengths = 500;  % Single wavelength at 500 nm

% Step 3: Set the grid size and maximum angle of incidence (AOI)
Npts = 100;       % 100x100 grid points in K-space
maxAOI = 60;      % Maximum angle of incidence of 60 degrees

% Step 4: Set flags for reflection and normalization
bReflect = false;  % Transmission mode
bNorm = true;      % Normalize the Mueller matrix
bConoscopic = false;  % Set to false for polar map

% Step 5: Compute the Mueller matrix using the mmBerremanMap function
MM = mmBerremanMap(layerArray, wavelengths, Npts, maxAOI, bReflect, bNorm, bConoscopic);

% Step 6: Define the list of colormaps
colormaps = {'HotCold Bright', 'HotCold Dark', 'Fireice', 'Spectral', 'RdYlGn', ...
             'RdYlBu', 'RdGy', 'RdBu', 'PuOr', 'PRGn', 'PiYG', 'BrBG'};

% Step 7: Loop through the colormaps and generate 4x4 Mueller matrix plots
figure;
for i = 1:length(colormaps)
    subplot(4, 3, i);  % Create a 4x3 grid of subplots
    
    % Create MPlot3D object for each colormap
    pObj = MPlot3D(MM, 'palette', colormaps{i}, 'fontsize', 12, 'width', 5, 'hSpacing', 2, 'vSpacing', 2);
    
    % Set the title to the name of the colormap
    title(colormaps{i}, 'FontSize', 10);
    
    % Optional: Set global scale for color consistency across all plots
    % pObj.gs = [-1, 1];  % Uncomment to set a global scale across all plots
end

% Step 8: Save the figure
saveas(gcf, 'TiO2_MuellerMatrix_ColormapComparison.png');
