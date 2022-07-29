% Uncertainty Multiplicator for Belief Mass Switching
% Xuhui Zhang, 12.05.2022

function [k_c] = multiplicator_change(belief_mass_measurement, N_t, i)

% get belief mass from the past N time instants
belief_mass = belief_mass_measurement(:, (i - N_t + 1):i);

% find the numebr of references
num_ref = size(belief_mass, 1);

[belief_mass_marked] = mark_max (belief_mass);

% initialize difference of marked belief mass vectors between two neighboring time instants
belief_mass_marked_diff = zeros(num_ref, N_t - 1);

% initialize the number of changes (reference with the largest belief mass),
% varying from 0 to N+1
num_change = 0;

for i = 1 : (N_t - 1)
    belief_mass_marked_diff(:, i) = belief_mass_marked(:, i+1) - belief_mass_marked(:, i);
    
    % marked vector not a zeros vector means reference with largest belief mass changes  
    if norm(belief_mass_marked_diff(:, i)) > 0
        num_change = num_change + 1;
    end
end

% factor k_s representing the change of reference with the largest belief mass,
% varying from 0 (best) to 1 (worst)

k_c = num_change/(N_t - 1);

end