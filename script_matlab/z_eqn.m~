function z_ddot = z_eqn(v)
% Equazione semplificata monodimensionale per la sola coordinata z
%
%          ddz/ddt = 1/2 rho_air dz/dt^2 S cD - mg 
%
% Ricerca soluzione di equilibrio => velocit� limite
%
% v_lim^2 cD(v_lim) = 2 m g / rho_air S

% Caricamento dati problema
data

z_ddot = v.^2 * cD(v) - 2*m*g / (rho_a * S);
