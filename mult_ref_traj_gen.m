% Multiple Reference Trajectories Generation
% Xuhui Zhang, 16.05.2022

function [y_ref_all] = mult_ref_traj_gen(N, ref_A, ref_B, ref_C, ref_D, ref_E, ref_F)

% N: number of time instants; vx_ref: reference velocity in x direction
% ref_A to ref_F [reference y positions; corresponding start time]

num_ref = 6; % number of references

ref = {ref_A, ref_B, ref_C, ref_D, ref_E, ref_F};

% initialize reference trajectories
y_ref_all = zeros(num_ref, N);

for i = 1:num_ref
    % store reference y positions and corresponding start times of each
    % reference in y_time
    y_time = ref{i};
    num_y = size(y_time, 2); % number of different y positions
    
    for j = 1:num_y
        if j < num_y
            y_ref_all(i, (y_time(2, j) + 1):y_time(2, j + 1)) = y_time(1, j);
        else
            if j == num_y
                y_ref_all(i, (y_time(2, j) + 1):N) = y_time(1, j);
            end
        end
    end
end

end