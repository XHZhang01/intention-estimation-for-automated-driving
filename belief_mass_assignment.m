% Online Update of Belief for Each Reference
% Xuhui Zhang, 09.05.2022

function [belief_mass_v] = belief_mass_assignment(num_ref, y_all, y_measured, std_dev_input_v, std_dev_sensor_v)

% initialize belief mass vector
belief_mass_v = zeros(num_ref, 1);

for i = 1: num_ref
    % set each model-given value as mu and corresponding measured data quality
    % as sigma of normal distribution
    mu = y_all(i);
    sigma = (std_dev_input_v(i) + std_dev_sensor_v(i))/2;
    % assign belief mass to each referenc based on the distance between it
    % and measured value
    belief_mass_v(i) = pdf('Normal',y_measured,mu,sigma);
end

% renormalize belief mass of each reference
belief_mass_v = belief_mass_v/sum(belief_mass_v);

end