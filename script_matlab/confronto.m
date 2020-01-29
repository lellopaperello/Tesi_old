%% Modelli cD
close all; clear; clc
addpath('LiteratureModels')

% Implemented, working models for cD calculation
% ["Holzer&Sommerfeld", "Holzer&Sommerfeld_simplified", "Swmee&Ojha",
%  "Ganser", "Chien", "Dioguardi"]
models = ["Holzer&Sommerfeld", "Holzer&Sommerfeld_simplified", ...
          "Ganser"];

% Implemented, working geometries
% ["sphere", "cube", "cylinder", "spherocylinder"]
geometries = ["sphere", "cube", "cylinder", "spherocylinder"];

% Parameters
r = 1;              % radius for sphere, spherocylinder
l = 1;              % length for cube
h = 5;              % height for spherocylinder
D = inf;            % tube diameter (Ganser)

Re = logspace(-3, 4, 1000);
cD = zeros(1, length(Re));

for k = 1:1:length(geometries)
    param = ShapeParameters (models, geometries(k), r, l, h, D);

    figure('Name', geometries(k))
    Legend = cell(1, length(models));
    for i = 1:1:length(models)
        for j = 1:1:length(Re)
            cD(j) = cD_model(Re(j), models(i), param);
        end
        loglog(Re, cD)
        hold on
        Legend{i} = models(i);
    end
    if geometries(k) == "sphere"
        loglog(Re, SDC(Re))
        Legend{end+1} = "Standard Drag Curve";
    end
    legend(Legend)
end


%% Velocita' limite
close all; clear; clc %#ok<*NOPTS>
addpath('LiteratureModels')

% Implemented, working models for cD calculation
% ["Holzer&Sommerfeld", "Holzer&Sommerfeld_simplified", "Swmee&Ojha",
%  "Ganser", "Chien", "Dioguardi", "Standard" (SPHERE ONLY!), "debug"]
model_cD = ["Holzer&Sommerfeld", "Holzer&Sommerfeld_simplified", "Ganser"];

% Implemented, working geometries
% ["sphere", "cube", "cylinder", "spherocylinder"]
geometry = ["sphere", "cube", "cylinder", "spherocylinder"];

% Implemented, working models for density calculation
% ["Brandes"]
model_rho = "Brandes";

% Ambient parameters
rho_a = 1.225;
mu = 1.715e-5;
g = 9.81;
T = 263.15;
D = 0.001:0.0001:0.02;

v_lim = NaN*ones(length(geometry), length(model_cD), length(D));

for j = 1:1:length(D)
    % snow properties
    rho = rho_snow(D(j), model_rho);
    r_eq = D(j)/2;
    m = 4/3*pi * r_eq.^3 * rho;
    S = 4*pi * r_eq.^2;
    Re_v = rho * D(j) / mu;

    for k = 1:1:length(geometry)
        param = ShapeParameters (model_cD, geometry(k), 1, 1, 5, inf);
        for i = 1:1:length(model_cD)
        % Equazione semplificata monodimensionale per la sola coordinata z
        %
        %          ddz/ddt = 1/2 rho_air dz/dt^2 S cD - mg 
        %
        % Ricerca soluzione di equilibrio => velocita' limite
        %
        % v_lim^2 cD(v_lim) = 2 m g / rho_air S

        z_eqn =@(v) v.^2 * cD_model(Re_v * abs(v), model_cD(i), param) - 2*m*g / (rho_a * S);

        % Equation solution
        v_lim(k, i, j) = abs(fzero(z_eqn, 0.01));
        end
    end
end

% Plots
% Model comparison
for k = 1:1:length(geometry)
    figure('Name', geometry(k))
    clearvars Legend
    Legend = cell(1, length(model_cD));
    hold on
    for i = 1:1:length(model_cD)
        plot(D, squeeze(v_lim(k, i, :)))
        Legend{i} = model_cD(i);
    end
    title(geometry(k))
    xlabel('Diameter [ m ]')
    ylabel('Limit Velocity [ m/s ]')
    legend(Legend);
end

% Geometry comparison