% Reference Tracking for Turning Left, Turning Right and Going Straight
% Xuhui Zhang, 23.06.2022

function [u_ideal, u_real, xi_ref, xi, xi_measured] = reference_tracking_crossroad (xi_ini, x_ref, vx_ref, y_ref, vy_ref, std_dev_input, std_dev_sensor)

% interpretation of inputs
% xi_ini: initial states [x0, vx0, y0, vy0].
% x_ref, vx_ref, y_ref, vy_ref: reference states of each trajetory for tracking.
% interpretation of inputs
% u_ideal: ideal input without input noise.
% u_real: real input with input noise.
% xi_ref: reference state of each trajectory.
% xi: ideal state (tracking result of LQR) of each trajectory without sensor noise.
% xi_measured: measured state with sensor noise.

% get the number of references
num_ref = size(x_ref, 1);
% get the number of time instants
num_time = size(x_ref, 2);

% initialize matrices for result storage
u_ideal = zeros(2, num_ref * num_time);
u_real = zeros(2, num_ref * num_time);
xi_ref = zeros(4, num_ref * num_time);
xi = zeros(4, num_ref * (num_time + 1));
xi_measured = zeros(4, num_ref * (num_time + 1));

for i = 1 : num_ref
    % track each reference with LQR
    [u_ideal_temp, u_real_temp, xi_ref_temp, xi_temp, xi_measured_temp] = reference_tracking_TV ([0;xi_ini(2);0;xi_ini(4)], x_ref(i, :), vx_ref(i, :), y_ref(i, :), vy_ref(i, :), std_dev_input, std_dev_sensor);
    % add x-coordinate and y-coordinate at last time instant of previous reference
    xi_ref_temp(1, :) = xi_ref_temp(1, :) + xi_ini(1); xi_ref_temp(3, :) = xi_ref_temp(3, :) + xi_ini(3);
    xi_temp(1, :) = xi_temp(1, :) + xi_ini(1); xi_temp(3, :) = xi_temp(3, :) + xi_ini(3);
    xi_measured_temp(1, :) = xi_measured_temp(1, :) + xi_ini(1); xi_measured_temp(3, :) = xi_measured_temp(3, :) + xi_ini(3);
    % store values in corresponding matrx
    u_ideal(:, ((i - 1) * num_time + 1) : (i * num_time)) = u_ideal_temp;
    u_real(:, ((i - 1) * num_time + 1) : (i * num_time)) = u_real_temp;
    xi_ref(:, ((i - 1) * num_time + 1) : (i * num_time)) = xi_ref_temp;
    xi(:, ((i - 1) * (num_time + 1) + 1) : (i * (num_time + 1))) = xi_temp;
    xi_measured(:, ((i - 1) * (num_time + 1) + 1) : (i * (num_time + 1))) = xi_measured_temp;
    % set new initial state for next reference
    xi_ini = xi_temp(:, end);
end

end