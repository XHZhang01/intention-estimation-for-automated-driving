% Uncertainty Multiplicator for Belief Distribution
% Xuhui Zhang, 12.05.2022

function [k_c_f, k_c_a] = multiplicator_change_freq_ampl(belief_mass_measurement, N_t, k, i)

% This function checks the perturbation of belief distribution within a given window size and gives factors to set uncertainty.

% interpretation of inputs
% belief_mass_measurement: contains belief at all time instants (perturbation detection).
% N_t: the given window size.
% k: tuning parameter for setting uncertainty based on perturbation.
% i: the current time instant.
% interpretation of outputs
% k_c_f: factor based on change of reference with the largest belief in the past N time instants
% k_c_a: factor based on change of reference with belief distribution in the past N time instants (used in simulations of the paper)

% get belief mass from the past N time instants
belief_mass = belief_mass_measurement(:, (i - N_t + 1):i);

% calculate the difference between the largest belief mass 
% and the second largest belief mass
[diff] = diff_max_1st_2nd(belief_mass);

% find the numebr of references
num_ref = size(belief_mass, 1);

% find the largest belief mass of each opinion
[belief_mass_marked] = mark_max (belief_mass);

% initialize difference of marked belief mass vectors between two neighboring time instants
belief_mass_marked_diff = zeros(num_ref, N_t - 1);

% initialize the number of changes (reference with the largest belief mass),
% varying from 0 to N+1
num_change = 0;

% initialize the sum of change amplitude
amp_change = 0;

for i = 1 : (N_t - 1)
    
    % calculate the sum of belief mass vector change
    amp_change = amp_change + norm(belief_mass(:, i + 1) - belief_mass(:, i), 1);
    % abs_diff = abs(belief_mass(:, i + 1) - belief_mass(:, i));
    % [max_diff_1st, max_diff_2nd] = find_max (abs_diff);
    % amp_change = amp_change + max_diff_1st + max_diff_2nd;
            
    belief_mass_marked_diff(:, i) = belief_mass_marked(:, i+1) - belief_mass_marked(:, i);
    
    % marked vector not a zeros vector means reference with largest belief mass changes  
    if norm(belief_mass_marked_diff(:, i)) > 0
        num_change = num_change + 1;
    end
end

% factor k_s representing the change of reference with the largest belief mass,
% varying from 0 (best) to 1 (worst)

k_c_f = num_change/(N_t - 1);

% several formulas to set uncertainty based on perturbation
% k_c_a = amp_change/(2*(N_t - 1));
% k_c_a = 1/(1.2^(2*(N_t - 1)) - 1) * (1.2^(amp_change) - 1);
% k_c_a = -exp(-0.01*amp_change) + 1;
% k_c_a = tanh(0.15*k*amp_change);
k_c_a = tanh(0.02*amp_change);

end