%%% M/M/1/B %%%
%%% uniformization approach %%%
clear
load('kl_floor.mat')
T = 1e6; % simulation time
lambda = 4; %arrival rate
mu = 4; % local service rate
N = 10; % number of users
c = 10; % global rate
k_floor = k1_floor; % system parameter
rho = lambda/ mu;

B_g = zeros(1, length(k_floor));
B_s_ceiling = zeros(1, length(k_floor));
for i = 1 : length(k_floor)
    %%% overall
    if rho == 1
        x_opt_g = (6*k_floor(i)*lambda^3/c^2)^(1/4) - 1; % overall
        x_opt_s = (2.*k_floor(i).*lambda^3./c^2).^(1/4) - 1; % selfish
    else
        myfun = @(x) (3.*k_floor(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
        x_opt_g = fzero(myfun, [-0.9 200]);
        
        myfun1 = @(x) (k_floor(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 ...
                + (rho.^(x+1)-1)./log(rho) - x - 1;
        x_opt_s = fzero(myfun1, [-0.9 200]);
    end
    if x_opt_g < 0
        B_g_temp(1) = 0;
        B_g_temp(2) = 0;
        B_g_temp(3) = 0;
    else
        B_g_temp(1) = floor(x_opt_g);  % 1- floor
        B_g_temp(2) = floor(x_opt_g) + 1; % 2 - ceiling
        B_g_temp(3) = x_opt_g; % continous
    end
    
    if x_opt_s < 0
        B_s_ceiling(i) = 0;
    else
        B_s_ceiling(i) = ceil(x_opt_s);
    end
    if rho ~= 1
        pi_0 = (1 - rho)./(1 - rho.^(B_g_temp+1));
        pi_B = (rho.^B_g_temp - rho.^(B_g_temp+1))./(1 - rho.^(B_g_temp+1));
        E_Q = pi_0 .* rho .* ( 1 - rho.^B_g_temp)./(1-rho).^2 - B_g_temp .* rho.^(B_g_temp+1).*pi_0 ./ (1 - rho);
        E_Q1 = (B_g_temp+1)./(rho.^(B_g_temp+1) - 1) + B_g_temp + 1/(1 - rho);
    else
        pi_B = 1 ./ (B_g_temp+1);
        E_Q = B_g_temp./ 2;
    end
    T_g  =  E_Q./lambda + k_floor(i).*lambda^2 .* pi_B.^3 ./ c^2;
    if T_g(1) < T_g(2)
        B_g(i) = B_g_temp(1);
    else
        B_g(i) = B_g_temp(2);
    end
end

QueueLength = zeros(N, length(k_floor));
TotalArrivalCount = zeros(N, length(k_floor));
GlobalCount = zeros(1, length(k_floor));
pi_B = zeros(N, length(k_floor));
NumberOfJobInGlobal = zeros(N, length(k_floor));
totalQ = zeros(N, length(k_floor));
avgQ = zeros(N, length(k_floor));

Cost = zeros(1, length(k_floor));
TheoryPi_B = zeros(1, length(k_floor));
TheoryAvgQ = zeros(1, length(k_floor));
TheoryCost = zeros(1, length(k_floor));

for i =  1 : length(k_floor)
    for t = 1 : T
         u = rand();
         if u <  N * lambda/( N * lambda +   N * mu) % arrival process
             userID_arrival = randi([1 N],1,1);
             TotalArrivalCount(userID_arrival, i) = TotalArrivalCount(userID_arrival, i) + 1;
             if QueueLength(userID_arrival, i) < B_g(i)
                 QueueLength(userID_arrival, i) = QueueLength(userID_arrival, i) + 1;
             else
                 NumberOfJobInGlobal(userID_arrival, i) = NumberOfJobInGlobal(userID_arrival, i) + 1;
                 GlobalCount(1, i) = GlobalCount(1, i) + 1;
             end
         else
             userID_depature = randi([1 N],1,1);
             QueueLength(userID_depature, i) = max(QueueLength(userID_depature, i) - 1, 0);
         end
         totalQ(:,i) = totalQ(:,i) + QueueLength(:,i);
         pi_B(:, i) = NumberOfJobInGlobal(:, i) ./ TotalArrivalCount(:, i);
    end
    avgQ(:,i) = totalQ(:,i) / T;
    for n = 1 : N
        Cost(1, i) = Cost(1, i) + avgQ(n, i)/lambda + k_floor(i) * (lambda * sum( pi_B(:, i))/ (N *c)).^2 * pi_B(n, i);
    end
    Cost(1, i) = Cost(1, i) / N;
    if lambda ~= mu
        TheoryAvgQ(1, i) = (B_g(i) + 1)/(rho^(B_g(i) + 1) - 1) + B_g(i) + 1/(1 - rho);
        TheoryPi_B(1, i) = (rho^B_g(i) - rho(1, i)^(B_g(i) + 1))/(1 - rho^(B_g(i) + 1));
    else
        TheoryAvgQ(1, i) = B_g(i) / 2;
        TheoryPi_B(1, i) = 1 / (B_g(i) + 1);
    end
    TheoryCost(1, i) = TheoryAvgQ(1, i)/lambda + k_floor(i) * (lambda * N * TheoryPi_B(1, i)/ (N * c))^2 * TheoryPi_B(1, i);
end

figure(1)
plot(k_floor .*lambda^3/c^2,TheoryCost, 'r-s','LineWidth',2.5,'MarkerSize',6)
hold on
plot(k_floor .*lambda^3/c^2,Cost, 'b-o','LineWidth',2.5,'MarkerSize',6)
legend({'TheoryCost','Cost'},'FontSize', 15)
xlabel('k\lambda^3/c^2','FontSize',15)
ylabel('cost','FontSize',15)
grid on
