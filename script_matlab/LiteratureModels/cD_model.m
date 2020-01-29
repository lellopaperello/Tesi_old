function cD = cD_model(Re, model, param)
% Implementazione dei vari modelli di cD presenti in letteratura
% deq = param.deq;
phi = param.phi;
phi_perp = param.phi_perp;
phi_par = param.phi_par;
psi = param.psi;
beta = param.beta;
K1 = param.K1;
K2 = param.K2;

% rho = 1.225;
% mu = 1.175e-5;
% 
% Re = rho * v * deq / mu;

switch model
    case 'debug'
        cD = 1;
    case 'Standard'
        % For spheres ONLY!!
        cD = SDC(Re);
    case 'Holzer&Sommerfeld'
        cD = 8/(Re * sqrt(phi_par)) + 16/ (Re * phi) ...
           + 3/ (sqrt(Re) + phi^0.75) ...
           + 0.42*10^(0.4 * (-log10(phi))^0.2) / phi_perp;
    case 'Holzer&Sommerfeld_simplified'
        cD = 8/(Re * sqrt(phi_perp)) + 16/ (Re * phi) ...
           + 3/ (sqrt(Re) + phi^0.75) ...
           + 0.42*10^(0.4 * (-log10(phi))^0.2) / phi_perp;
    case 'Swamme&Ojha'
        cD = 48.5 / ((1 + 4.5*beta^0.35)^0.8 * Re^0.64) ...
           + (Re / (Re + 100 + 100*beta))^0.32 ...
           * 1/ (beta^0.18 + 1.05*beta^0.8);
    case 'Ganser'
        cD = K2 * (24/ (Re * K1 * K2) * (1 + 0.1118*(Re * K1 * K2)^0.6567) ...
           + 0.4305 / (1 + 3305/(Re * K1 * K2)));
    case 'Chien'
        cD = 30 / Re + 67.289*exp(-5.05*phi);
    case 'Dioguardi'
        cD = SDC(Re) / (Re^2 * psi) * (Re / 1.1883)^2.0725;
end