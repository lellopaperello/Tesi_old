% Implementation of the parameters calculated for different geometries
r = geom_param(1);
l = geom_param(2);
r_cyl = geom_param(3);
h_cyl = geom_param(4);
r_sc = geom_param(5);
h_sc = geom_param(6);

D_tube = geom_param(end);

K2 =@(phi) 10^(1.8148 * ((-log10(phi))^0.5743));

% Sphere ------------------------------------------------------------------
sphere.deq = 2*r;
sphere.phi = 1;
sphere.phi_perp = 1;
sphere.phi_par = 1;
sphere.psi = 1;
sphere.beta = 1;
sphere.K1 = 1 - 4.5 * r/D_tube;
sphere.K2 = 1;
sphere.Ar = 1;

% Cube --------------------------------------------------------------------
cube.deq = l;
cube.phi = 0.806;
cube.phi_perp = 1.209;
cube.phi_par = 0.7;
cube.psi = 0.715;
cube.beta = 1;
cube.K1 = 0.929 - 2.792 * l/D_tube;
cube.K2 = 2.9228;
cube.Ar = 0.637;

% Cylinder ----------------------------------------------------------------
a = h_cyl / r_cyl; % height to radius ratio 

cylinder.deq = 1.817 * (r_cyl^2 * h_cyl)^(1/3);
cylinder.phi = 1.651 * (r_cyl * h_cyl^2)^(1/3) / (r_cyl + h_cyl);
cylinder.psi = cylinder.phi / X_cyl(r_cyl, h_cyl);
cylinder.K2 = K2(cylinder.phi);
if a > 1
    cylinder.phi_perp = 0.826 * a^(2/3);
    cylinder.phi_par = 2.593 * (r_cyl * h_cyl^2)^(1/3) / ((pi - 2)*h_cyl + pi*r_cyl);
    cylinder.beta = sqrt(1/a);
    cylinder.K1 = (0.367 * a^(-1/3) + 0.667/sqrt(cylinder.phi))^(-1) ...
                - 4.089 * (r_cyl^2 * h_cyl)^(1/3) / D_tube;
    cylinder.Ar = 1;
else
    cylinder.phi_perp = 1.296 * a^(-1/3);
    cylinder.phi_par = 2.593 * (r_cyl * h_cyl^2)^(1/3) / ((pi - 2)*r_cyl + pi/2 * h_cyl);
    cylinder.beta = sqrt(a);
    cylinder.K1 = (0.293 * a^(1/6) + 0.667/sqrt(cylinder.phi))^(-1) ...
                - 4.089 * (r_cyl^2 * h_cyl)^(1/3) / D_tube;
    cylinder.Ar = 1.273 * r_cyl*h_cyl / (r_cyl^2 + h_cyl^2/4);
end

% Spherocylinder ----------------------------------------------------------
a = h_sc / r_sc;
root = (0.75*a + 1)^(1/3);
spherocylinder.deq = 2*r_sc * root;
spherocylinder.phi = root^2 / (1 + a/2);
spherocylinder.phi_perp = root^2;
spherocylinder.phi_par = root^2 / ((1 - 2/pi)*a + 1);
spherocylinder.psi = spherocylinder.phi * sqrt(2/pi * a + 1) / (a/pi + 1);
spherocylinder.beta = sqrt(2*r_sc / (h_sc + 2*r_sc));
spherocylinder.K1 = (0.333/root + 0.667/sqrt(spherocylinder.phi))^(-1) ...
                  - 4.5 * r_sc*root/D_tube;
spherocylinder.K2 = K2(spherocylinder.phi);
spherocylinder.Ar = 1;