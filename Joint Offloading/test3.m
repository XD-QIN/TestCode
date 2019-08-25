%%%%% Optimal Joint offloading and Scheduling%%%%
clear
A = 11; % arrival packets
X = 7; % virtual queue length
C = 3; % channel state
mu = 2; % local rate
e_E = 4; % edge energy consumption
e_L  = 5; % local energy consumption
M = 1;
T = 7; % total time slots

y_max_int =  min(ceil(A/C), T); 
z_max_int  = min(ceil(A/mu), T);

% schedule wireless transmission from 0 to y_max_int times 
W = zeros(y_max_int+1, z_max_int+1);
W_edge = zeros(1, y_max_int+1);
W_local = zeros(1, y_max_int+1);
z_maxWeight = zeros(1, y_max_int+1);

for y =  0 : y_max_int
    W_edge(y+1) =  X * min(A, y * C) - M * e_E * min(ceil(A/C), y);%
    for z = 0 : z_max_int  % maximize local weight
         W_local(y+1) = X * min(max(A - y * C, 0), z * mu) - M * e_L * ...
            min(ceil(max(A - y * C, 0)/mu), z);
        W(y+1, z+1) = W_edge(y+1) + W_local(y+1);
    end
    
end

z_all =  0 : z_max_int;
y_all = 0 : y_max_int;

figure(1)
surf(z_all, y_all, W)
xlabel('x : local process','FontSize', 10)
ylabel('y : edge transmission','FontSize', 10)
zlabel('z : total weight','FontSize', 10)
title('System Setup : A = ' + string(A) + ', X = ' + string(X) + ...
    ', \mu = ' + string(mu) + ', C = ' + string(C) + ', T = ' + string(T) ...
    + ', e^E = ' + string(e_E) + ', e^L  = ' + string(e_L),'FontSize', 18 )

% given z plot
given_z = 4;
figure(2)
plot(y_all, W(:, given_z), 'r-o','LineWidth',2,'MarkerSize',10)
xlabel('edge transmission', 'FontSize', 10)
ylabel('total weight given k', 'FontSize', 10)
title('System Setup : given z = ' + string(given_z) + ...
    ', \mu = ' + string(mu) + ', C = ' + string(C) + ', T = ' + string(T) ...
    + ', e^E = ' + string(e_E) + ', e^L  = ' + string(e_L),'FontSize', 18 )
grid on

% given k plot
given_k = 2;
figure(3)
plot(z_all, W(given_k,:), 'b-s','LineWidth',2,'MarkerSize',10)
xlabel('edge transmission', 'FontSize', 10)
ylabel('total weight given k', 'FontSize', 10)
title('System Setup : given k = ' + string(given_k) + ...
    ', \mu = ' + string(mu) + ', C = ' + string(C) + ', T = ' + string(T) ...
    + ', e^E = ' + string(e_E) + ', e^L  = ' + string(e_L),'FontSize', 18 )
grid on

