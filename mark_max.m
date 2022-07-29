% Mark the Largest Component in Belief Mass Vector
% Xuhui Zhang, 12.05.2022

function [belief_mass_marked] = mark_max (belief_mass)

% find the number of time instants
N_t = size(belief_mass, 2);

% find the numebr of references
num_ref = size(belief_mass, 1);

belief_mass_marked = zeros(num_ref, N_t);

for i = 1 : N_t
    [~, max_index] = max(belief_mass(:,i));
    belief_mass_marked(max_index, i) = 1;
end

end