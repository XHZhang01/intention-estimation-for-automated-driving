% Reference Tracking of Target Vehicle
% Xuhui Zhang, 26.04.2022

function [u_ideal, u_real, xi_ref, xi, xi_measured] = reference_tracking_TV (xi_ini, x_ref, vx_ref, y_ref, vy_ref, std_dev_input, std_dev_sensor)

% dynamic model of TV: xi_k+1 = A*xi_k + B*u_k
T = 0.01; % sampling time
A = [1 T 0 0; 0 1 0 0; 0 0 1 T; 0 0 0 1];
B = [0.5*T^2 0; T 0; 0 0.5*T^2;0 T];

% total number of time instants
n = size(y_ref, 2);

% initial state of TV: xi_0 = xi_ini
xi = zeros(4,n);
xi(:, 1) = xi_ini;
xi_measured = zeros(4,n);
xi_measured(:, 1) = xi_ini;

xi_ref = zeros(4,n);
xi_ref(1,:) = x_ref; xi_ref(2,:) = vx_ref; xi_ref(3,:) = y_ref; xi_ref(4,:) = vy_ref;

% intialization of input series
u_ideal = zeros(2,n);
u_real = zeros(2,n);

% infinite-horizon, discrete-time LQR
Q = [0 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
% Q = [1 0 0 0; 0 1 0 0; 0 0 0 0; 0 0 0 1];
R = [1 0; 0 1];
N = zeros(4,2);
[K,~,~] = dlqr(A,B,Q,R,N);
K = -K; % feedback gain

% if reference is along y-axis, switch x-coordinate and y-coordinate
if vx_ref(1) == 0 && vy_ref(1) ~= 0
    K = [K(2,3) K(2,4) K(2,1) K(2,2);
         K(1,3) K(1,4) K(1,1) K(1,2);];
end

pd_input = makedist('Normal','mu',0,'sigma',std_dev_input); % Gaussian noise for input

pd_sensor = makedist('Normal','mu',0,'sigma',std_dev_sensor);
pd_sensor = truncate(pd_sensor,-2,2); % truncated Gaussian noise for sensor

for i = 2:(n+1)
    
    % update ideal input
    u_ideal(:,i-1) = K*(xi(:,i-1) - xi_ref(:,i-1));
    
    % add independent Gaussian noises
    u_real(1,i-1) = u_ideal(1,i-1) + random(pd_input);
    u_real(2,i-1) = u_ideal(2,i-1) + random(pd_input);
    
    % update state
    xi(:,i) = A*xi(:,i-1) + B*u_real(:,i-1);
    
    % add sensor noise to measured state
    xi_measured(1,i) = xi(1,i) + random(pd_sensor);
    xi_measured(2,i) = xi(2,i) + random(pd_sensor);
    xi_measured(3,i) = xi(3,i) + random(pd_sensor);
    xi_measured(4,i) = xi(4,i) + random(pd_sensor);

end

% % plot input series
% figure(1)
% plot(u_ideal(1,:));
% hold on
% plot(u_ideal(2,:));
% hold on
% plot(u_real(1,:));
% hold on
% plot(u_real(2,:));
% title('input series');
% legend('ideal acceleration in x direction','ideal acceleration in y direction','real acceleration in x direction','real acceleration in y direction');
% 
% % plot reference position and model-given position in x direction
% figure(2)
% plot(xi(1,:));
% hold on
% plot(xi_ref(1,:));
% title('reference position and model-given position in x direction');
% legend('model-given x position','reference x position');
% 
% % plot reference velocity and model-given velocity in x direction
% figure(3)
% plot(xi(2,:));
% hold on
% plot(xi_ref(2,:));
% title('reference velocity and model-given velocity in x direction');
% legend('model-given x velocity','reference x velocity');
% 
% % plot reference position and model-given position in y direction
% figure(4)
% plot(xi(3,:));
% hold on
% plot(xi_ref(3,:));
% title('reference position and model-given position in y direction');
% legend('model-given y position','reference y position');
% 
% % plot reference velocity and model-given velocity in y direction
% figure(5)
% plot(xi(4,:));
% hold on
% plot(xi_ref(4,:));
% title('reference velocity and model-given velocity in y direction');
% legend('model-given y velocity','reference y velocity');
% 
% % plot reference position and measured position in x direction
% figure(6)
% plot(xi_measured(1,:));
% hold on
% plot(xi_ref(1,:));
% title('reference position and measured position in x direction');
% legend('measured x position','reference x position');
% 
% % plot reference velocity and measured velocity in x direction
% figure(7)
% plot(xi_measured(2,:));
% hold on
% plot(xi_ref(2,:));
% title('reference velocity and measured velocity in x direction');
% legend('measured x velocity','reference x velocity');
% 
% % plot reference position and measured position in y direction
% figure(8)
% plot(xi_measured(3,:));
% hold on
% plot(xi_ref(3,:));
% title('reference position and measured position in y direction');
% legend('measured y position','reference y position');
% 
% % plot reference velocity and measured velocity in y direction
% figure(9)
% plot(xi_measured(4,:));
% hold on
% plot(xi_ref(4,:));
% title('reference velocity and measured velocity in y direction');
% legend('measured y velocity','reference y velocity');

end