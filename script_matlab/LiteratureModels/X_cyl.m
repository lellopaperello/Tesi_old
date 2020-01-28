function [X] = X_cyl (r, h)
% Calculation of the circularity of a generic Cylinder with basis radius r
% and height h

th = atan(pi/2 * r/h);
Amax = 2*r*h * cos(th) + pi*r^2 * sin(th);

X = Pmp_cyl(h/r) / (2 * sqrt(pi * Amax));