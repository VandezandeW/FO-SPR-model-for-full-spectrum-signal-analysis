function [P] = reflectance_power(alpha, lambda, ...
    epsilon, L, D, N, d, ...
    angular_pdf)
% P: power of the reflected light.
%
% alpha [rad]: reflection angle in the first, semi-infinite layer;
% lambda [m]:  light wavelength;
% epsilon : permitivities of the different layers;
% L [m]: total length of optical fiber where SPR takes place,
%	back reflection included, e.g., 6 mm probelength with back reflection:
%	L = 12 mm;
% D [m]: diameter of optical fiber where SPR takes place;
% N: number of layers;
% d [m]: layer thicknesses of from second to second last layer;
% angular_pdf: function handle of the angular probability density function.

%% angular power distribution (eq. 3.18)
P_alpha = angular_pdf(alpha);

% If there are no rays, there is no power.
if ~any(P_alpha)
    P = zeros(size(P_alpha));
else
    %% Fresnel coefficients of reflection (eq. 3.1-3.8, 3.14)
    [ r_s, r_p ] = reflection_coefficients_of_multilayer(lambda, ...
        alpha, epsilon, N, d);
    
    %% reflectances of s- and p-polarized light (eq. 3.14)
    R_s = abs(r_s).^2;
    R_p = abs(r_p).^2;
    
    %% number of reflections (eq. 3.17)
    % (Note that L is the total length of the FO-SPR probe. Hence, the
    % length needs to be doubled before it is given to this function for a
    % back-reflecting FO-SPR sensor.)
    N_refl = L ./ (D .* tan(alpha));
    
    %% reflectances of s- and p-polarized light (eq. 3.18)
    R_s = R_s.^N_refl;
    R_p = R_p.^N_refl;
        
    % The reflectance of unpolarized light is the average of two
    % perpendicularly polarized light beams.
    R = (R_p + R_s) ./ 2;
    
    % power of the reflected light 
    P = R .* P_alpha;
end
end