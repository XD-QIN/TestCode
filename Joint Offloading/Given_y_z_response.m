% given edge transmission times, z response
clear
A = 10; % arrival packets
X = 5; % virtual queue length
C = 3; % channel state
mu = 2; % local rate
e_E = 1; % edge energy consumption
e_L  = 2; % local energy consumption
M = 1;
T = 4; % total time slots

y_max_int =  min(ceil(A/C), T);
z_max_int  = min(ceil(A/mu), T);

% schedule wireless transmission from 0 to y_max_int times
W = zeros(y_max_int+1, z_max_int+1);
W_edge = zeros(y_max_int+1, z_max_int+1);
W_local = zeros(y_max_int+1, z_max_int+1);

%%%% i : number of edge transmission time %%%%
for i = 0 : y_max_int
    W_edge(1, 1) =  X * min(A, i * C) - M * e_E * min(ceil(A/C),i);
    W_local(1, 1) = 0; % z = 0, local weight  = 0
    W(1, 1) = W_edge(1, 1) + W_local(1, 1);
    for z = 1 : z_max_int  % maximize local weight
        W_local(i+1, z+1) = X * min(max(A - i * C, 0), z * mu) - M * e_L * ...
            min(ceil(max(A - i * C, 0)/mu), z);
        W(i+1, z+1) = W_edge(i+1, z+1) + W_local(i+1, z+1);
    end
end
z_all = 0 : z_max_int;
y_all = 0 : y_max_int;

j = 1;

figure(1)
plot(y_all, W(j, : ), 'b-*','LineWidth',2,'MarkerSize',10)
hold on
plot(y_all, W(j+1, : ), 'r-*','LineWidth',2,'MarkerSize',10)
xlabel('Number of edge transmission','FontSize',18)
ylabel('Total Weight','FontSize',18)
title('System Setup : A = ' + string(A) + ', X = ' + string(X) + ...
    ', \mu = ' + string(mu) + ', C = ' + string(C) + ', T = ' + string(T) ...
    + ', y = ' + string(i), 'FontSize', 18 )
grid on

