% Adapt Fused Belief Mass Vector Based on Degree of Conflict
% Xuhui Zhang, 20.06.2022

function [adapted_belief_mass] = adaptation_after_fusion(fused_belief_mass, v_deg_conf)

% Transfer part of all belief masses to uncertainty based on degree of conflict

% interpretation of inputs
% fused_belief_mass: the fused result of CBF at one instant before adaptation.
% v_deg_conf: 3 x n matrix, 1st role is degree of conflict between two opinions, 2nd and 3rd roles are indices of corresponding opinions. 
% interpretation of outputs
% adapted_belief_mass: the fused result after adaptation based on degree of conflict.

% calculate the product of all doc parameters
alpha = 1;
% prod_doc = 1;
num = size(v_deg_conf, 2);

for i = 1 : num
    alpha = alpha * (1 - v_deg_conf(1, i));
    % prod_doc = prod_doc * v_deg_conf(1, i);
end

% calculate the average of all num values
alpha = alpha^(1/num);
% prod_doc = prod_doc^(1/num);
% alpha = 1 - prod_doc;

% adapt fused belief mass vector based on alpha
adapted_belief_mass = fused_belief_mass;
adapted_belief_mass(1:(end - 1), 1) = alpha * fused_belief_mass(1:(end - 1), 1);
adapted_belief_mass(end, 1) = 1 - sum(adapted_belief_mass(1:(end - 1), 1));

end