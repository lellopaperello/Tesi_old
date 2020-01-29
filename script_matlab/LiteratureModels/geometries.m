% Implementation of the parameters calculated for different geometries
K2 =@(phi) 10^(1.8148 * ((-log10(phi))^0.5743));

% Sphere ------------------------------------------------------------------
sphere.deq = 2*r;
sphere.phi = 1;
sphere.phi_perp = 1;
sphere.phi_par = 1;
sphere.psi = 1;
sphere.beta = 1;
sphere.K1 = 1 - 4.5 * r/D;
sphere.K2 = 1;

% Cube --------------------------------------------------------------------
cube.deq = l;
cube.phi = 0.806;
cube.phi_perp = 1.209;
cube.phi_par = 0.7;
cube.psi = 0.715;
cube.beta = 1;
cube.K1 = 0.929 - 2.792 * l/D;
cube.K2 = 2.9228;

% Cylinder ----------------------------------------------------------------
a = h / r; % height to radius ratio 
% if a < 1 error('Not implemented yet!!'), end
    
cylinder.deq = 1.817 * (r^2 * h)^(1/3);
cylinder.phi = 1.651 * (r * h^2)^(1/3) / (r + h);
cylinder.phi_perp = 0.826 * a^(2/3);
cylinder.phi_par = 2.593 * (r * h^2)^(1/3) / ((pi - 2)*h + pi*r);
cylinder.psi = cylinder.phi / X_cyl(r, h);
cylinder.beta = sqrt(1/a);
cylinder.K1 = (0.367 * a^(-1/3) + 0.667/sqrt(cylinder.phi))^(-1) ...
            - 4.089 * (r^2 * h)^(1/3) / D;
cylinder.K2 = K2(cylinder.phi);

% Spherocylinder ----------------------------------------------------------
a = h / r;
root = (0.75*a + 1)^(1/3);
spherocylinder.deq = 2*r * root;
spherocylinder.phi = root^2 / (1 + a/2);
spherocylinder.phi_perp = root^2;
spherocylinder.phi_par = root^2 / ((1 - 2/pi)*a + 1);
spherocylinder.psi = spherocylinder.phi * sqrt(2/pi * a + 1) / (a/pi + 1);
spherocylinder.beta = sqrt(2*r / (h + 2*r));
spherocylinder.K1 = (0.333/root + 0.667/sqrt(spherocylinder.phi))^(-1) ...
                  - 4.5 * r*root/D;
spherocylinder.K2 = K2(spherocylinder.phi);