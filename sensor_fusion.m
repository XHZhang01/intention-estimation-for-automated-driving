% Multiple Source Sensor Fusion (with CBF)
% Xuhui Zhang, 16.06.2022

function [fused_belief_mass] = sensor_fusion (belief_mass_vector)

% interpretation of inputs
% belief_mass_vector: a matrix containing opinions given by all sources at the same instant (for fusion with CBF).
% interpretation of outputs
% fused_belief_mass: fused result of CBF

% get the number of sources
num_sou = size(belief_mass_vector, 2);
% get the number of possible trajectories
num_var = size(belief_mass_vector, 1) - 1;

% choose the first belief mass
fused_belief_mass = belief_mass_vector(:, 1);

if num_sou == 1
    fused_belief_mass = belief_mass_vector;
else
    % fusion of two beliefs each time with CBF
    for i = 2 : num_sou
         %if belief_mass_vector(end, i) ~= 1
             % expression of uncertainty in CBF (formulas see paper)
             mu = fused_belief_mass(end) * belief_mass_vector(end, i)/...
                 (fused_belief_mass(end) + belief_mass_vector(end, i) - fused_belief_mass(end) * belief_mass_vector(end, i));
    
             % expression of each belief mass in CBF (formulas see paper)
             for j = 1 : num_var
                 mxj = (fused_belief_mass(j) * belief_mass_vector(end, i) + belief_mass_vector(j, i)*fused_belief_mass(end))/...
                     (fused_belief_mass(end) + belief_mass_vector(end, i) - fused_belief_mass(end) * belief_mass_vector(end, i));
                 fused_belief_mass(j) = mxj;
             end
     
             % set the fused uncertainty as the last component of the fused result
             fused_belief_mass(end) = mu;
         %end
    end
end