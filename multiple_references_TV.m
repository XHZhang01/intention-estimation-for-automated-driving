% Mutiple References for Target Vehicle
% Xuhui Zhang, 26.04.2022

function [results_storage] = multiple_references_TV (vx_ref_all, y_ref_all, std_dev_input_v, std_dev_sensor_v)

num_ref = size(y_ref_all,1); % total number of references
results_storage = {num_ref,5}; % store results of different references

for i = 1:num_ref
    
    % reference tracking
    std_dev_input = std_dev_input_v(i);
    std_dev_sensor = std_dev_sensor_v(i);
    [u_ideal, u_real, xi_ref, xi, xi_measured] = reference_tracking_TV (vx_ref_all(i), y_ref_all(i,:), std_dev_input, std_dev_sensor);
    results_storage{i,1} = u_ideal; results_storage{i,2} = u_real; results_storage{i,3} = xi_ref; results_storage{i,4} = xi; results_storage{i,5} = xi_measured;
    
    % plot reference y position
    figure(1)
    plot(xi_ref(3,:));
    hold on
    
    % plot model-given y position for each reference (no sensor noise)
    figure(2)
    plot(xi(3,:));
    hold on
    
    % plot measured y position for each reference (with sensor noise)
    figure(3)
    plot(xi_measured(3,:));
    hold on
    
    % plot reference y velocity
    figure(4)
    plot(xi_ref(4,:));
    hold on
    
    % plot model-given y velocity for each reference (no sensor noise)
    figure(5)
    plot(xi(4,:));
    hold on
    
    % plot measured y velocity for each reference (with sensor noise)
    figure(6)
    plot(xi_measured(4,:));
    hold on
    
    % plot ideal input series in x direction for each reference
    figure(7)
    plot(u_ideal(1,:));
    hold on
    
    % plot ideal input series in y direction for each reference
    figure(8)
    plot(u_ideal(2,:));
    hold on
    
    % plot real input series in x direction for each reference
    figure(9)
    plot(u_real(1,:));
    hold on
    
    % plot real input series in y direction for each reference
    figure(10)
    plot(u_real(2,:));
    hold on
    
end

figure(1)
title('reference y positions');
% legend(string(y_ref));

figure(2)
title('model-given y positions for different references (no sensor noise)');
% legend(string(y_ref));

figure(3)
title('measured y positions for different references with sensor noise');
% legend(string(y_ref));

figure(4)
title('reference y velocities');
% legend(string(y_ref));

figure(5)
title('model-given y velocities for different references (no sensor noise)');
% legend(string(y_ref));

figure(6)
title('measured y velocities for different references with sensor noise');
% legend(string(y_ref));

figure(7)
title('ideal input series in x direction for each reference (without input noise)');
% legend(string(y_ref));

figure(8)
title('ideal input series in y direction for each reference (without input noise)');
% legend(string(y_ref));

figure(9)
title('real input series in x direction for each reference (with input noise)');
% legend(string(y_ref));

figure(10)
title('real input series in y direction for each reference (with input noise)');
% legend(string(y_ref));

end