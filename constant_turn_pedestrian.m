% Constant Turn rate of Pedestrian
% Xuhui Zhang, 27.04.2022

function [xi, z] = constant_turn_pedestrian(omega)

omega = omega*pi/180; % [deg] to [rad]
n = 100; % total number of time stamps
T = 0.01; % time step interval

% dynamic model
F = [1 0 sin(omega*T)/omega (cos(omega*T) - 1)/omega;
     0 1 (1 - cos(omega*T))/omega sin(omega*T)/omega;
     0 0 cos(omega*T) -sin(omega*T);
     0 0 sin(omega*T) cos(omega*T)];

G = [0.5*T^2 0; 0 0.5*T^2; T 0; 0 T];

% measurement
H = [1 0 0 0; 0 1 0 0];

% initialize state, xi = [x; y; vx; vy]
xi = zeros(4,n);
xi(3,1) = 2; % [x0; y0; vx0; vy0] = [0; 0; 2; 0]

% initialize measurement, z = [x; y]
z = zeros(2,n);

pd_model = makedist('Normal','mu',0,'sigma',0.01); % Gaussian noise for model

pd_sensor = makedist('Normal','mu',0,'sigma',0.01);
pd_sensor = truncate(pd_sensor,-2,2); % truncated Gaussian noise for sensor

for i = 2:n
    
    % update state
    w = [random(pd_model); random(pd_model)]; 
    xi(:,i) = F*xi(:,i-1) + G*w;
    
    % add noise to measured date
    v = [random(pd_sensor); random(pd_sensor)];
    z(:,i) = H*xi(:,i) + v;
    
end

% % plot x and y
% figure(1)
% plot(z(1,:),z(2,:));
% axis equal
% xlabel('x'); ylabel('y');
% title('trajectory of pdestrian');
    
end