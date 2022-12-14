% Test with Multiple Sensors of Similar or Different Qualities in Crossroad Scenario
% Xuhui Zhang, 28.06.2022

function [belief_mass_development] = multiple_sensors (index_real_reference, std_dev_input_m, std_dev_sensor_m)

% This simulation is based on the crossroad scenario. 
% Three possible trajectories: "turning left", "straight" and "turning right".

% interpretation of inputs
% index_real_reference: {1(left), 2(straight), 3(right)}, the real trajectory TV is following and measured states are generated based on this
% std_dev_input_m and std_dev_sensor_m: n x 3 vector, n is the number of sources and 3 means three possible trajectories.
% interpretation of outputs
% belief_mass_development: belief development after processing with the framework.

% get the number of sensors
number_sensors = size(std_dev_input_m, 1);

for i = 1 : number_sensors
    % get standard deviation of input and standard deviation of sensor of current sensor
    std_dev_input_v = std_dev_input_m(i, :)';
    std_dev_sensor_v = std_dev_sensor_m(i, :)';
    % reference tracking for turning left, going straight and turning right
    [results_storage] = multiple_references_crossroad (std_dev_input_v, std_dev_sensor_v);
    % generate belief mass vector based on measurement
    [storage_belief_mass_measurement_4D((4 * (i - 1) + 1) : (4 * i), :), storage_belief_mass_measurement_y((4 * (i - 1) + 1) : (4 * i), :), storage_belief_mass_measurement_vy((4 * (i - 1) + 1) : (4 * i), :)] ...
      = belief_mass_measurement_generation (results_storage, index_real_reference, std_dev_input_v, std_dev_sensor_v);
end

% get the number of time instants
number_time = size(storage_belief_mass_measurement_y, 2);
% initialize belief mass series based on measurement, which can be used for fusion
belief_mass_measurement_4D = {1, number_time};
belief_mass_measurement_y = {1, number_time};
belief_mass_measurement_vy = {1, number_time};
belief_mass_measurement = {1, number_time};

for i = 1 : number_time
    % belief_mass_measurement_4D is based on measured full states [x, vx, y, vy]
    belief_mass_measurement_4D{1, i} = storage_belief_mass_measurement_4D(1 : 4, i);
    % belief_mass_measurement_y is based on measured y position
    belief_mass_measurement_y{1, i} = storage_belief_mass_measurement_y(1 : 4, i);
    % belief_mass_measurement_y is based on measured velocity in y direction
    belief_mass_measurement_vy{1, i} = storage_belief_mass_measurement_vy(1 : 4, i);
    % belief_mass_measurement contains one opinion based y position and the other based on measured velocity in y direction (later fusion with CBF)
    belief_mass_measurement{1, i} = [storage_belief_mass_measurement_y(1 : 4, i) storage_belief_mass_measurement_vy(1 : 4, i)];
    % Put opinions generated by all sources in the same cell for later fusion with CBF
    for j = 2 : number_sensors
        belief_mass_measurement_4D{1, i} = [belief_mass_measurement_4D{1, i} storage_belief_mass_measurement_4D((4 * (j - 1) + 1) : (4 * j), i)];
        belief_mass_measurement_y{1, i} = [belief_mass_measurement_y{1, i} storage_belief_mass_measurement_y((4 * (j - 1) + 1) : (4 * j), i)];
        belief_mass_measurement_vy{1, i} = [belief_mass_measurement_vy{1, i} storage_belief_mass_measurement_vy((4 * (j - 1) + 1) : (4 * j), i)];
        belief_mass_measurement{1, i} = [belief_mass_measurement{1, i} storage_belief_mass_measurement_y((4 * (j - 1) + 1) : (4 * j), i) storage_belief_mass_measurement_vy((4 * (j - 1) + 1) : (4 * j), i)];
    end
end

% fusion and updating (with CBF, conflict handling and WBF)
[belief_mass_development] = belief_fusion_framework (belief_mass_measurement_4D);

end