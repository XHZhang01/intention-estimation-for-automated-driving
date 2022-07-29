% Mutiple Turn Rate of Pedestrian
% Xuhui Zhang, 27.04.2022

function [results_storage] = multiple_turn_rate_pedestrian(turn_rate_set)

num = size(turn_rate_set,2); % total number of different turn rates
results_storage = {num,2}; % store results of different references

figure(1)

for i = 1:num
    
    % trajectory for each turn rate
    [xi, z] = constant_turn_pedestrian(turn_rate_set(i));
    results_storage{i,1} = xi; results_storage{i,2} = z; 
    
    % plot trajectory for each turn rate
    plot(z(1,:),z(2,:));
    hold on
    
end

axis equal
xlabel('x'); ylabel('y');
title('trajectories of pdestrian with different turn rates');
legend(string(turn_rate_set));

end