%%%%% Optimal Joint offloading and Scheduling%%%%
%%%% examples test %%%%
%%%% calculate Weight matrix %%%%
clear
A = 14; % arrival packets
X = 7; % virtual queue length
C = 3; % channel state
mu = 4; % local rate
e_E = 1; % edge energy consumption
e_L = 2; % local energy consumption
M = 1;
T = 7; % total time slots

y_max = T; 
z_max = T;

% schedule wireless transmission from 0 to y_max_int times 
W = zeros(y_max + 1, z_max + 1);
W_edge = zeros(1, y_max + 1);
W_local = zeros(1, y_max + 1);
W_maxY = zeros(1, y_max+1);

for z =  0 : y_max
    W_local(z + 1) =  X * min(A, z * mu) - M * e_L * z;%
    for y = 0 : y_max  % maximize local weight
        W_edge(y + 1) = X * min(max(A - z * mu, 0), y * C) - M * e_E * y;
        W(y + 1, z + 1) = W_edge(y + 1) + W_local(z + 1);
        if y == 0
            W_maxY(y+1) = W(y+1, z+1);
        else
            if W(y+1, z+1) > W_maxY(y+1)
                W_maxY(y+1) = W(y+1, z+1);
            end
        end
    end   
end

y = 0 : y_max;
figure(2)
plot(y, W_maxY,'b-s','LineWidth',2,'MarkerSize',10)
xlabel('z: local processing')
ylabel('max_y Weight')