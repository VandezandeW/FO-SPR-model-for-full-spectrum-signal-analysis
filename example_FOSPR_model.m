%% reset workspace and add necessary folders to path
close all
clear variables
addpath(strcat(pwd,'\permittivities'));
addpath(strcat(pwd,'\FOSPR_model'));

%% inputs from optimization of the FO-SPR model
dAu = 50.580667130750172;% gold thickness [nm]

% variables of Drude-Lorentz equation for relative permittivity of gold
epsilon_infinity = 1.011906148555341e-08;
omega_p = 2.100064292172589e+03;
gamma_D = 9.359330281816534;
DELTA_epsilon = 4.258985430268263;
OMEGA_L = 7.698035767347802e+02;
GAMMA_L = 83.843316608507422;

% variables of the normal distribution for light ray angular distribution
mu_theta = 1.464411898097949;% [rad]
variance_theta = 6.436524802310575e-04;% [rad]

%% FO-SPR probe parameters
lambda = (550:1:900)';% [nm]
d_layers = [ ...
    dAu ...
    ];% [nm]
d_layers_2 = [ ...
    d_layers ...
    ];
d_layers_reference = d_layers;
L = 2 * 6;% [mm] times two because of back reflection
D = 400;% [µm]

% Numerical aperture (NA) is actually 0.39 for the FO-SPR optical fiber.
% However the bifurcated fiber has a NA of 0.22.
% NA is only implemented with analytically described ray angular
% distribution from the literature.
% NA = 0.22;

%% convert to SI-units
lambda_m = lambda .* 1e-9;% nm to m
d_layers_m = d_layers .* 1e-9;% nm to m
d_layers_m_2 = d_layers_2 .* 1e-9;% nm to m
d_layers_reference_m = d_layers_reference .* 1e-9;% nm to m
L_m = L * 1e-3; % mm to m
D_m = D * 1e-6; % µm to m

%% relative permittivities of layers
% relative permittivity of gold
permittivity_Au = @(lambda_m_var)permittivity_Au_Drude_Lorentz( ...
    lambda_m_var, epsilon_infinity, omega_p, gamma_D, DELTA_epsilon, ...
    OMEGA_L, GAMMA_L);

% relative permitivities of [glass gold sample(water)]
permittivities_layers = [ ...
    permittivity_SiO2(lambda_m), ...
    permittivity_Au(lambda_m), ...
    permittivity_1BuOH(lambda_m) ...
    ];
% relative permitivities of [glass gold air]
permittivities_layers_reference = [ ...
    permittivity_SiO2(lambda_m), ...
    permittivity_Au(lambda_m), ...
    permittivity_air(lambda_m) ...
    ];

%% angular distribution of the light rays in the FO-SPR probe
% Distribution acquired by optimization of the FO-SPR model to several
% samples (does not implement NA).
angular_pdf = @(theta)normpdf(theta, mu_theta, (variance_theta)^0.5);

% theta_critical = real(asin(((permittivities_layers(:, 1) - NA.^2).^0.5) ...
%     ./ permittivities_layers(:, 1).^0.5));

% Collimated light source focused on fiber end from literature* (most often
% used).
% angular_pdf = @(theta) ...
%     permittivities_layers(:, 1) .* sin(theta) .* cos(theta) ./ ...
%     (1 - permittivities_layers(:,1) .* cos(theta).^2).^2 .* ...
%     heaviside(theta - theta_critical);% No TIR below theta_critical

% Diffuse light source from literature*.
% angular_pdf = @(theta) ...
%     permittivities_layers(:, 1) .* sin(theta) .* cos(theta) .* ...
%     heaviside(theta - theta_critical);% No TIR below theta_critical

% *Fiber-optic evanescent field absorption sensor: A theoretical evaluation
% B. D. Gupta &C. D. Singh
% DOI: https://doi.org/10.1080/01468039408202251

%% reflectance of FO-SPR
R = FOSPR_model(lambda_m, ...
    permittivities_layers, ...
    permittivities_layers_reference, ...
    d_layers_m, ...
    d_layers_reference_m, ...
    L_m, D_m, ...
    angular_pdf);

figure
plot(lambda, R)
xlabel('wavelength (nm)');
ylabel('R_{rel}');