% Fitting of experimental data
close all; clear; clc %#ok<*NOPTS>

%% Brandes et al. 2008 "Aggregate Terminal Velocity/Temperature Relations"
load('DvsT-Brandes.csv')
Texp = DvsT_Brandes(:, 1);
Dexp = DvsT_Brandes(:, 2);
clearvars DvsT_Brandes

% Fitting by means of an exponential function
fun = fittype( @(D0, D1, exp, x0, x) D1 * (x - x0).^exp + D0);
Dfit = fit(Texp, Dexp, fun)

%%
figure('Name', 'Brandes et al. - 2008')
scatter(Texp, Dexp, '+')
hold on
plot(Texp, Dfit(Texp), 'r')

legend('Experimental data', 'fitting')
xlabel('T [K]')
ylabel('D [m]')