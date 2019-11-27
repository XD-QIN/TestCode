%%% M/M/1/B %%%
%%% uniformization approach %%%

clear
T = 1e6; % simulation time
lambda = 4; %arrival rate
N = 10; % number of users
mu = 4; % local service rate
c = 10; % global rate
k = 201:10:471; % system parameter
B = 2; %threshold B 
rho = lambda/ mu;
QueueLength = zeros(N, length(k));
TotalArrivalCount = zeros(N, length(k));
GlobalCount = zeros(1, length(k));
pi_B = zeros(N, length(k));
NumberOfJobInGlobal = zeros(N, length(k));
totalQ = zeros(N, length(k));
avgQ = zeros(N, length(k));

Cost = zeros(1, length(k));

TheoryPi_B = zeros(1, length(k));
TheoryAvgQ = zeros(1, length(k));
TheoryCost = zeros(1, length(k));

for i =  1 : length(k)
    for t = 1 : T
         u = rand();
         if u <  N * lambda/( N * lambda +   N * mu) % arrival process
             userID_arrival = randi([1 N],1,1);
             TotalArrivalCount(userID_arrival, i) = TotalArrivalCount(userID_arrival, i) + 1;
             if QueueLength(userID_arrival, i) < B
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
        Cost(1, i) = Cost(1, i) + avgQ(n, i)/lambda + k(i) * (lambda * sum( pi_B(:, i))/ (N *c)).^2 * pi_B(n, i);
    end
    Cost(1, i) = Cost(1, i) / N;
    if lambda ~= mu
        TheoryAvgQ(1, i) = (B + 1)/(rho(1, i)^(B + 1) - 1) + B + 1/(1 - rho(1, i));
        TheoryPi_B(1, i) = (rho(1, i)^B - rho(1, i)^(B + 1))/(1 - rho(1, i)^(B + 1));
    else
        TheoryAvgQ(1, i) = B / 2;
        TheoryPi_B(1, i) = 1 / (B + 1);
    end
    TheoryCost(1, i) = TheoryAvgQ(1, i)/lambda + k(i) * (lambda * N * TheoryPi_B(1, i)/ (N * c))^2 * TheoryPi_B(1, i);
end

figure(1)
plot(k.*lambda^3/c^2,TheoryCost, 'r-s','LineWidth',1,'MarkerSize',6)
hold on
plot(k.*lambda^3/c^2,Cost, 'b-o','LineWidth',1,'MarkerSize',6)
legend({'TheoryCost','Cost'},'FontSize', 15)
xlabel('lambda','FontSize',15)
ylabel('cost','FontSize',15)
grid on

