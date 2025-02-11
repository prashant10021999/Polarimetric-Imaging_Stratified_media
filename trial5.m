% Clear workspace and command window
clc;
clear All;

% Define other simulation parameters (not dependent on thickness)
wavelengths = 400; % Wavelength in nanometers
Npts = 1000;        % Number of grid points in X and Y
maxAOI = 45;       % Maximum angle of incidence in degrees
bReflect = 0;      % Set to true (1) for reflection matrix
bNorm = 1;         % Set to true (1) for normalization
bConoscopic = 1;   % Set to true (1) for conoscopic map

% Define folder for saving plots
outputFolder = 'MuellerMatrixPlots';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Set thickness range and step
thicknessRange = 4850:10:10000;
totalSteps = length(thicknessRange); % Total number of iterations

% Initialize timing variables
startTime = tic;  % Start timer

% Loop over thickness values (from 10 nm to 100 nm in steps of 10 nm)
for step = 1:totalSteps
    thickness = thicknessRange(step);
    
    % Define the layer array with the current thickness
    layerArray{1} = {'air', 0, [0 0 0], 0, 1};
    layerArray{2} = {'TiO2', thickness, [0 0 0], 1, 0};  % TiO2 layer with changing thickness
    layerArray{3} = {'air', 0, [0 0 0], 0, 1};

    % Compute the Mueller matrix using mmBerremanMap
    M = mmBerremanMap(layerArray, wavelengths, Npts, maxAOI, bReflect, bNorm, bConoscopic);

    % Create a new figure without displaying it
    hFig = figure('Visible', 'off');

    % Find the global min and max for the color scale (for consistent scaling)
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

    % Add a single colorbar on the side of the entire figure
    h = colorbar;
    h.Position = [0.93 0.1 0.02 0.8]; % Adjust the position of the colorbar

    % Add a global title with the current thickness
    sgtitle(['Mueller Matrix for TiO2 Layer, Thickness = ', num2str(thickness), ' nm']);

    % Save the figure in the output folder with the filename as the thickness
    saveas(hFig, fullfile(outputFolder, [num2str(thickness), 'nm_MuellerMatrix.png']));

    % Close the figure to avoid memory issues with too many open figures
    close(hFig);
    
    % Calculate elapsed time and estimated time remaining
    elapsedTime = toc(startTime);  % Time since the start of the loop
    avgTimePerStep = elapsedTime / step;  % Average time per iteration
    estimatedRemainingTime = avgTimePerStep * (totalSteps - step);  % Estimate remaining time
    
    % Display progress in the command window, along with elapsed and remaining time
    fprintf('Progress: %.2f%% (Saved thickness %d nm) | Elapsed time: %.2f seconds | Estimated remaining time: %.2f seconds\n', ...
        (step/totalSteps)*100, thickness, elapsedTime, estimatedRemainingTime);
end

disp('All plots saved successfully in the folder: MuellerMatrixPlots');
