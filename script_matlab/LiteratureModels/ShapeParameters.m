function [param] = ShapeParameters (models, geometry, r, l, h, D)
% Input parser

% load geometries data
geometries

% Initialize param struct
param.deq = 0;
param.phi = 0;
param.phi_perp = 0;
param.phi_par = 0;
param.psi = 0;
param.beta = 0;
param.K1 = 0;
param.K2 = 0;

param = repmat(param, 1, length(geometry));

% Array of all the possible shape parameters
SP = repmat("null", 1, 8);
% Template
if sum(models == 'All') > 0
    SP(1) = 'deq';
    SP(2) = 'phi';
    SP(3) = 'phi_perp';
    SP(4) = 'phi_par';
    SP(5) = 'psi';
    SP(6) = 'beta';
    SP(7) = 'K1';
    SP(8) = 'K2';
end

if sum(models == 'Holzer&Sommerfeld') > 0
    SP(1) = 'deq';
    SP(2) = 'phi';
    SP(3) = 'phi_perp';
    SP(4) = 'phi_par';
end
if sum(models == 'Holzer&Sommerfeld_simplified') > 0
    SP(1) = 'deq';
    SP(2) = 'phi';
    SP(3) = 'phi_perp';
end
if sum(models == 'Swamme&Ojha') > 0
    SP(1) = 'deq';
    SP(6) = 'beta';
end
if sum(models == 'Ganser') > 0
    SP(1) = 'deq';
    SP(2) = 'phi';
    SP(7) = 'K1';
    SP(8) = 'K2';
end
if sum(models == 'Chien') > 0
    SP(1) = 'deq';
    SP(2) = 'phi';
end
if sum(models == 'Dioguardi') > 0
    SP(1) = 'deq';
    SP(2) = 'phi';
    SP(5) = 'psi';
    SP(6) = 'beta';
end

% Remove unused parameters
SP(SP == 'null') = [];

for i = 1:1:length(geometry)
    for j = 1:1:length(SP)
    eval(['param(i).', char(SP(j)), ' = ', char(geometry), '.', char(SP(j)), ';'])
    end
end