% Clear workspace and command window
clc;
clear all;

% Step 1: Build the model
layerArray{1} = {'air', 0, [0 0 0], 0, 1};                  % Incident medium (air)
layerArray{2} = {'+quartz', 1000000, [0 0 0], 1, 0};        % Quartz layer (1 mm thick)
layerArray{3} = {'air', 0, [0 0 0], 0, 1};                  % Exit medium (air)

% Step 2: Calculate transmission Mueller matrix spectra
M0 = mmPartialWave(layerArray, 300:750, 0, 1, 0);           % Angle of incidence 0 degrees
M10 = mmPartialWave(layerArray, 300:750, 10, 1, 0);         % Angle of incidence 10 degrees
M20 = mmPartialWave(layerArray, 300:750, 20, 1, 0);         % Angle of incidence 20 degrees

% Step 3: Plot the data using MPlot
pObj = MPlot(300:750, cat(4, M0, M10, M20), ...
    'size', [800 500], ...                               % Set the figure size
    'borderFactor', 3, 'vSpace', 10, ...                 % Adjust spacing
    'title', '1 mm c-cut quartz in transmission', ...    % Add a title
    'legend', {'AOI', [0 10 20]}, ...                    % Create a legend
    'lineNV', {'LineWidth', 2}, ...                      % Set line width
    'axNV', {'ColorOrder', cbrewer('qual', 'Set2', 3)}); % Modify line colors using ColorBrewer

% Step 4: Save the figure to a file
pObj.print('MPlot_example1.eps');                         % Save the plot as an EPS file
