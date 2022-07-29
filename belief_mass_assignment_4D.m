% Assign Belief Mass with Normal PDF to Each Reference According to Difference in 4D Space
% Xuhui Zhang, 27.06.2022

function [belief_mass_v] = belief_mass_assignment_4D(num_ref, x_all, x_measured, vx_all, vx_measured, y_all, y_measured, vy_all, vy_measured, std_dev_input_v, std_dev_sensor_v)

% interpretation of inputs
% num_ref: number of all possible trajectories (three for crossroad scenario).
% x_all, vx_all, y_all, vy_all: contains states of all trajectories at all time instant.
% x_measured, vx_measured, y_measured, vy_measured: contains measured states at all time instant.
% interpretation of outputs
% belief_mass_v: belief distribution based on distances to the measured state (without uncertainty).

% initialize belief mass vector
belief_mass_v = zeros(num_ref, 1);

for i = 1: num_ref
    % set each model-given value as mu and corresponding measured data quality
    % as sigma of normal distribution
    % mu = [x_all(i) vx_all(i) y_all(i) vy_all(i)];
    mu = [x_measured vx_measured y_measured(i) vy_measured];
    sigma = std_dev_sensor_v(i) * eye(4, 4);
    % assign belief mass to each reference based on the distance between it
    % and measured value
    belief_mass_v(i) = mvnpdf([x_measured vx_measured y_measured vy_measured], mu, sigma);
end

% renormalize belief mass of each reference
belief_mass_v = belief_mass_v/sum(belief_mass_v);

end