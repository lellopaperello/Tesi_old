% DATA
% Parametri ambiente
rho_a = 1.225; 
g = 9.81;

% Parametri corpo rigido
rho = 1;
r_eq = 1;
I = 1;

m = 4/3*pi * r_eq.^3 * rho;
S = 4*pi * r_eq.^2;
c = r_eq;

% Geometrie classiche
% Ogni riga rappresenta una geometria:
% GEOM {i, 1} = 'Nome Geometria'
% GEOM {i, 2} = [deq, A, Aperp, Apar, V] ~ parametri fondamentali
% GEOM {i, 3} = [PHI, PHIperp, PHIpar, PSI, beta, K1, K2, D] ~ parametri derivati
GEOM = cell(2, 3);

% Sfera
r = 1;
GEOM{1, 1} = 'Sphere';
GEOM{1, 2} = [2*r, 4*pi*r^2, pi*r^2, pi*r^2, 4/3*pi*r^3];
GEOM{1, 3} = zeros(1, 8);

% Sphericity [PSI] = As / Ap
GEOM{1, 3} (1) = GEOM{1, 2} (2) / GEOM{1, 2} (2);

% Crosswise Sphericity [PSIperp] = As_perp / Ap_perp
GEOM{1, 3} (2) = GEOM{1, 2} (3) / GEOM{1, 2} (3);

% Lengthwise Sphericity [PSIpar] = As_perp / (Ap/2 - Ap_par)
GEOM{1, 3} (3) = GEOM{1, 2} (3) / (GEOM{1, 2} (2) /2 - GEOM{1, 2} (4));


