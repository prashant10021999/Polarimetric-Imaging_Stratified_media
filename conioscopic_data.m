clc;
clear all;

% Define the layer structure (air -> TiO2 -> glass)
layerArray{1} = {'air', 0, [0 0 0], 0, 1};         % Incident medium (air)
layerArray{2} = {'TiO2', 300, [0 0 0], 0, 0};      % TiO2 layer, 300 nm thick
layerArray{3} = {'air', Inf, [0 0 0], 0, 1};     % Glass substrate (semi-infinite)

% Define wavelengths (in nm)
wavelengths = 500;  % Single wavelength at 500 nm (you can also use a range like 400:10:800)

% Set the grid size and maxAOI
Npts = 100;       % 100x100 grid points
maxAOI = 60;      % Maximum angle of incidence of 60 degrees

% Set the flags for reflection and normalization
bReflect = false;    % Set to false for transmission
bNorm = true;        % Normalize the Mueller matrix

% Set whether to compute a conoscopic map
bConoscopic = false; % Set to false for a polar map (you can set it to true for conoscopic)

% Call the mmBerremanMap function to compute the Mueller matrix
MM = mmBerremanMap(layerArray, wavelengths, Npts, maxAOI, bReflect, bNorm, bConoscopic);

% Now plot all the elements of the Mueller matrix in K-space

% Create a figure to hold the subplots for all 16 Mueller matrix elements
figure;

% Loop through each element of the 4x4 Mueller matrix
for i = 1:4
    for j = 1:4
        % Extract the (i,j) element of the Mueller matrix at the first wavelength
        Mij = squeeze(MM(i, j, :, :, 1));  % Extract the (i,j) element
        
        % Create a subplot for each element
        subplot(4, 4, (i-1)*4 + j);
        
        % Plot the element using imagesc
        imagesc(Mij);
        axis equal;
        colorbar;
        
        % Set title for each subplot
        title(['M' num2str(i) num2str(j)]);
        
        % Remove axis labels for a cleaner look
        set(gca, 'XTick', [], 'YTick', []);
    end
end

% Add a global title for the entire figure
sgtitle('All 16 Elements of the Mueller Matrix (Transmission)');
