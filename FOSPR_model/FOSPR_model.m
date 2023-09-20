function [R] = FOSPR_model( ...
    lambda, ...
    permittivities_layers, ...
    permittivities_layers_reference, ...
    d_layers, d_layers_reference, L, D, ...
    angular_pdf)
% This model assumes that the FO-SPR sensing surface is made out of
% isotropic layers where the first and last 'layers' are semi-infinite
% volumes. Each layer is indexed, starting from 1.
%
% R : relative reflectance
%
% lambda : light wavelengths; [m]
% permittivities_layers : permitivities of the different layers
% permittivities_layers_reference : permitivities of the different layers
%    for referencing. Usually the sample is replaced with air.
% NA : the numerical aperture of the fiber optic system
% d_layers : layer thicknesses of from second to second last layer; [m]
% d_layers_reference : thicknesses of the referencing layers of from second
%    to second last layer. Usually the same as d_layers; [m]
% L : length of optical fiber where SPR takes place, backreflection
%    included, e.g., 6 mm probelength with backreflection: L = 12 mm; [m]
% D : diameter of optical fiber where SPR takes place; [m]
% angular_pdf: function handle of the angular probability density function

%% reflectance of FO-SPR sensor (eq. 3.21)
P = angular_power_integration(d_layers, ...
    permittivities_layers);% reflected light power of sample
P_reference = angular_power_integration(d_layers_reference, ...
    permittivities_layers_reference);% reflected light power of reference
R = P ./ P_reference;% relative reflectance

    function [ P ] = angular_power_integration(d_layers, ...
            permittivities_layers)
        N = size(permittivities_layers, 2);
        %% integration of the reflection power over all angles
        number_values = 100;
        theta_min = fzero(@(x) min(1e-9 - angular_pdf(x), [], ...
            1), 0.1);
        theta = theta_min:(pi/2 - theta_min) / number_values:pi/2;
        
        F_trapz = reflectance_power(...
            theta, lambda, ...
            permittivities_layers, L, D, N, d_layers, ...
            angular_pdf);
        [P] = trapz(theta, F_trapz, 2);
    end
end
