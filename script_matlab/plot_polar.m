close all; clear; clc

% Import data -------------------------------------------------------------
path = '/home/lello/Desktop/Tesi/Spherocylinder/solution/polars';

% Get a list of all files and folders in this folder (polars).
files = dir(path);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

DATA = cell(length(subFolders)-2, 2);
for i = 1:1:length(subFolders)-2
    % Get a list of all files and folders in this folder (meshes).
    files = dir([path '/' subFolders(i+2).name]);
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subsubFolders = files(dirFlags);
    
    DATA{i, 1} = subFolders(i+2).name;
    DATA{i, 2} = cell(length(subsubFolders)-2, 2);
    for j = 1:1:length(subsubFolders)-2
        DATA{i, 2}{j, 1} = subsubFolders(j+2).name;
        DATA{i, 2}{j, 2}(:, 1) = importdata([path '/' subFolders(i+2).name '/' subsubFolders(j+2).name '/alpha.dat']);
        DATA {i, 2}{j, 2}(:, 2) = -importdata([path '/' subFolders(i+2).name '/' subsubFolders(j+2).name '/cl.dat']);
        DATA{i, 2}{j, 2}(:, 3) = importdata([path '/' subFolders(i+2).name '/' subsubFolders(j+2).name '/cd.dat']);
        DATA{i, 2}{j, 2}(:, 4) = importdata([path '/' subFolders(i+2).name '/' subsubFolders(j+2).name '/cm.dat']);
        DATA{i, 2}{j, 2}(:, 5) = importdata([path '/' subFolders(i+2).name '/' subsubFolders(j+2).name '/cfx.dat']);
        DATA{i, 2}{j, 2}(:, 6) = -importdata([path '/' subFolders(i+2).name '/' subsubFolders(j+2).name '/cfy.dat']);
        DATA{i, 2}{j, 2}(:, 7) = importdata([path '/' subFolders(i+2).name '/' subsubFolders(j+2).name '/cfz.dat']);
        % Corrections
        DATA{i, 2}{j, 2}(:, 4) = DATA{i, 2}{j, 2}(:, 4) * 2;
        % cl and cd recalculation
        DATA{i, 2}{j, 2}(:, 8) = DATA{i, 2}{j, 2}(:, 6) .* cosd(DATA{i, 2}{j, 2}(:, 1)) - DATA{i, 2}{j, 2}(:, 5) .* sind(DATA{i, 2}{j, 2}(:, 1));
        DATA{i, 2}{j, 2}(:, 9) = DATA{i, 2}{j, 2}(:, 6) .* sind(DATA{i, 2}{j, 2}(:, 1)) + DATA{i, 2}{j, 2}(:, 5) .* cosd(DATA{i, 2}{j, 2}(:, 1));
    end
end

% Load References ---------------------------------------------------------
REF{1} = importdata('/home/lello/Desktop/Tesi/Spherocylinder/reference/Re10_clcdcm.dat');
REF{2} = importdata('/home/lello/Desktop/Tesi/Spherocylinder/reference/Re300_clcdcm.dat');

%% Plots
% Lift
for j = 1:1:size(DATA{1, 2}, 1)
    figure('Name', DATA{1, 2}{j, 1})
    Legend = cell(size(DATA, 1)+2, 1);
    plot(REF{j}(1:10, 1), REF{j}(1:10, 2), '-xr')
    Legend{1} = 'Fluent';
    hold on
    plot(REF{j}(11:end, 1), REF{j}(11:end, 2))
    Legend{2} = 'Zastawny - DNS';
    for i = 1:1:size(DATA, 1)
        plot(DATA{i, 2}{j, 2}(:, 1), DATA{i, 2}{j, 2}(:, 8), '-s')
        Legend{i+2} = DATA{i, 1};
    end
    legend(Legend)
    xlabel('$\alpha$ \ [rad]', 'FontSize', 14, 'Interpreter', 'Latex')
    ylabel('$c_{L}$ \ [-]', 'FontSize', 14, 'Interpreter', 'Latex')
end

% Drag
for j = 1:1:size(DATA{1, 2}, 1)
    figure('Name', DATA{1, 2}{j, 1})
    Legend = cell(size(DATA, 1)+2, 1);
    plot(REF{j}(1:10, 1), REF{j}(1:10, 3), '-xr')
    Legend{1} = 'Fluent';
    hold on
    plot(REF{j}(11:end, 1), REF{j}(11:end, 3))
    Legend{2} = 'Zastawny - DNS';
    for i = 1:1:size(DATA, 1)
        plot(DATA{i, 2}{j, 2}(:, 1), DATA{i, 2}{j, 2}(:, 9), '-s')
        Legend{i+2} = DATA{i, 1};
    end
    legend(Legend)
    xlabel('$\alpha$ \ [rad]', 'FontSize', 14, 'Interpreter', 'Latex')
    ylabel('$c_{D}$ \ [-]', 'FontSize', 14, 'Interpreter', 'Latex')
end

% Moment
for j = 1:1:size(DATA{1, 2}, 1)
    figure('Name', DATA{1, 2}{j, 1})
    Legend = cell(size(DATA, 1)+3, 1);
    plot(REF{j}(1:10, 1), REF{j}(1:10, 4), '-xr')
    Legend{1} = 'Fluent';
    hold on
    plot(REF{j}(11:end, 1), REF{j}(11:end, 4))
    Legend{2} = 'Zastawny - DNS';
    plot(REF{j}(1:10, 1), REF{j}(1:10, 4)/2, '-xr')
    Legend{3} = 'Fluent rescaled';
    for i = 1:1:size(DATA, 1)
        plot(DATA{i, 2}{j, 2}(:, 1), DATA{i, 2}{j, 2}(:, 4), '-s')
        Legend{i+3} = DATA{i, 1};
    end
    legend(Legend)
    xlabel('$\alpha$ \ [rad]', 'FontSize', 14, 'Interpreter', 'Latex')
    ylabel('$c_{M}$ \ [-]', 'FontSize', 14, 'Interpreter', 'Latex')
end
