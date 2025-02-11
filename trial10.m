% Clear workspace and command window
clc;
clear All;

% Define other simulation parameters
wavelengths = 400;  % Wavelength in nanometers
Npts = 10000;        % Number of grid points in X and Y
maxAOI = 45;        % Maximum angle of incidence in degrees
bReflect = 0;       % Set to true (1) for reflection matrix
bNorm = 1;          % Set to true (1) for normalization
bConoscopic = 1;    % Set to true (1) for conoscopic map

% Define the list of crystals
crystals = {'rubrene', '+EDS', '-EDS', 'SYEDS', '+quartz', '-quartz', ...
            'sapphire', 'aBBO', 'KDPnoG', 'LiNbO3', 'KDP', 'KAP', 'TiO2'};

% Define folder for saving plots
outputFolder = 'MuellerMatrixPlots';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Set thickness range and step
thicknessRange = 100:100:10000; % Adjust thickness step if needed to reduce iterations

% Create all necessary subfolders outside the parfor loop
for step = 1:length(thicknessRange)
    thickness = thicknessRange(step);
    thicknessFolder = fullfile(outputFolder, [num2str(thickness), 'nm']);
    if ~exist(thicknessFolder, 'dir')
        mkdir(thicknessFolder);  % Create the subfolder for each thickness value
    end
end

% Initialize timing variables
startTime = tic;  % Start timer

% Open MATLAB parallel pool (this will speed up parallel execution)
poolObj = gcp(); % Get the current parallel pool

% **Set up the DataQueue for progress reporting**
q = parallel.pool.DataQueue;
afterEach(q, @(x) fprintf('Progress: %.2f%%\n', x));  % This will print progress to the command window

% Total number of iterations (used for progress tracking)
totalSteps = length(thicknessRange) * length(crystals);
completedSteps = 0;  % Initialize completed steps

% Parallel loop over thickness values
parfor step = 1:length(thicknessRange)
    thickness = thicknessRange(step);
    
    % Create a subfolder for this thickness (already done outside, so just reference it)
    thicknessFolder = fullfile(outputFolder, [num2str(thickness), 'nm']);
    
    % Loop through each crystal type
    for c = 1:length(crystals)
        crystalName = crystals{c};
        
        % Define the layer array with the current thickness and crystal
        layerArray = cell(1, 3); % Preallocate the cell array
        layerArray{1} = {'air', 0, [0 0 0], 0, 1};
        layerArray{2} = {crystalName, thickness, [0 0 0], 1, 0};  % Current crystal
        layerArray{3} = {'air', 0, [0 0 0], 0, 1};
        
        % Compute the Mueller matrix using mmBerremanMap
        M = mmBerremanMap(layerArray, wavelengths, Npts, maxAOI, bReflect, bNorm, bConoscopic);

        % Create a new figure without displaying it
        hFig = figure('Visible', 'off');
        
        % Find the global min and max for the color scale (for consistent scaling)
        minVal = min(M(:));
        maxVal = max(M(:));
        
        % Create a 4x4 grid of subplots for each matrix element
        for i = 1:4
            for j = 1:4
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
        hColorbar = colorbar('Position', [0.92, 0.1, 0.02, 0.8]); % Adjust the position

        % Add a global title with the current thickness and crystal name
        sgtitle(['Mueller Matrix for ', crystalName, ', Thickness = ', num2str(thickness), ' nm']);

        % Save the figure in the thickness folder with the filename as the thickness and crystal name
        saveas(hFig, fullfile(thicknessFolder, [num2str(thickness), 'nm_', crystalName, '.png']));

        % Close the figure to avoid memory issues with too many open figures
        close(hFig);
        
        % **Update progress after each iteration**
        send(q, (completedSteps / totalSteps) * 100);
        completedSteps = completedSteps + 1;
    end
end

% Display the total elapsed time
elapsedTime = toc(startTime);
fprintf('All plots saved successfully.\n');
fprintf('Total elapsed time: %.2f seconds\n', elapsedTime);
