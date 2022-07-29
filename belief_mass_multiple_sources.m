% Generate Belief Mass Vectors of Multiple Sources
% Xuhui Zhang, 16.06.2022

function [belief_mass_cell] = belief_mass_multiple_sources(belief_mass_measurement, num_sou)

% get the number of time instants
num_time = size(belief_mass_measurement, 2);

% get the number of variables
num_var = size(belief_mass_measurement, 1) - 1;


% initialize belief mass cell
belief_mass_cell = cell(1, num_time);

for i = 1 : num_time
    belief_mass_cell{i} = repmat(belief_mass_measurement(:, i), 1, num_sou);
end

end