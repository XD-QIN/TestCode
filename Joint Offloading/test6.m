 %%%%% Optimal Joint offloading and Scheduling%%%%
%%%% examples test %%%%
%%%% calculate Weight matrix %%%%
%%%% continuous %%%%
clear
A = 6; % arrival packets
X = 6; % virtual queue length
C = 1; % channel state
mu = 2; % local rate
e_E = 1; % edge energy consumption
e_L = 3; % local energy consumption
M = 1;
T = 5; % total time slots

y_max = T; 
z_max = T;
y = 0 : .01 : y_max;
z = 0 : .01 : z_max;

% schedule wireless transmission from 0 to y_max_int times 
W = zeros(length(y), length(z));
W_edge = zeros(1, length(y));
W_local = zeros(1, length(y));
z_maxWeight = zeros(1, length(y));

for i =  1 : length(y)
    W_edge(i) =  X * min(A, y(i) * C) - M * e_E * y(i);%
    for j = 1 : length(y)  % maximize local weight
        W_local(j) = X * min(max(A - y(i) * C, 0), z(j) * mu) - M * e_L * z(j);
        W(i, j) = W_edge(i) + W_local(j);
    end   
end



figure(1)
surf(y, z, W, 'EdgeColor', 'none')
xlabel('x : local process','FontSize', 10)
ylabel('y : edge transmission','FontSize', 10)
zlabel('z : total weight','FontSize', 10)
title('System Setup : A = ' + string(A) + ', X = ' + string(X) + ...
    ', \mu = ' + string(mu) + ', C = ' + string(C) + ', T = ' + string(T) ...
    + ', e^E = ' + string(e_E) + ', e^L  = ' + string(e_L),'FontSize', 14 )

% given z plot
% given_z = 3;
% figure(2)
% plot(y_all, W(:, given_z), 'r-o','LineWidth',2,'MarkerSize',10)
% xlabel('edge transmission', 'FontSize', 10)
% ylabel('total weight given k', 'FontSize', 10)
% title('System Setup : given z = ' + string(given_z) + ...
%     ', \mu = ' + string(mu) + ', C = ' + string(C) + ', T = ' + string(T) ...
%     + ', e^E = ' + string(e_E) + ', e^L  = ' + string(e_L),'FontSize', 14 )
% grid on
% 
% % given k plot
% given_k = 2;
% figure(3)
% plot(z_all, W(given_k,:), 'b-s','LineWidth',2,'MarkerSize',10)
% xlabel('edge transmission', 'FontSize', 10)
% ylabel('total weight given k', 'FontSize', 10)
% title('System Setup : given k = ' + string(given_k) + ...
%     ', \mu = ' + string(mu) + ', C = ' + string(C) + ', T = ' + string(T) ...
%     + ', e^E = ' + string(e_E) + ', e^L  = ' + string(e_L),'FontSize', 14 )
% grid on




