% Mutiple References for Crossroad, Namely Turning Left, Going Straight and Turning Right
% Xuhui Zhang, 26.06.2022

function [results_storage] = multiple_references_crossroad (std_dev_input_v, std_dev_sensor_v)

% interpretation of inputs
% std_dev_input_v and std_dev_sensor_v: 1 x 3 vector, 1 means one source.
% interpretation of outputs
% results_storage: reference tracking results of the scenario and contains states of all possible trajectories and measured state.

% reference trajectory for turning left
x_ref_left = [zeros(1, 1000); 1.6 * ones(1, 1000)]; vx_ref_left = [0.1 * ones(1, 1000); zeros(1, 1000)];
y_ref_left = [zeros(1, 1000); zeros(1, 1000)]; vy_ref_left = [zeros(1, 1000); 0.4 * ones(1, 1000)];

% reference trajectory for going straight
x_ref_straight = [zeros(1, 1000); zeros(1, 1000)]; vx_ref_straight = [0.1 * ones(1, 1000); 0.4 * ones(1, 1000)];
y_ref_straight = [zeros(1, 1000); zeros(1, 1000)]; vy_ref_straight = [zeros(1, 1000); zeros(1, 1000)];

% reference trajectory for turning right
x_ref_right = [zeros(1, 1000); 1.6 * ones(1, 1000)]; vx_ref_right = [0.1 * ones(1, 1000); zeros(1, 1000)];
y_ref_right = [zeros(1, 1000); zeros(1, 1000)]; vy_ref_right = [zeros(1, 1000); -0.4 * ones(1, 1000)];

% store results of different references
% num_ref = 3;
results_storage = {3,5};

% initial state
xi_ini = [0; 0; 0; 0];

% reference tracking of turning left
[u_ideal_left, u_real_left, xi_ref_left, xi_left, xi_measured_left] = reference_tracking_crossroad (xi_ini, x_ref_left, vx_ref_left, y_ref_left, vy_ref_left, std_dev_input_v(1), std_dev_sensor_v(1));
results_storage{1,1} = u_ideal_left; results_storage{1,2} = u_real_left; results_storage{1,3} = xi_ref_left; results_storage{1,4} = xi_left; results_storage{1,5} = xi_measured_left;

% plot model-given x- and y-coordinates for turning left
figure(1)
plot(xi_left(1, :), xi_left(3, :));
hold on

% plot measured x- and y-coordinates for turning left
figure(2)
plot(xi_measured_left(1, :), xi_measured_left(3, :));
hold on

% reference tracking of going straight
[u_ideal_straight, u_real_straight, xi_ref_straight, xi_straight, xi_measured_straight] = reference_tracking_crossroad (xi_ini, x_ref_straight, vx_ref_straight, y_ref_straight, vy_ref_straight, std_dev_input_v(2), std_dev_sensor_v(2));
results_storage{2,1} = u_ideal_straight; results_storage{2,2} = u_real_straight; results_storage{2,3} = xi_ref_straight; results_storage{2,4} = xi_straight; results_storage{2,5} = xi_measured_straight;

% plot model-given x- and y-coordinates for going straight
figure(1)
plot(xi_straight(1, :), xi_straight(3, :));
hold on

% plot measured x- and y-coordinates for going straight
figure(2)
plot(xi_measured_straight(1, :), xi_measured_straight(3, :));
hold on

% reference tracking of turning right for turning right
[u_ideal_right, u_real_right, xi_ref_right, xi_right, xi_measured_right] = reference_tracking_crossroad (xi_ini, x_ref_right, vx_ref_right, y_ref_right, vy_ref_right, std_dev_input_v(3), std_dev_sensor_v(3));
results_storage{3,1} = u_ideal_right; results_storage{3,2} = u_real_right; results_storage{3,3} = xi_ref_right; results_storage{3,4} = xi_right; results_storage{3,5} = xi_measured_right;

% plot model-given x- and y-coordinates for turning right
figure(1)
plot(xi_right(1, :), xi_right(3, :));
hold on

% plot measured x- and y-coordinates
figure(2)
plot(xi_measured_right(1, :), xi_measured_right(3, :));
hold on

figure(1)
title('model-given x- and y-coordinates (only input noise included)');
xlabel('x');
ylabel('y');

figure(2)
title('measured x- and y-coordinates (both input noise and sensor noise included)');
xlabel('x');
ylabel('y');

end