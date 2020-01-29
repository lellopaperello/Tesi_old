%% Modelli cD
close all; clear; clc
addpath('LiteratureModels')

% Implemented, working models
models = ["Holzer&Sommerfeld", "Holzer&Sommerfeld_simplified", ...
          "Swmee&Ojha", "Ganser", "Chien", "Dioguardi"];

% Implemented, working geometries
geometries = ["sphere", "cube", "cylinder", "spherocylinder"];

% Parameters
r = 1;              % radius for sphere, spherocylinder
l = 1;              % length for cube
h = 5;              % height for spherocylinder
D = inf;            % tube diameter (Ganser)

Re = logspace(-3, 1, 1000);
cD = zeros(1, length(Re));

for k = 1:1:length(geometries)
    param = ShapeParameters (models, geometries(k), 1, 1, 5, inf);

    figure('Name', geometries(k))
    Legend = cell(1, length(models));
    for i = 1:1:length(models)
        for j = 1:1:length(Re)
            cD(j) = cD_model(Re(j), models(i), param);
        end
        loglog(Re, abs(cD))
        hold on
        Legend{i} = models(i);
    end
    legend(Legend)
end


%% Velocita' limite
close all; clear; clc
addpath('LiteratureModels')

% Implemented, working models for cD calculation
% ["Holzer&Sommerfeld", "Holzer&Sommerfeld_simplified", "Swmee&Ojha",
%  "Ganser", "Chien", "Dioguardi"]
model_cD = "debug";

% Implemented, working geometries
% ["sphere", "cube", "cylinder", "spherocylinder"]
geometry = "sphere";

% Implemented, working models for density calculation
% ["Brandes"]
model_rho = "Brandes";

% Ambient parameters
rho_a = 1.225;
mu = 1.715e-5;
g = 9.81;
T = 263.15;
D = 0.005;
r_eq = D/2;

rho = rho_snow(D, model_rho);

m = 4/3*pi * r_eq.^3 * rho;
S = 4*pi * r_eq.^2;
Re_v = rho * D / mu;

param = ShapeParameters (model_cD, geometry, 1, 1, 5, inf);

% Equazione semplificata monodimensionale per la sola coordinata z
%
%          ddz/ddt = 1/2 rho_air dz/dt^2 S cD - mg 
%
% Ricerca soluzione di equilibrio => velocita' limite
%
% v_lim^2 cD(v_lim) = 2 m g / rho_air S

z_eqn =@(v) v.^2 * cD_model(Re_v * v, model_cD, param) - 2*m*g / (rho_a * S);

% Equation solution
v_lim = abs(fzero(z_eqn, 0.01));

