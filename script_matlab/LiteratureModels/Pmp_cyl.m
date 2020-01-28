function [P_max, x_max] = Pmp_cyl (a)
% Maximum Projection perimeter of a cylinder
% a = h / r ~ height - radius ratio

% Rotation of the cylinder from 0 to pi/2
x = 0:0.001:pi/2;
P = zeros(1, length(x));
    
for j = 1:1:length(x)
    P(j) = fun (x(j), a);
end
    
[P_max, I] = max(P);
x_max = x(I);

function P = fun (x, a)
    r = 1;
    [~, E] = ellipke(1 - sin(x)^2);

    P = 2 * (r*a * cos(x) + 2*r * E);
end
end