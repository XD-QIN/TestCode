%%% M/M/1/B %%%
%%% uniformization approach %%%

clear
T = 1e6; % simulation time
lambda = 6;%0 : 0.1 : 1.8; %arrival rate
% lambda = 0 : 0.1 : 1.9; there is a bug under this setup
mu = 4; % local service rate
B = 0:100;
rho = lambda/ mu;
QueueLength = zeros(length(B),1);
TotalArrivalCount = zeros(length(B),1);
GlobalCount = zeros(length(B),1);
pi_B = zeros(length(B),1);
TheoryPi_B = zeros(length(B),1);
NumberOfJobInGlobal = zeros(length(B),1);
totalQ = zeros(length(B),1);
avgQ = zeros(length(B),1);
TheoryAvgQ = zeros(length(B),1);


for i =  1 : length(B)
    for t = 1 : T
         u = rand();
         if u <  lambda/( lambda +   mu) % arrival process
             TotalArrivalCount(i) = TotalArrivalCount(i) + 1;
             if QueueLength(i) < B(i)
                 QueueLength(i) = QueueLength(i) + 1;
             else
                 NumberOfJobInGlobal(i) = NumberOfJobInGlobal(i) + 1;
                 GlobalCount(i) = GlobalCount(i) + 1;
             end
         else  %local departure process
             QueueLength(i) = max(QueueLength(i) - 1, 0);
         end
         totalQ(i) = totalQ(i) + QueueLength(i);
    end
    avgQ(i) = totalQ(i)/T;
    pi_B(i) = GlobalCount(i) / TotalArrivalCount(i);
    if lambda ~= mu
        TheoryAvgQ(i) = (B(i) + 1)/(rho^(B(i)+1) - 1) + B(i) + 1/(1 - rho);
        TheoryPi_B(i) = (rho^B(i) - rho^(B(i)+1))/(1 - rho^(B(i)+1));
    else
        TheoryAvgQ(i) = B(i) / 2;
        TheoryPi_B(i) = 1 / (B(i) + 1);
    end
end

k = 4;
c = 10;
cost = TheoryAvgQ/lambda + k * (lambda * sum(pi_B) / (length(B) * c))^2 .* pi_B;

figure(3)
plot(B,TheoryAvgQ, 'r-s','LineWidth',2.5,'MarkerSize',6)
hold on
plot(B,avgQ, 'b-o','LineWidth',2.5,'MarkerSize',6)
legend({'theoryQ','avgQ'},'FontSize', 15)
xlabel('B','FontSize',15)
ylabel('Average queue length','FontSize',15)
grid on

figure(4)
plot(B,TheoryPi_B, 'r-s','LineWidth',2.5,'MarkerSize',6)
hold on
plot(B,pi_B, 'b-o','LineWidth',2.5,'MarkerSize',6)
legend({'Theory\pi_B','\pi_B'},'FontSize', 15)
xlabel('B','FontSize',15)
ylabel('Average \pi_B','FontSize',15)
grid on