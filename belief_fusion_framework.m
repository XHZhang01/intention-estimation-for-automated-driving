% Framework for Belief Fusion (Multi-Source Information Fusion, Conflict Detection and Handling and Belief Distribution Update)
% Xuhui Zhang, 16.06.2022

function [belief_mass_development] = belief_fusion_framework (belief_mass_cell)

% interpretation of inputs
% belief_mass_cell: contains belief at each time instant (for fusion and update in this framework).
% interpretation of outputs
% belief_mass_development: belief development after processing with the framework.

% get the number of time instants
num_time = size(belief_mass_cell, 2);

% get the number of variables
num_var = size(belief_mass_cell{1}, 1) - 1;

% initialize matrix for storage of belief mass development along time
belief_mass_development = zeros(num_var + 1, num_time + 1);

% inilialize belief mass vector before fusion
belief_mass_initial = zeros(num_var + 1, 1);
belief_mass_initial(end) = 0.9;
belief_mass_initial(1 : num_var) = 0.1/num_var;
belief_mass_development(:, 1) = belief_mass_initial;

for i = 1 : num_time
    % get belief mass vectors of all sources at current time instant
    belief_mass_current = belief_mass_cell{i};
    
    %% option 1: calculate doc for each belief mass vector (avergae) and adapt it before fusion
%     % adapt each belief mass vector according to conflict
%     [v_deg_conf_current, belief_mass_current_adapted] = conflict_detection_adaptation(belief_mass_current);
%     % fuse all belief mass vectors at current time instant
%     [fused_belief_mass_current] = sensor_fusion (belief_mass_current_adapted);
%     
%     % update belief mass vector with fused belief mass vector after fusion (with WBF)
%     [updated_belief_mass] = weighted_belief_fusion (belief_mass_development(:, i), fused_belief_mass_current);
%     belief_mass_development(:, i + 1) = updated_belief_mass;
    
    %% option 2: calculate doc for each pair of belief mass vectors (product) and adapt fused result
    % compare belief mass vectors and get doc vector
    [v_deg_conf] = degree_of_conflict(belief_mass_current);
    % fuse all belief mass vectors at current time instant
    [fused_belief_mass_current] = sensor_fusion (belief_mass_current);
    % adapt fused result based on doc vector
    [adapted_belief_mass_current] = adaptation_after_fusion(fused_belief_mass_current, v_deg_conf);
    
    % update belief mass vector with fused belief mass vector after fusion (with WBF)
    [updated_belief_mass] = weighted_belief_fusion (belief_mass_development(:, i), adapted_belief_mass_current);
    belief_mass_development(:, i + 1) = updated_belief_mass;
end

end