% Uncertainty Multiplicator for Belief Mass Difference
% Xuhui Zhang, 12.05.2022

function [k_d] = multiplicator_difference(belief_mass_v)

% find references with the largest belief mass
% and the second largest belief mass
[max_1st, max_2nd] = find_max (belief_mass_v);

% factor k_d representing the difference between the largest belief mass
% and the second largest belief mass, varying from 0 (best) to 1 (worst)
k_d = max_2nd/max_1st;

end