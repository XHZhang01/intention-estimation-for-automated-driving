% Calculate Degree of Conflict for a Set of Belief Mass Vectors
% Xuhui Zhang, 16.06.2022

function [v_deg_conf, belief_mass_vector_adapted] = conflict_detection_adaptation(belief_mass_vector)

% get the number of sources and the number of variables
num_sou = size(belief_mass_vector, 2);
num_var = size(belief_mass_vector, 1) - 1;

% initialize vector for degree of conflict and matrix for adapted belief mass matrix
v_deg_conf = zeros(1, num_sou);
belief_mass_vector_adapted = zeros(num_var + 1, num_sou);

% calculate degree of conflict for each source
for i = 1 : num_sou
    deg_conf = 0;
    % normalize the belief mass vector of each variable (only ratio matters)
    belief_mass_i = belief_mass_vector(1:num_var, i)/norm(belief_mass_vector(1:num_var, i));
    for j = 1 : num_sou
        % normalize the belief mass vector of each variable (only ratio matters)
        belief_mass_j = belief_mass_vector(1:num_var, j)/norm(belief_mass_vector(1:num_var, j));
        deg_conf = deg_conf + 0.5 * norm(belief_mass_i - belief_mass_j, 1)...
            * (1 - belief_mass_vector(end, i)) * (1 - belief_mass_vector(end, j));
    end
    deg_conf = deg_conf/(num_sou - 1);
    v_deg_conf(i) = deg_conf;
end

% adapt belief mass vector of each source based on degree of conflict
for i = 1 : num_sou
    belief_mass_vector_adapted(1 : num_var, i) = belief_mass_vector(1 : num_var, i) * (1 - v_deg_conf(i));
    belief_mass_vector_adapted(end, i) = 1 - sum(belief_mass_vector_adapted(1 : num_var, i));
end

end