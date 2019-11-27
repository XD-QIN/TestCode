%%% M/M/1/B %%%
%%% uniformization approach %%%

clear
T = 1e6; % simulation time
lambda = 0.1 : 0.1 : 1.8; %arrival rate
% lambda = 1;
N = 10; % number of users
% lambda = 0 : 0.1 : 1.9; %% there is a bug under this setup
mu = 1; % local service rate
c = 2; % global rate
k = 10; % system parameter
B = 2; %threshold B 
rho = lambda./ mu;
QueueLength = zeros(N, length(lambda));
TotalArrivalCount = zeros(N, length(lambda));
GlobalCount = zeros(1, length(lambda));
pi_B = zeros(N, length(lambda));
NumberOfJobInGlobal = zeros(N, length(lambda));
totalQ = zeros(N, length(lambda));
avgQ = zeros(N, length(lambda));

Cost = zeros(1, length(lambda));

TheoryPi_B = zeros(1, length(lambda));
TheoryAvgQ = zeros(1, length(lambda));
TheoryCost = zeros(1, length(lambda));

for i =  1 : length(lambda)
    for t = 1 : T
         u = rand();
         if u <  N * lambda(1, i)/( N * lambda(1, i) +   N * mu) % arrival process
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
        Cost(1, i) = Cost(1, i) + avgQ(n, i)/lambda(i) + k * (lambda(i) * sum( pi_B(:, i))/ (N *c)).^2 * pi_B(n, i);
    end
    Cost(1, i) = Cost(1, i) / N;
    if lambda(1,i) ~= mu
        TheoryAvgQ(1, i) = (B + 1)/(rho(1, i)^(B + 1) - 1) + B + 1/(1 - rho(1, i));
        TheoryPi_B(1, i) = (rho(1, i)^B - rho(1, i)^(B + 1))/(1 - rho(1, i)^(B + 1));
    else
        TheoryAvgQ(1, i) = B / 2;
        TheoryPi_B(1, i) = 1 / (B + 1);
    end
    TheoryCost(1, i) = TheoryAvgQ(1, i)/lambda(i) + k * (lambda(i) * N * TheoryPi_B(1, i)/ (N * c))^2 * TheoryPi_B(1, i);
end

figure(1)
plot(lambda,TheoryCost, 'r-s','LineWidth',2.5,'MarkerSize',6)
hold on
plot(lambda,Cost, 'b-o','LineWidth',2.5,'MarkerSize',6)
legend({'TheoryCost','Cost'},'FontSize', 15)
xlabel('lambda','FontSize',15)
ylabel('cost','FontSize',15)
grid on

figure(3)
plot(lambda,TheoryAvgQ, 'r-s','LineWidth',2.5,'MarkerSize',6)
hold on
plot(lambda,avgQ, 'b-o','LineWidth',2.5,'MarkerSize',6)
legend({'theoryQ','avgQ'},'FontSize', 15)
xlabel('lambda','FontSize',15)
ylabel('Average queue length','FontSize',15)
grid on

figure(4)
plot(lambda,TheoryPi_B, 'r-s','LineWidth',2.5,'MarkerSize',6)
hold on
plot(lambda,pi_B, 'b-o','LineWidth',2.5,'MarkerSize',6)
legend({'theory \pi_B','\pi_B'},'FontSize', 15)
xlabel('lambda','FontSize',15)
ylabel('Average queue length','FontSize',15)
grid on