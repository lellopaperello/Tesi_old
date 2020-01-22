function [cL, cD, cM] = cF(modello, varargin)
% Implementazione delle mappe di cF ricavate dalla CFD

switch modello
    case 'debug'
        cL = 0;
        cD = 1;
        cM = 0;
end