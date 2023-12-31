function [epsilon_MeOH] = permittivity_MeOH(lambda)
% Dispersion relation of methanol.
%
% epsilon_MeOH : relative permittivity of methanol
%
% lambda : wavelength of light; [m]
%
% Refractive, dispersive and thermo-optic properties of twelve organic
% solvents in the visible and near-infrared
% Konstantinos Moutzouris, Myrtia Papamichael, Sokratis C. Betsis,
% Ilias Stavrakas, George Hloupis, Dimos Triantis
%
%% extended-Cauchy formula (450 - 1551 nm @ 27�C)
% warning('only valid for T at 27�C')
lambda = lambda .* 1e6;% m to �m

A0 = 1.745946239;
A1 = -0.005362181;
A2 = 0.004656355;
A3 = 0.00044714;
A4 = -0.000015087;

epsilon_MeOH = A0 + ...
    A1 .* lambda.^2 + ...
    A2 ./ lambda.^2 + ...
    A3 ./ lambda.^4 + ...
    A4 ./ lambda.^6;
end

