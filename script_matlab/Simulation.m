close all; clear; clc
% Risoluzione delle equazioni del moto di un corpo rigido in caduta libera
% e calcolo della velocità limite

% Condizione iniziale - quiete
x0 = zeros(6, 1);

% Condizioni di arresto - raggiungimento velocità limite
global Equal
global zddot
global toll
toll = 1e-4;
zddot = toll;
Equal = false;
options = odeset('Events', @terminal_velocity);

[t, x] = ode45(@EquationsOfMotion, [0 10], x0);

figure(1)
plot(t, -x(:, 6))



