% Iterative Solve Discrete Algebraic Riccati Equation
% Xuhui Zhang, 30.06.2022

function [K, P] = disc_are_solver (A, B, Q, R)

% get the size of P, the same as Q
num = size(Q, 1);
% initialize P
P = eye(num, num);
% P(1, 1) = P(1, 1) + 1;
% P(2, 2) = P(2, 2) + 1;
% P(3, 3) = P(3, 3) + 1;
% P(4, 4) = P(4, 4) + 1;
% set tolerance
tol = 1e-6;
% initialization
P_new = P;
err = 1;

% find fixed point of discrete ARE iteratively
while err > tol
    P_old = P_new;
    P_new = Q + A' * P_old * A - A' * P_old * B * inv(R + B' * P_old * B) * B' * P_old * A;
    err = norm(P_new - P_old, "fro");
end
P = P_new;

% calculate K from P
K = inv(R + B' * P * B) * B' * P * A;

end