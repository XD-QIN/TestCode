%%%%% Optimal Joint offloading and Scheduling%%%%
%%%% examples test %%%%
%%%% calculate Weight matrix %%%%
clear
A = 3; % arrival packets
X = 6; % virtual queue length
C = 3; % channel state
mu = 2; % local rate
e_E = 2; % edge energy consumption
e_L = 1; % local energy consumption
M = 1;
T = 4; % total time slots

y_max = T; 
z_max = T;

% schedule wireless transmission from 0 to y_max_int times 
W = zeros(y_max + 1, z_max + 1);
W_edge = zeros(1, y_max + 1);
W_local = zeros(1, y_max + 1);
z_maxWeight = zeros(1, y_max + 1);

for y =  0 : y_max
    W_edge(y + 1) =  X * min(A, y * C) - M * e_E * y;%
    for z = 0 : z_max  % maximize local weight
        W_local(z + 1) = X * min(max(A - y * C, 0), z * mu) - M * e_L * z;
        W(y + 1, z + 1) = W_edge(y + 1) + W_local(z + 1);
    end   
end

z_all =  0 : z_max;
y_all = 0 : y_max;

figure(111)
surf(z_all, y_all, W)
xlabel('x : local process','FontSize', 10)
ylabel('y : edge transmission','FontSize', 10)
zlabel('z : total weight','FontSize', 10)
title('System Setup : A = ' + string(A) + ', X = ' + string(X) + ...
    ', \mu = ' + string(mu) + ', C = ' + string(C) + ', T = ' + string(T) ...
    + ', e^E = ' + string(e_E) + ', e^L  = ' + string(e_L),'FontSize', 14 )

% given z plot
given_z = 3;
figure(2)
plot(y_all, W(:, given_z), 'r-o','LineWidth',2,'MarkerSize',10)
xlabel('edge transmission', 'FontSize', 10)
ylabel('total weight given k', 'FontSize', 10)
title('System Setup : given z = ' + string(given_z) + ...
    ', \mu = ' + string(mu) + ', C = ' + string(C) + ', T = ' + string(T) ...
    + ', e^E = ' + string(e_E) + ', e^L  = ' + string(e_L),'FontSize', 14 )
grid on

% given k plot
given_k = 2;
figure(3)
plot(z_all, W(given_k,:), 'b-s','LineWidth',2,'MarkerSize',10)
xlabel('local processing', 'FontSize', 10)
ylabel('total weight given k', 'FontSize', 10)
title('System Setup : given k = ' + string(given_k) + ...
    ', \mu = ' + string(mu) + ', C = ' + string(C) + ', T = ' + string(T) ...
    + ', e^E = ' + string(e_E) + ', e^L  = ' + string(e_L),'FontSize', 14 )
grid on




