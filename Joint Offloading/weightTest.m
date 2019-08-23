%%%%% Optimal Joint offloading %%%%
A = 30; % arrival packets
X = 40; % virtual queue length
C = 10; % channel state
mu = 20; % local rate
e_E = 4; % edge energy consumption
e_L  = 7; % local energy consumption
M = 10;
T = 3; % total time slots

y_max_int =  min(ceil(A/C), T);
z_max_int  = min(ceil(A/mu), T);

W = zeros(1, y_max_int+1);
W_edge = zeros(1, y_max_int+1);
W_local = zeros(1, y_max_int+1);
y = 0 : y_max_int;
z_maxWeight = zeros(1, y_max_int+1);

for i =  0 : y_max_int
    W_edge(i+1) =  X * min(A, i * C) - M * e_E * min(ceil(A/C),i);
    W_local(i+1) = 0;
    for z = 1 : T
        W_local_temp = X * min(max(A - i * C, 0), z * mu) - M * e_L * ...
            min(ceil(max(A - i * C, 0)/mu), z);
        if W_local_temp > W_local(i+1)
            W_local(i+1) = W_local_temp;
            z_maxWeight(i+1) = z;
        end
    end
    W(i+1) = W_edge(i+1) + W_local(i+1);
end

figure(1)
plot(y,W, 'r-o','LineWidth',2,'MarkerSize',10)
xlabel('Number of Edge transmission','FontSize',18)
ylabel('Total Weight','FontSize',18)
title('System Setup : A = ' + string(A) + ', X = ' + string(X) + ...
    ', \mu = ' + string(mu) + ', C = ' + string(C) + ', T = ' + string(T) ...
    , 'FontSize', 18 )
grid on

figure(2)
plot(y,z_maxWeight, 'b-s','LineWidth',2,'MarkerSize',10)
xlabel('Number of Edge transmission : y','FontSize',18)
ylabel('Number of Local processing : z','FontSize',18)
title('System Setup : A = ' + string(A) + ', X = ' + string(X) + ...
    ', \mu = ' + string(mu) + ', C = ' + string(C) + ', T = ' + string(T) ...
    , 'FontSize', 18 )
grid on