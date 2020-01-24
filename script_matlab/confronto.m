% Confronto
close all; clear; clc

% Implemented, working models
models = ["Holzer&Sommerfeld", "Holzer&Sommerfeld_simplified", ...
          "Swmee&Ojha", "Ganser", "Chien", "Dioguardi"];

% Implemented, working geometries
geometries = ["sphere", "cube", "spherocylinder"];

% Parameters
r = 1;              % radius for sphere, spherocylinder
l = 1;              % length for cube
h = 5;              % height for spherocylinder
D = inf;            % tube diameter (Ganser)

Re = logspace(1, 3, 1000);
cD = zeros(1, length(Re));

for k = 1:1:length(geometries)
    param = ShapeParameters (models, geometries(k), 1, 1, 5, inf);

    figure('Name', geometries(k))
    hold on
    Legend = cell(1, length(models));
    for i = 1:1:length(models)
        for j = 1:1:length(Re)
            cD(j) = cD_model(Re(j), models(i), param);
        end
        semilogx(Re, cD)
        Legend{i} = models(i);
    end
    legend(Legend)
end