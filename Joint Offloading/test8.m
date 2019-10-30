%%%%% Optimal Joint offloading and Scheduling%%%%
%%%% examples test %%%%
%%%% calculate Weight matrix %%%%
clear
A = 11; % arrival packets
X = 1; % virtual queue length
C = 3; % channel state
mu = 2; % local rate
e_E = 1; % edge energy consumption
e_L = 2; % local energy consumption
M = 1;
T = 3; % total time slots

y_max = T; 
z_max = T;

% schedule wireless transmission from 0 to y_max_int times 
W = zeros(y_max + 1, z_max + 1);
W_edge = zeros(1, y_max + 1);
W_local = zeros(1, y_max + 1);
z_maxWeight = zeros(1, y_max + 1);
W_local_bar = zeros(1, y_max + 1);

for y =  0 : y_max
    W_edge(y + 1) =  X * min(A, y * C) - M * e_E * y;%
    for z = 0 : z_max  % maximize local weight
        W_local(z + 1) = X * min(max(A - y * C, 0), z * mu); %- M * e_L * z;
        W(y + 1, z + 1) = W_local(z + 1);%; + X * min(A, y * C);
        W_local_bar(y + 1) = X * min(max(A - y * C, 0), z * mu) + W_local_bar(y+1);
    end
    W_local_bar(y + 1) = W_local_bar(y + 1)/(T + 1);
end