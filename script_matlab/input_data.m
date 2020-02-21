% Input file
close all; clear; clc
addpath('LiteratureModels')

% -------------------------------------------------------------------------
% MODELS
% -------------------------------------------------------------------------

% Implemented reference models for cD calculation
% -------------------------------------------------------------------------
%  'All'
%  "Holzer&Sommerfeld"
%  "Holzer&Sommerfeld_simplified"
%  "Swamme&Ojha"
%  "Ganser"
%  "Chien"
%  "Dioguardi"
%  "Heymsfield&Westbrook"
%  "VenuMadhav&Chhabra"
%  "debug"

model_cD = ["Holzer&Sommerfeld", "Ganser", "Heymsfield&Westbrook", "VenuMadhav&Chhabra"];

% Implemented reference models for density calculation
% -------------------------------------------------------------------------
%  "Brandes"

model_rho = "Brandes";

% Implemented reference model for terminal velocity - diameter
% relationships
% -------------------------------------------------------------------------
%  'All'
%  "Brandes - 2008, T = -1°C"
%  "Brandes - 2008, T = -5°C"
%  "Brandes - 2008, T = -10°C"
%  "Kuhn-Martin - 2019, graupel"
%  "Kuhn-Martin - 2019, rimed needles" 
%  "Justo-Bosworth - 1971, dendrites"
%  "Justo-Bosworth - 1971, plates & columns"
%  "Justo-Bosworth - 1971, average"

model_vt = [
 "Brandes - 2008, T = -1°C"
 "Brandes - 2008, T = -5°C"
 "Brandes - 2008, T = -10°C"
 "Justo-Bosworth - 1971, dendrites"
 "Justo-Bosworth - 1971, plates & columns"
 "Justo-Bosworth - 1971, average"
];

% Implemented, working geometries
% -------------------------------------------------------------------------
%  'All'
%  "sphere"
%  "cube"
%  "cylinder"
%  "spherocylinder"

geometry = "cylinder";

% Geometrical parameters
% -------------------------------------------------------------------------

% Sphere
r = 1;              % [ m ]

% Cube
l = 1;              % [ m ]

% Cylinder
r_cyl = 1;       % [ m ]
h_cyl = 2;     % [ m ]

% Spherocyinder
r_sc = 1;           % [ m ]
h_sc = 1;           % [ m ]


% -------------------------------------------------------------------------
% AMBIENT PARAMETERS
% -------------------------------------------------------------------------
rho_a = 1.225;      % air density               [ kg/m^3 ]
mu = 1.715e-5;      % air viscosity             [ kg/ms ]
g = 9.81;           % gravity field             [ N/kg ]
T = 263.15;         % GROUND air temperature    [ K ]
D_tube = inf;       % tube diameter (Ganser)    [ m ]




% -------------------------------------------------------------------------
% DO NOT TOUCH 
% -------------------------------------------------------------------------

model_cD_def = ["Holzer&Sommerfeld", "Holzer&Sommerfeld_simplified", ...
                 "Swamme&Ojha", "Ganser", "Chien", "Dioguardi", ...
                 "Heymsfield&Westbrook", "VenuMadhav&Chhabra"];
if sum(model_cD == 'All') == length(model_cD)
    model_cD = model_cD_def;
end

model_rho_def = ["Brandes"];
if sum(model_rho == 'All') == length(model_rho)
    model_rho = model_rho_def;
end

model_vt_def = ["Brandes - 2008, T = -1°C", "Brandes - 2008, T = -5°C", ...
                "Brandes - 2008, T = -10°C", "Kuhn-Martin - 2019, graupel", ...
                "Kuhn-Martin - 2019, rimed needles", "Justo-Bosworth - 1971, dendrites", ...
                "Justo-Bosworth - 1971, plates & columns", "Justo-Bosworth - 1971, average"];
if sum(model_vt == 'All') == length(model_vt)
    model_vt = model_vt_def;
end

geometry_def = ["sphere", "cube", "cylinder", "spherocylinder"];
if sum(geometry == 'All') == length(geometry)
    geometry = geometry_def;
end

geom_param = [r, l, r_cyl, h_cyl, r_sc, h_sc, D_tube];

clearvars model_cD_def model_rho_def model_vt_def geometry_def