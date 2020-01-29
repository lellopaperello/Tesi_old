function D = D_snow(T)
% Brandes model for the calculation of the equivalent volume diameter as
% function of the ground temperature
% D: equivalent volume diameter [ m ]
% T: ground temperature [ K ]

D0 = -0.3475;
D1 = 0.13;
exp = 0.1733;
T0 = -49.04;

D = D1*(T-T0).^exp + D0;