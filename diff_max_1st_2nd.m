% Calculate the Difference Between the Largest Belief Mass and the Second Largest Belief Mass
% Xuhui Zhang, 18.05.2022

function [diff] = diff_max_1st_2nd(belief_mass)

% get number of time instants
num_time = size(belief_mass, 2);

% initialize vector where differences are stored
diff = zeros(1, num_time);

for i = 1:num_time
    % find the largest belief mass and the second largest belief mass
    [max_1st, max_2nd] = find_max (belief_mass(:, i));
    % store the difference
    diff(i) = abs(max_1st - max_2nd);
end

end