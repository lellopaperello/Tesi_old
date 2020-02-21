% Script per i vari confronti tra modelli di cD, velocità limite e
% risultati sperimentali. I parametri comuni (scelta dei mdelli, geometrie,
% variabili d'ambiente ecc..) vanno modificti nel file 'input_data.m', che
% viene chiamato all'inizio di ogni sezione.
% -------------------------------------------------------------------------
%#ok<*SAGROW>

%% cD calculation for model comparison
input_data

Re = logspace(-5, 5, 1000);
cD = NaN*ones(length(geometry), length(model_cD), length(Re));

for k = 1:1:length(geometry)
    param = ShapeParameters (model_cD, geometry(k), geom_param);
    
    for j = 1:1:length(model_cD)
        for i = 1:1:length(Re)
            cD(k, j, i) = cD_model(Re(i), model_cD(j), param);
        end
    end
end

%% Unicity of the solution

D = 0.02;
rho = rho_snow(D, model_rho);

% Graphical solution: cD = f(v(Re)) = f(1/Re^2)
RHS =@(Re) 4/3 * (rho - rho_a)*rho_a * D^3 * g ./ ((mu*Re).^2);

% Plots
for k = 1:1:length(geometry)
    figure('Name', geometry(k))
    clearvars Legend
    Legend = cell(1, length(model_cD));
    for j = 1:1:length(model_cD)
        loglog(Re, squeeze(cD(k, j, :)), '--')
        hold on; grid on
        Legend{j} = model_cD(j);
    end
    % For spheres only
    if strcmp(geometry(k), 'sphere')
        loglog(Re, SDC(Re), '-o')
        Legend{end+1} = 'Standard Drag Curve'; 
    end
    % Right-Hand Side 
    loglog(Re, RHS(Re), '-k')
    Legend{end+1} = 'Right-Hand Side';
    
    title('Graphical solution of the terminal velocity equation')
    xlabel('Re [ - ]')
    ylabel('cD, RHS [ - ]')
    legend(Legend);
end


%% Experimental data
close all; clear; clc
load('../Data/cDvsRe_references.mat');

figure()
Legend = cell(1, 6);
for i = 1:1:6
    scatter(snowflakes{2, i}(:, 1), snowflakes{2, i}(:, 2), ...
            8, 'filled')
    hold on
    Legend{i} = snowflakes{1, i};
end

scatter(Cubes(:, 1), Cubes(:, 2), 'sk')
Legend{end+1} = "Cubes, Octahydrals and Tetrahydrals - VMC-1994";
scatter(Cylinders(:, 1), Cylinders(:, 2), 'ok')
Legend{end+1} = "Cylinders - VMC-1994";
scatter(Spheres(:, 1), Spheres(:, 2), 'ok', 'Filled')
Legend{end+1} = "Spheres - VMC-1994";

title('Experimental data')
legend(Legend);
set(gca,'xscale','log')
set(gca,'yscale','log')
xlabel('Re [-]')
ylabel('cD [-]')


%% Comparison with references BY GEOMETRY
load('../Data/cDvsRe_references.mat');

% Cylinder / disk ---------------------------------------------------------
k = find(strcmp(geometry, 'cylinder'));
i_cyl = find(Re > 1e-1 & Re < 1e5);

figure()
Legend = cell(1, length(model_cD));
for j = 1:1:length(model_cD)
    loglog(Re(i_cyl), squeeze(cD(k, j, i_cyl)))
    hold on
    Legend{j} = model_cD(j);
end
scatter(snowflakes{2, 1}(:, 1), snowflakes{2, 1}(:, 2), ...
            8, 'filled')
Legend{end+1} = snowflakes{1, 1};
scatter(Cylinders(:, 1), Cylinders(:, 2), 'ok')
Legend{end+1} = "Cylinders - VMC-1994";
    
title('Comparison models - experimental data: CYLINDER')
legend(Legend);
xlabel('Re [-]')
ylabel('cD [-]')

% Cubes -------------------------------------------------------------------
k = find(strcmp(geometry, 'cube'));
i_cube = find(Re > 1e-5 & Re < 1e3);

figure()
Legend = cell(1, length(model_cD));
for j = 1:1:length(model_cD)
    loglog(Re(i_cube), squeeze(cD(k, j, i_cube)))
    hold on
    Legend{j} = model_cD(j);
end
    
scatter(Cubes(:, 1), Cubes(:, 2), 'sk')
Legend{end+1} = "Cubes - VMC-1994";

title('Comparison models - experimental data: CUBES')
legend(Legend);
xlabel('Re [-]')
ylabel('cD [-]')


%% vt calculation for model comparison
close all; clear; clc
input_data

D = 0.001:0.0001:0.02;
v_lim = NaN*ones(length(geometry), length(model_cD), length(D));

for i = 1:1:length(D)
    % snow properties
    rho = rho_snow(D(i), model_rho);
    Re_v = rho_a * D(i) / mu;
    
    for k = 1:1:length(geometry)
        param = ShapeParameters (model_cD, geometry(k), geom_param);
        
        for j = 1:1:length(model_cD)
        % Equazione semplificata monodimensionale per la sola coordinata z
        %
        %          ddz/ddt = 1/2 rho_air dz/dt^2 S cD - mg 
        %
        % Ricerca soluzione di equilibrio => velocita' limite
        %
        % v_lim^2 cD(Re(v_lim)) = 4/3 (rho - rho_a)/rho_a D g

        z_eqn =@(v) v.^2 * cD_model(Re_v * abs(v), model_cD(j), param) ...
                    - 4/3 * (rho - rho_a)/rho_a * D(i)*g;

        % Equation solution
        v_lim(k, j, i) = abs(fzero(z_eqn, [1e-3 1e3]));
        end
    end
end


%% Model comparison
for k = 1:1:length(geometry)
    figure()
    clearvars Legend
    Legend = cell(1, length(model_cD) + length(model_vt));
    hold on
    for i = 1:1:length(model_cD)
        plot(D*1e3, squeeze(v_lim(k, i, :)))
        Legend{i} = model_cD(i);
    end
    % References
    for i = 1:1:length(model_vt)
        plot(D*1e3, reference(D, model_vt(i)), '--')
        Legend{length(model_cD) + i} = model_vt(i);
    end
%     title(['Terminal velocity comparison: ' geometry(k)])
    title(["Terminal velocity comparison:" "cylinder  (a = 2)"])
    xlabel('Diameter [ mm ]')
    ylabel('Limit Velocity [ m/s ]')
    axis([0 20 0 4])
    thelegend = legend(Legend);
    thelegend.NumColumns = 2;
end

%% References for vt
close all; clear; clc

input_data
D = 0.001:0.0001:0.02;

figure('Name', 'Reference comparison')
Legend = cell(1, length(model_vt));
hold on

plot(D*1e3, reference(D, model_vt(1)), 'r-')
plot(D*1e3, reference(D, model_vt(2)), 'r-.')
plot(D*1e3, reference(D, model_vt(3)), 'r--')
plot(D*1e3, reference(D, model_vt(4)), 'b-')
plot(D*1e3, reference(D, model_vt(5)), 'b--')
plot(D*1e3, reference(D, model_vt(6)), 'k-')
plot(D*1e3, reference(D, model_vt(7)), 'k--')
plot(D*1e3, reference(D, model_vt(8)), 'k-.')

title('Reference comparison')
xlabel('Diameter [ mm ]')
ylabel('Limit Velocity [ m/s ]')
legend(model_vt);
