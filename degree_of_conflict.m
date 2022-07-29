% Calculate Degree of Conflict for a Set of Belief Mass Vectors
% Xuhui Zhang, 16.06.2022

function [v_deg_conf] = degree_of_conflict(belief_mass_vector)

% interpretation of inputs
% belief_mass_vector: a matrix containing opinions given by all sources at the same instant (for conflict detection).
% interpretation of outputs
% v_deg_conf: 3 x n matrix, 1st role is degree of conflict between two opinions, 2nd and 3rd roles are indices of corresponding opinions. 

% get the number of sources and the number of variables
num_sou = size(belief_mass_vector, 2);
num_var = size(belief_mass_vector, 1) - 1;

% special case: only one opinion, no degree of conflict
if num_sou == 1
    v_deg_conf = 0;
else
    % initialize vector for degree of conflict (one doc parameter for each pair of opinions)
    num_doc = 0.5 * num_sou * (num_sou - 1);
    v_deg_conf = zeros(3, num_doc);

    % compare ratios of each 2 belief mass vectors and calculate degree of conflict
    for i = 1 : (num_sou - 1)
        % normalize the belief mass vector of each variable (only ratio matters)
        if norm(belief_mass_vector(1:num_var, i), 1) ~= 0
            belief_mass_i = belief_mass_vector(1:num_var, i)/norm(belief_mass_vector(1:num_var, i), 1);
        else
            belief_mass_i = belief_mass_vector(1:num_var, i);
        end
        % get uncertainty of belief mass vector i
        mu_i = belief_mass_vector(end, i);
        for j = (i + 1) : num_sou
            if norm(belief_mass_vector(1:num_var, j), 1) ~= 0
                belief_mass_j = belief_mass_vector(1:num_var, j)/norm(belief_mass_vector(1:num_var, j), 1);
            else
                belief_mass_j = belief_mass_vector(1:num_var, j);
            end
            % get uncertainty of belief mass vector j
            mu_j = belief_mass_vector(end, j);
            % calculate doc of i and j with formula
            doc_ij = 0.5 * norm((belief_mass_i - belief_mass_j), 1) * sqrt((1 - mu_i) * (1 - mu_j));
            % index of current doc in doc vector
            index = 0.5 * (2 * (num_sou - 1) - i + 2) * (i - 1) + (j - i);
            v_deg_conf(1, index) = doc_ij;
            % store the 2 belief mass vectors related to this doc
            v_deg_conf(2, index) = i; v_deg_conf(3, index) = j;
        end
    end
end

end