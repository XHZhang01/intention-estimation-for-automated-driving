% Online Update of Belief for Each Reference
% Xuhui Zhang, 09.05.2022

function [belief_mass, belief_mass_measurement] = online_belief_update (results_storage, index_real_reference, std_dev_input_v, std_dev_sensor_v)

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

% store y positions of all references given by dynamic model
xi_all = results_storage(:,4);
y_all = zeros(number_reference, number_time);

for i = 1 : number_reference
    
    xi = xi_all{i};
    y = xi(3,:);
    
    y_all(i,:) = y;
    
end

% store measured y position at each time instant
xi_measured_all = results_storage(:,5);
xi_measured = xi_measured_all{index_real_reference};
y_measured = xi_measured(3,:);

% difference between y position given by model and measured y position
y_difference_all = zeros(number_reference, number_time);

for i = 1 : number_reference
    y_difference_all(i,:) = y_all(i,:) - y_measured;
end

% assign uncertainty of each measurement along the time
belief_mass_measurement = zeros(number_reference + 1, number_time);
decay_rate = 0.005;

% assign belief mass for each reference
for i = 1 : number_time
    belief_mass_measurement(1:number_reference,i) = belief_mass_assignment(number_reference, y_all(:,i), y_measured(i), std_dev_input_v, std_dev_sensor_v);
end

% update uncertainty at current time instant and scale belief mass

N = 50; % consider 5 previous time instants for k_c

for i = 1 : number_time
    % get factor k_d based on difference between the largest belief mass 
    % and the second largest belief mass
    k_d = multiplicator_difference(belief_mass_measurement(1:(end-1),i));
    
    % get factor k_c based on change of reference with the largest belief
    % in the past N time instants
    if i >= N
        k_c = multiplicator_change(belief_mass_measurement, N, i);
        [k_c_f, k_c_a] = multiplicator_change_freq_ampl(belief_mass_measurement, N, i);
    else
        k_c = 1;
        k_c_f = 1; k_c_a = 1;
    end
    
    % uncertainty = (uncertainty_min - uncertainty_ini)*(-exp(-decay_rate*(i - 1)) + 1) + uncertainty_ini;
    % uncertainty = 0.1*k_d + 0.9*k_c;
    uncertainty = k_c_a;
    % uncertainty = 0.1;
    
%     if abs(uncertainty - 0) < 1e-4
%         uncertainty = 0.001;
%     end
    
    belief_mass_measurement(end, i) = uncertainty;

    belief_mass_measurement(1:number_reference,i) = (1 - uncertainty) * belief_mass_measurement(1:number_reference,i);
end

% fusion of belief mass based on previous knowledge and belief mass based
% on measurement at current time instant

belief_mass = zeros(number_reference + 1, number_time);
belief_mass(:,1) = belief_mass_vector;

for i = 2 : number_time
    belief_mass(:, i) = weighted_belief_fusion (belief_mass(:, i - 1), belief_mass_measurement(:, i));
end

end