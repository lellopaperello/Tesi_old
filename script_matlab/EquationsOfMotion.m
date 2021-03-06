function dxdt = EquationsOfMotion (~, x)
% Implementazione delle equazioni del moto di un corpo rigido (2D) in 
% caduta libera.

% Vettore di stato: x
% x(1) = theta [rad] - angolo d'incidenza (rispetto all'asse z)
% x(2) = y [m]       - coordinata laterale (associata alla portanza)
% x(3) = z [m]       - coordinata verticale (associata alla resistenza)
% x(4) = dtheta/dt
% x(5) = dy/dt
% x(6) = dz/dt

% Caricamento dati problema
data

% Coefficienti aerodinamici
[cL, cD, cM] = cF('debug'); % DA CAMBIARE


% Equazioni del moto ------------------------------------------------------

dxdt = zeros(6, 1);
dxdt(1) = x(4);
dxdt(2) = x(5);
dxdt(3) = x(6);
dxdt(4) = 1/I * 0.5*rho_a*S*c * x(6).^2 * cM;
dxdt(5) = 1/m * 0.5*rho_a*S * x(6).^2 * cL;
dxdt(6) = 1/m * (0.5*rho_a*S * x(6).^2 * cD - m*g);

global Equal
global zddot
global toll
Equal = abs(dxdt(6)) < toll && abs(zddot) < toll;
zddot = dxdt(6);
