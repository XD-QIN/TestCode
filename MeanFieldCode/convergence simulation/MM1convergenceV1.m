clear
T = 1e6; % simulation time
update_interval = 1e3;
lambda = 6;%0 : 0.1 : 1.8; %arrival rate
N = 5;
% lambda = 0 : 0.1 : 1.9; there is a bug under this setup
mu = 4; % local service rate
% B = 0:100;
% B_user = [0, 1, 5];%randi([0, 5], 1, N);
B_user = randi([0, 5], 1, N);
rho = lambda/ mu;
QueueLength = zeros(length(B_user), 1);
TotalArrivalCount = zeros(length(B_user), 1);
GlobalCount = zeros(length(B_user), 1);
pi_B = zeros(length(B_user), 1);
NumberOfJobInGlobal = zeros(length(B_user), 1);
totalQ = zeros(length(B_user), 1);
avgQ = zeros(length(B_user), 1);
avgQ_old = zeros(length(B_user), 1);
pi_B_old = zeros(length(B_user), 1);
LocalCount = zeros(length(B_user), 1);
count = 0;
k = 20;
c = 10;
windows_size =  1;
updateB_t = 0;

alpha = 1; %average weight
cost = zeros(length(B_user), 1);
cost_plus = zeros(length(B_user), 1);
cost_minus = zeros(length(B_user), 1);

LocalCount_plus = zeros(length(B_user), 1);
QueueLength_plus = zeros(length(B_user), 1);
NumberOfJobInGlobal_plus = zeros(length(B_user), 1);
GlobalCount_plus = zeros(length(B_user), 1);
totalQ_plus = zeros(length(B_user), 1);

LocalCount_minus = zeros(length(B_user), 1);
QueueLength_minus = zeros(length(B_user), 1);
NumberOfJobInGlobal_minus = zeros(length(B_user), 1);
GlobalCount_minus = zeros(length(B_user), 1);
totalQ_minus = zeros(length(B_user), 1);

for t = 1 : T
    for i =  1 : length(B_user)
        u = rand();
        if u <  lambda/( lambda +   mu) % arrival process
            TotalArrivalCount(i) = TotalArrivalCount(i) + 1;
            if QueueLength(i) < B_user(i)
                LocalCount(i) = LocalCount(i) + 1;
                QueueLength(i) = QueueLength(i) + 1;
            else
                NumberOfJobInGlobal(i) = NumberOfJobInGlobal(i) + 1;
                GlobalCount(i) = GlobalCount(i) + 1;
            end
            
            if QueueLength_plus(i) < B_user(i)+windows_size
                LocalCount_plus(i) = LocalCount_plus(i) + 1;
                QueueLength_plus(i) = QueueLength_plus(i) + 1;
            else
                NumberOfJobInGlobal_plus(i) = NumberOfJobInGlobal_plus(i) + 1;
                GlobalCount_plus(i) = GlobalCount_plus(i) + 1;
            end
            
            if QueueLength_minus(i) < max(B_user(i)- windows_size, 0)
                LocalCount_minus(i) = LocalCount_minus(i) + 1;
                QueueLength_minus(i) = QueueLength_minus(i) + 1;
            else
                NumberOfJobInGlobal_minus(i) = NumberOfJobInGlobal_minus(i) + 1;
                GlobalCount_minus(i) = GlobalCount_minus(i) + 1;
            end           
        else
            QueueLength(i) = max(QueueLength(i) - 1, 0);
            QueueLength_plus(i) = max(QueueLength_plus(i) - 1, 0);
            QueueLength_minus(i) = max(QueueLength_minus(i) - 1, 0);
        end
        totalQ(i) = totalQ(i) + QueueLength(i);
        totalQ_plus(i) = totalQ_plus(i) + QueueLength_plus(i);
        totalQ_minus(i) = totalQ_minus(i) + QueueLength_minus(i);
    end
    avgQ = totalQ/t;
    pi_B = GlobalCount ./ TotalArrivalCount;
    
    avgQ_plus = totalQ_plus/t;
    pi_B_plus = GlobalCount_plus ./ TotalArrivalCount;
    
    avgQ_minus = totalQ_minus/t;
    pi_B_minus = GlobalCount_minus ./ TotalArrivalCount;
    
    sum_pi =  sum(pi_B);
    
    if t - updateB_t == update_interval
        sum_pi =  sum(pi_B);  
        for n = 1: length(B_user)
            B_track(count+1,n) = B_user(n);
            cost(n) = avgQ(n)/lambda + k * ((lambda * sum_pi)/ (length(B_user) * c))^2 * pi_B(n);
            cost_plus(n) = avgQ_plus(n)/lambda + k * ((lambda * (sum_pi)) / (length(B_user) * c))^2 * pi_B_plus(n);
            cost_minus(n) = avgQ_minus(n)/lambda + k * ((lambda * (sum_pi)) / (length(B_user) * c))^2 * pi_B_minus(n);
            if cost_minus(n) > cost_plus(n)
                if cost_plus(n) < cost(n)
                    B_user(n) = B_user(n) + 1;
                end
            else
                if cost_minus(n) < cost(n)
                    B_user(n) = max(B_user(n) - 1, 0);
                end
            end
        end
        time(count+1) = t;
        count = count + 1;
        updateB_t = updateB_t + update_interval;
    end
end

figure(2)
plot(time, B_track(:,1), 'b-o','LineWidth',2,'MarkerSize',5)
hold on
plot(time, B_track(:,2), 'r-*','LineWidth',2,'MarkerSize',5)
plot(time, B_track(:,3), 'k-+','LineWidth',2,'MarkerSize',5)
plot(time, B_track(:,4), 'm->','LineWidth',2,'MarkerSize',5)
plot(time, B_track(:,5), 'c-<','LineWidth',2,'MarkerSize',5)
xlabel('time','FontSize', 18)
ylabel('Threshold','FontSize', 18)
title('\rho = ' + string(rho) + ', c = ' + string(c) ...
    + ', \lambda = ' + string(lambda) + ', k = ' + string(k) , 'FontSize', 18)
legend({'user 1', 'user 2', 'user 3', 'user 4', 'user 5'}, 'FontSize', 18)
% set(gca,'FontSize',18)
grid on