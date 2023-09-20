function [ epsilon_clad ] = permittivity_clad( lambda )
% input lambda is wavelength in m

%% base on thorlabs data
%http://www.thorlabs.de/newgrouppage9.cfm?objectgroup_id=6845
% 436 nm: 1.467287
% 589.3 nm: 1.458965
% 1020 nm: 1.450703

lambda = lambda .* 1e6; % wavelength: m to µm
% 
A0 = 1.927393801542563;
A1 = 0.002076629715773;
A2 = 0.009323722026072;

epsilon_clad = A0 + A1 .* lambda.^2 + A2 .* lambda.^-2;

%http://www.researchgate.net/publication/5651689_Refractive_index_dispersion_and_related_properties_in_fluorine_doped_silica
% % 2%F
% A1 = 0.67744;
% l1 = 0.06135;
% A2 = 0.40101;
% l2 = 0.12030;
% A3 = 0.87193;
% l3 = 9.8563;
% 
% % 1%F
% % A1 = 0.69325;
% % l1 = 0.06724;
% % A2 = 0.39720;
% % l2 = 0.11714;
% % A3 = 0.86008;
% % l3 = 9.7761;
% % 
% epsilon_clad = 1 + A1 .* lambda.^2 ./(lambda.^2 - l1^2) + ...
%     A2 .* lambda.^2 ./(lambda.^2 - l2^2) + ...
%     A3 .* lambda.^2 ./(lambda.^2 - l3^2);
% 
% epsilon_clad2 = epsilon_clad .*0.22./0.39;
% lambda = lambda .* 1e3;
% plot(lambda, epsilon_clad, lambda, epsilon_clad1, lambda, epsilon_clad2)
% legend('epsilon_clad','epsilon_clad1','epsilon_clad2');
end

