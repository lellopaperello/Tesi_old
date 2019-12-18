close all; clear; clc %#ok<*NOPTS>

limit = 'Re' 
EXIT_ITER = 2000;
Re_lim = 2;

% Exact solution - cylinder (Clift)
cd_exact =@(Re) 24 .* (1 + 0.15.* Re.^0.687) ./ Re;

% Working dir: [ 'Cylinder', 'Sphere' ]
work_dir = 'Sphere'

% Import data
path = ['/home/lello/Desktop/Tesi/', work_dir, '/solution/polars'];
% Get a list of all files and folders in this folder.
files = dir(path);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

% Import polars from this folders (skip '.' and '..')
Re_struct = zeros(length(subFolders)-2, 2);
for k = 3 : length(subFolders)
  subFolders(k).Re = importdata([path '/' subFolders(k).name '/Re.dat']);
  subFolders(k).cd = importdata([path '/' subFolders(k).name '/cd.dat']);
  subFolders(k).conv = importdata([path '/' subFolders(k).name '/conv.dat']);
  if strcmp(work_dir, 'Cylinder') && strcmp(limit, 'conv')
    subFolders(k).err = norm(subFolders(k).cd(subFolders(k).conv < (EXIT_ITER-1)) - ...
                        cd_exact(subFolders(k).Re(subFolders(k).conv < (EXIT_ITER-1))) ) / ...
                        length(subFolders(k).Re(subFolders(k).conv < (EXIT_ITER-1)));
  elseif strcmp(work_dir, 'Cylinder') && strcmp(limit, 'Re')
    subFolders(k).err = norm(subFolders(k).cd(subFolders(k).Re > Re_lim) - ...
                        cd_exact(subFolders(k).Re(subFolders(k).Re > Re_lim)) ) / ...
                        length(subFolders(k).Re(subFolders(k).Re > Re_lim));
  elseif strcmp(work_dir, 'Sphere') && strcmp(limit, 'conv')
    subFolders(k).err = norm(subFolders(k).cd(subFolders(k).conv < (EXIT_ITER-1)) - ...
                        SDC(subFolders(k).Re(subFolders(k).conv < (EXIT_ITER-1))) ) / ...
                        length(subFolders(k).Re(subFolders(k).conv < (EXIT_ITER-1)));
  elseif strcmp(work_dir, 'Sphere') && strcmp(limit, 'Re')
    subFolders(k).err = norm(subFolders(k).cd(subFolders(k).Re > Re_lim) - ...
                        SDC(subFolders(k).Re(subFolders(k).Re > Re_lim)) ) / ...
                        length(subFolders(k).Re(subFolders(k).Re > Re_lim));      
  end
  Re_struct(k-2, 1) = min(subFolders(k).Re);
  Re_struct(k-2, 2) = max(subFolders(k).Re);
end

% Exact solution - cylinder (Clift)
cd_exact =@(Re) 24 .* (1 + 0.15.* Re.^0.687) ./ Re;

% Largest interval present, but finer
Re = logspace(log10(min(Re_struct(:, 1))), log10(max(Re_struct(:, 2))), 1000);

%% Plots

figure('Name', 'Drag curves')
Legend = cell(length(subFolders)-1, 1);

% Reference
if strcmp(work_dir, 'Cylinder')
    semilogx(Re, cd_exact(Re))
    Legend{1} = 'exact - Clift';
    hold on
elseif strcmp(work_dir, 'Sphere')
    semilogx(Re, SDC(Re))
    Legend{1} = 'Standard Drag Curve';
    hold on
end

% CFD
for k = 3 : length(subFolders)
    semilogx(subFolders(k).Re, subFolders(k).cd)
    Legend{k-1} = regexprep(subFolders(k).name, '_(.*)', ' - $1');
%     Legend{k-1} = regexprep(subFolders(k).name, '_(.*)', '_{$1}');
%     Legend{k-1} = ['$ \mathrm{' regexprep(subFolders(k).name, '_(.*)', '_{$1}') '} $'];
end

% legend(Legend, 'FontSize', 12)
legend(Legend, 'FontSize', 14, 'Interpreter', 'Latex')

xlabel('$Re$ \ [-]', 'FontSize', 14, 'Interpreter', 'Latex')
ylabel('$c_{D}$ \ [-]', 'FontSize', 14, 'Interpreter', 'Latex')


%% Errors

figure('Name', 'Error extimation')
hold on
Legend = cell(length(subFolders)-2, 1);

for k = 3 : length(subFolders)
    scatter(k, subFolders(k).err, 'filled')
    Legend{k-2} = regexprep(subFolders(k).name, '_(.*)', ' - $1');
%     Legend{k-1} = regexprep(subFolders(k).name, '_(.*)', '_{$1}');
%     Legend{k-1} = ['$ \mathrm{' regexprep(subFolders(k).name, '_(.*)', '_{$1}') '} $'];
end

% legend(Legend, 'FontSize', 12)
legend(Legend, 'FontSize', 14, 'Interpreter', 'Latex')

ylabel('$ \frac{|| c_{D, ex} - c_{D} ||}{\mathrm{lenght}(c_D)}$ \ [-]', ...
       'FontSize', 14, 'Interpreter', 'Latex')



% subFolders(k).err = 0;
% subFolders(k).err = norm(subFolders(k).cd(subFolders(k).conv<(EXIT_ITER-1)) - ...
%                     cd_exact(subFolders(k).Re(subFolders(k).conv<(EXIT_ITER-1))) ) / ...
%                     length(subFolders(k).Re(subFolders(k).conv<(EXIT_ITER-1)));













