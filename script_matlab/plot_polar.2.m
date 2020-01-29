close all; clear; clc

% Import polars
tut = importdata('polar_tutorial/polar2.txt');
tut_scaled = importdata('tutorial_scaled/polar.txt');
uhMesh = importdata('polar_uhMesh2/polar2.txt');
uhMesh_small = importdata('polar_uhMesh_small2/polar2.txt');

% uhMesh_small(:, 2) = uhMesh_small(:, 2)*10^3; 


% Exact solution - cylinder (Clift)
cd_exact =@(Re) 24 .* (1 + 0.15.* Re.^0.687) ./ Re;
% Plots

figure()
plot(tut(:, 1), tut(:, 2), uhMesh(:, 1), uhMesh(:, 2), ...
     uhMesh_small(:, 1), uhMesh_small(:, 2), ... 
     uhMesh(:, 1), cd_exact(uhMesh(:, 1)))
hold on;
plot(tut_scaled(:, 1), tut_scaled(:, 2))
 
legend('tutorial', 'uhMesh', 'uhMesh_{small}', 'exact', 'tutorial_{scaled}')
xlabel('Re [-]')
ylabel('c_D [-]')

figure('Name', 'Detail')
z = 10; % zoom

plot(tut(z:end, 1), tut(z:end, 2), uhMesh(z:end, 1), uhMesh(z:end, 2), ...
     uhMesh_small(z:end, 1), uhMesh_small(z:end, 2), ...
     uhMesh(z:end, 1), cd_exact(uhMesh(z:end, 1)))
 
legend('tutorial', 'uhMesh', 'uhMesh_{small}', 'exact')
xlabel('Re [-]')
ylabel('c_D [-]')
