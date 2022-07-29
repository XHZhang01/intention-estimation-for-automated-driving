% Weighted Belief Fusion
% Xuhui Zhang, 09.06.2022

function [fused_belief_mass_vector] = cbf_operator(belief_mass_vector)

num_time = size(belief_mass_vector, 2);
num_var = size(belief_mass_vector, 1) - 1;

% initialize belief mass vector before fusion
fused_belief_mass_vector = zeros(num_var + 1, num_time + 1);
% fused_belief_mass_vector(end, 1) = 0.9;
% fused_belief_mass_vector(1:num_var, 1) = 0.1/num_var;
fused_belief_mass_vector(:, 1) = [0.5; 0.1; 0.4];

for i = 1 : num_time
    mu = fused_belief_mass_vector(end, i)*belief_mass_vector(end, i)/...
        (fused_belief_mass_vector(end, i) + belief_mass_vector(end, i) - fused_belief_mass_vector(end, i)*belief_mass_vector(end, i));
    fused_belief_mass_vector(end, i + 1) = mu;
    
    for j = 1 : num_var
        mxj = (fused_belief_mass_vector(j, i)*belief_mass_vector(end, i) + belief_mass_vector(j, i)*fused_belief_mass_vector(end, i))/...
            (fused_belief_mass_vector(end, i) + belief_mass_vector(end, i) - fused_belief_mass_vector(end, i)*belief_mass_vector(end, i));
        fused_belief_mass_vector(j, i + 1) = mxj;
    end
end

end