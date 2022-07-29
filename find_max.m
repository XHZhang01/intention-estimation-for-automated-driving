% Find the Largest 2 Component in Belief Mass Vector
% Xuhui Zhang, 12.05.2022

function [max_1st, max_2nd] = find_max (belief_mass_v)

belief_mass_v = sort(belief_mass_v);

max_1st = belief_mass_v(end);

max_2nd = belief_mass_v(end - 1);

end