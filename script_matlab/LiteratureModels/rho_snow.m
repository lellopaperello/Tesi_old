function rho = rho_snow(D, model)

switch model
    case 'Brandes'
    % Brandes et al. 2007 "A Statistical and Physical Description of 
    % Hydrometeor Distributions in Colorado Snowstorms Using a Video
    % Disdrometer"
    
    D = D*1e3;
    rho = 0.178 * D.^(-0.922);
    rho = rho*1e3;
    otherwise
        error('Model not implemented. Implemented models are: ''Brandes''')
end