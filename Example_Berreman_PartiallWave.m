clc;
clear All;

layerArray {1} = {'air', 0, [0 0 0], 0, 1};
layerArray {2} = {'BK7', 0, [0 0 0], 0, 1};
layerArray {3} = {'Fused Silica', 0, [0 0 0], 0, 1};
layerArray {4} = {'KDPnoG', 1000000, [0 0 0], 1, 0};
layerArray {5} = {'Fused Silica', 0, [0 0 0], 0, 1};
layerArray {6} = {'BK7', 0, [0 0 0], 0, 1};
layerArray {7} = {'air', inf, [0 0 0], 0, 1};

layerArray = {layerArray{1}, layerArray{2}, layerArray{3}, layerArray{4}, layerArray{5}, layerArray{6}, layerArray{7}};


M0 = mmPartialWave(layerArray, 300, 0, 20, 0);
M1 = mmBerreman(layerArray, 300, 0, 20, 0);

disp(M0)
disp(M1)


