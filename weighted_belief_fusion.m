% Weighted Fusion of Two Belief Mass Vectors (WBF)
% Xuhui Zhang, 09.05.2022

function [belief_mass_v] = weighted_belief_fusion (belief_mass_v1, belief_mass_v2)

% interpretation of inputs
% belief_mass_v1, belief_mass_v2: previous belief and current opinion or two beliefs (for fusion with WBF).
% interpretation of outputs
% belief_mass_v: the current belief or the fused result (after updated with WBF).

% number of references
num_ref = size(belief_mass_v1, 1) - 1;

% initialize belief mass vector after fusion
belief_mass_v = zeros(num_ref + 1, 1);

% fusion of two uncertainties
if belief_mass_v2(end) < 1e-4
    unc = 0;
else
    unc = (2 - belief_mass_v1(end) - belief_mass_v2(end))*belief_mass_v1(end)*belief_mass_v2(end)...
    /(belief_mass_v1(end) + belief_mass_v2(end) - 2*belief_mass_v1(end)*belief_mass_v2(end));
end

belief_mass_v(end) = unc;

% fusion of two belief masses for each reference
for i = 1:num_ref
    if belief_mass_v2(end) < 1e-4
        belief_mass_v(i) = belief_mass_v2(i);
    else
        belief_mass_v(i) = (belief_mass_v1(i)*(1 - belief_mass_v1(end))*belief_mass_v2(end) + belief_mass_v2(i)*(1 - belief_mass_v2(end))*belief_mass_v1(end))...
        /(belief_mass_v1(end) + belief_mass_v2(end) - 2*belief_mass_v1(end)*belief_mass_v2(end));
    end
end

end