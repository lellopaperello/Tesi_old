% Fitting of experimental data
close all; clear; clc %#ok<*NOPTS>

%% Brandes et al. 2008 "Aggregate Terminal Velocity/Temperature Relations"
load('TvsD-Brandes.csv')
Texp = TvsD_Brandes(:, 1);
Dexp = TvsD_Brandes(:, 2);
clearvars TvsD_Brandes

% Fitting by means of an exponential function
fun = fittype( @(D0, D1, exp, x0, x) D1 * (x - x0).^exp + D0);
Dfit = fit(Texp, Dexp, fun)

%%
figure()
scatter(Texp, Dexp, '+')
hold on
plot(Texp, Dfit(Texp), 'r')

title('Brandes et al. - 2008')
legend('Experimental data', 'fitting')
xlabel('T [K]')
ylabel('D [m]')

%% Venu Madhav and Chhabra 1994 "Dralg on non-spherical particles in 
% viscous fluids"
close all; clear; clc
load('cDvsRe_references.mat')
clearvars -except snowflakes

Cubes = load('CubesOctahydralsTetrahydrals - PC.csv');
Cyl1 = load('Cylinders - UC.csv');
Cyl2 = load('Cylinders - VMC.csv');


SpCyl = load('SpheresCylinders - CB.csv');

Cylinders = [Cyl1; Cyl2; SpCyl(3:end, :)];
Spheres = SpCyl([1 2], :);

figure()
scatter(Cubes(:, 1), Cubes(:, 2), 'sk')
hold on
scatter(Cylinders(:, 1), Cylinders(:, 2), 'ok')
scatter(Spheres(:, 1), Spheres(:, 2), 'ok', 'Filled')

title('Venu Madhav and Chhabra - 1994')
legend('Cubes, Octahydrals and Tetrahydrals', 'Cylinders', 'Spheres')
set(gca,'xscale','log')
set(gca,'yscale','log')
xlabel('Re [-]')
ylabel('cD [-]')

clearvars -except snowflakes Cubes Spheres Cylinders
save cDvsRe_references.mat

%% List and Shemanauer 1971 "Free-fall beavior of planar snow crystals, 
% conical graupel and small hail"
close all; clear; clc
load('cDvsRe_references.mat')
clearvars -except Cubes Spheres Cylinders

raw = importdata('Snowflakes - LS.csv');
snowflakes = cell(2, 12);
for i = 1:1:12
    snowflakes{1, i} = raw.textdata{(2*i - 1)};
    snowflakes{2, i} = raw.data(:, [2*i-1 2*i]);
end

figure()
Legend = cell(1, 6);
for i = 1:1:6
    scatter(snowflakes{2, i}(:, 1), snowflakes{2, i}(:, 2), ...
            8, 'filled')
    hold on
    Legend{i} = snowflakes{1, i};
end

title('List and Shemanauer - 1971')
legend(Legend);
set(gca,'xscale','log')
set(gca,'yscale','log')
xlabel('Re [-]')
ylabel('cD [-]')

clearvars -except snowflakes Cubes Spheres Cylinders
save cDvsRe_references.mat