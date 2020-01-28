function [cd] = SDC (Re)
% Implementation of the Standard Drag Curve from 'Bubbles, Drops and 
% Particles', R. Clift - 1978 (pag. 112)

cd = zeros(1, length(Re));
w = log10(Re);

for i = 1:1:length(Re)
   if Re(i) < 0.01
       cd(i) = 3/16 + 24/Re(i);
   elseif Re(i) >= 0.01 && Re(i) < 20
       cd(i) = 24/Re(i) * (1 + 0.1315*Re(i) ^(0.82 - 0.05*w(i)));
   elseif Re(i) >= 20 && Re(i) < 260
       cd(i) = 24/Re(i) * (1 + 0.1935*Re(i) ^(0.6305));
   elseif Re(i) >= 260 && Re(i) < 1500
       cd(i) = 10^(1.6435 - 1.1242*w(i) + 0.1558*w(i)^2);
   elseif Re(i) >= 1.5e3 && Re(i) < 1.2e4
       cd(i) = 10^(-2.4571 + 2.5558*w(i) - 0.9295*w(i)^2 + 0.1049*w(i)^3);
   elseif Re(i) >= 1.2e4 && Re(i) < 4.4e4
       cd(i) = 10^(-1.9181 + 0.6370*w(i) - 0.0636*w(i)^2);
   elseif Re(i) >= 4.4e4 && Re(i) < 3.38e5
       cd(i) = 10^(-4.3390 + 1.5809*w(i) - 0.1546*w(i)^2);
   elseif Re(i) >= 3.38e5 && Re(i) < 4e5
       cd(i) = 29.78 - 5.3*w(i);
   elseif Re(i) >= 4e5 && Re(i) < 1e6
       cd(i) = 0.1*w(i) - 0.49;
   elseif Re(i) >= 1e6
       cd(i) = 0.19 - 8e4/Re(i);
   else
       error('C''è qualcosa che non va!')
   end
end