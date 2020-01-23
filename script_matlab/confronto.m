% Confronto
close all; clear; clc

models = ["Holzer&Sommerfeld", "Holzer&Sommerfeld_simplified", ...
          "Swmee&Ojha", "Ganser", "Chien", "Dioguardi"];

param = ShapeParameters (models, "spherocylinder", 1, 1, 5, inf);

Re = logspace(1, 3, 1000);
cD = zeros(1, length(Re));

figure()
hold on
Legend = cell(1, length(models));
for i = 1:1:length(models)
    for j = 1:1:length(Re)
        cD(j) = cD_model(Re(j), models(i), param);
    end
    semilogx(Re, cD)
    Legend{i} = models(i);
end
legend(Legend)