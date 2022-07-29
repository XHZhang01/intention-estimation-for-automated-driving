% Belief Generation Based on Measured States
% Xuhui Zhang, 09.05.2022

function [belief_mass_measurement_4D, belief_mass_measurement_y, belief_mass_measurement_vy] = belief_mass_measurement_generation (results_storage, index_real_reference, std_dev_input_v, std_dev_sensor_v)

% interpretation of inputs
% results_storage: reference tracking results of the scenario and contains states of all possible trajectories and measured state.
% std_dev_input_v and std_dev_sensor_v: 1 x 3 vector, 1 means one source.
% interpretation of outputs
% belief_mass_measurement_4D: belief at all instants based on measured full states.
% belief_mass_measurement_y: belief at all instants based on measured y position.
% belief_mass_measurement_y: belief at all instants based on measured velocity in y direction.

% number of references
number_reference = size(results_storage, 1);

% number of time instants
number_time = size(results_storage{1, 5}, 2);

% initialize belief mass for each reference and uncertainty
belief_mass_vector = zeros(number_reference + 1, 1);

uncertainty_ini = 0.8; % initial value of uncertainty
belief_mass_reference = (1 - uncertainty_ini)/number_reference;

belief_mass_vector(1:number_reference) = belief_mass_reference;
belief_mass_vector(end) = uncertainty_ini;

uncertainty_min = 0.2; % minimal value of uncertainty

% store states of all references given by dynamic model
xi_all = results_storage(:,4);
x_all = zeros(number_reference, number_time);
vx_all = zeros(number_reference, number_time);
y_all = zeros(number_reference, number_time);
vy_all = zeros(number_reference, number_time);

for i = 1 : number_reference    
    xi = xi_all{i};
    x = xi(1,:); x_all(i,:) = x;
    vx = xi(2,:); vx_all(i,:) = vx;
    y = xi(3,:); y_all(i,:) = y;
    vy = xi(4,:); vy_all(i,:) = vy;
end

% store measured states at each time instant
xi_measured_all = results_storage(:,5);
xi_measured = xi_measured_all{index_real_reference};
x_measured = xi_measured(1,:); vx_measured = xi_measured(2,:); y_measured = xi_measured(3,:); vy_measured = xi_measured(4,:);

% difference between states given by model and measured y position
x_difference_all = zeros(number_reference, number_time);
vx_difference_all = zeros(number_reference, number_time);
y_difference_all = zeros(number_reference, number_time);
vy_difference_all = zeros(number_reference, number_time);

for i = 1 : number_reference
    x_difference_all(i,:) = x_all(i,:) - x_measured;
    vx_difference_all(i,:) = vx_all(i,:) - vx_measured;
    y_difference_all(i,:) = y_all(i,:) - y_measured;
    vy_difference_all(i,:) = vy_all(i,:) - vy_measured;
end

% assign uncertainty of each measurement along the time
belief_mass_measurement_y = zeros(number_reference + 1, number_time);
belief_mass_measurement_vy = zeros(number_reference + 1, number_time);
belief_mass_measurement_4D = zeros(number_reference + 1, number_time);
% decay_rate = 0.005;

% assign belief mass for each reference
for i = 1 : number_time
    % assign belief mass according to y
    belief_mass_measurement_y(1:number_reference,i) = belief_mass_assignment_1D(number_reference, y_all(:, i), y_measured(i), std_dev_input_v, std_dev_sensor_v);
    % assign belief mass according to vy
    belief_mass_measurement_vy(1:number_reference,i) = belief_mass_assignment_1D(number_reference, vy_all(:, i), vy_measured(i), std_dev_input_v, std_dev_sensor_v);
    % assign belief mass according to both x, vx, y and vy
    belief_mass_measurement_4D(1:number_reference,i) = belief_mass_assignment_4D(number_reference, x_all(:, i), x_measured(i), vx_all(:, i), vx_measured(i), y_all(:, i), y_measured(i), vy_all(:, i), vy_measured(i), std_dev_input_v, std_dev_sensor_v);
end

% update uncertainty at current time instant and scale belief mass

N = 100; % consider 5 previous time instants for k_c

k = mean(std_dev_sensor_v); % parameter proportional to quality of sensor, which influences uncertainty

for i = 1 : number_time
    % get factor k_d based on difference between the largest belief mass 
    % and the second largest belief mass
    k_d_y = multiplicator_difference(belief_mass_measurement_y(1:(end-1),i));
    k_d_vy = multiplicator_difference(belief_mass_measurement_vy(1:(end-1),i));
    k_d_4D = multiplicator_difference(belief_mass_measurement_4D(1:(end-1),i));
    
    % get factor k_c_f based on change of reference with the largest belief
    % in the past N time instants
    % get factor k_c_a based on change of reference with belief distribution
    % in the past N time instants (used in simulations of the paper)
    if i >= N
        k_c_y = multiplicator_change(belief_mass_measurement_y, N, i);
        [k_c_f_y, k_c_a_y] = multiplicator_change_freq_ampl(belief_mass_measurement_y, N, k, i);
        k_c_vy = multiplicator_change(belief_mass_measurement_vy, N, i);
        [k_c_f_vy, k_c_a_vy] = multiplicator_change_freq_ampl(belief_mass_measurement_vy, N, k, i);
        k_c_4D = multiplicator_change(belief_mass_measurement_4D, N, i);
        [k_c_f_4D, k_c_a_4D] = multiplicator_change_freq_ampl(belief_mass_measurement_4D, N, k, i);
    else
        k_c_y = 1;
        k_c_f_y = 1; k_c_a_y = 1;
        k_c_vy = 1;
        k_c_f_vy = 1; k_c_a_vy = 1;
        k_c_4D = 1;
        k_c_f_4D = 1; k_c_a_4D = 1;
    end
    
    % uncertainty_y = (uncertainty_min - uncertainty_ini)*(-exp(-decay_rate*(i - 1)) + 1) + uncertainty_ini;
    % uncertainty_y = 0.1*k_d_y + 0.9*k_c_y;
    % uncertainty_vy = (uncertainty_min - uncertainty_ini)*(-exp(-decay_rate*(i - 1)) + 1) + uncertainty_ini;
    % uncertainty_vy = 0.1*k_d_vy + 0.9*k_c_vy;
    % uncertainty_4D = (uncertainty_min - uncertainty_ini)*(-exp(-decay_rate*(i - 1)) + 1) + uncertainty_ini;
    % uncertainty_4D = 0.1*k_d_4D + 0.9*k_c_4D;
    uncertainty_y = k_c_a_y;
    uncertainty_vy = k_c_a_vy;
    uncertainty_4D = k_c_a_4D;
    % uncertainty_y = 0.1;
    % uncertainty_vy = 0.1;
    % uncertainty_4D = 0.1;
    
%     if abs(uncertainty_y - 0) < 1e-4
%         uncertainty_y = 0.001;
%     end
%     if abs(uncertainty_vy - 0) < 1e-4
%         uncertainty_vy = 0.001;
%     end
%     if abs(uncertainty_4D - 0) < 1e-4
%         uncertainty_4D = 0.001;
%     end

    % Set uncertainty to the last component of each opinion
    belief_mass_measurement_y(end, i) = uncertainty_y;
    belief_mass_measurement_y(1:number_reference,i) = (1 - uncertainty_y) * belief_mass_measurement_y(1:number_reference,i);
    belief_mass_measurement_vy(end, i) = uncertainty_vy;
    belief_mass_measurement_vy(1:number_reference,i) = (1 - uncertainty_vy) * belief_mass_measurement_vy(1:number_reference,i);
    belief_mass_measurement_4D(end, i) = uncertainty_4D;
    belief_mass_measurement_4D(1:number_reference,i) = (1 - uncertainty_4D) * belief_mass_measurement_4D(1:number_reference,i);
end

% integrate belief mass vectors of 2 sources into one cell
belief_mass_measurement_2s = {1, number_time};

for i = 1:number_time
    belief_mass_measurement_2s{1, i} = [belief_mass_measurement_y(:, i) belief_mass_measurement_vy(:, i)];
end

% opinion of one source based on full state
belief_mass_measurement_1s = belief_mass_measurement_4D;

end