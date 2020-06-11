clear
T = 1e7; % simulation time
update_interval = 1e4;
lambda = 6;%0 : 0.1 : 1.8; %arrival rate
N = 2;
mu = 4; % local service rate
B_user = randi([0, 5], 1, N);
k = 40;
c = 10;
count = 0;
windows_size =  1;
updateB_t = 0;
rho = lambda/ mu;

TotalArrivalCount = zeros(51, N);
cost = zeros(length(B_user), 1);
cost_plus = zeros(length(B_user), 1);
cost_minus = zeros(length(B_user), 1);

GlobalQueue = zeros(51, N);
GlobalCount = zeros(51, N);
QueueLength = zeros(51, N);
totalQ = zeros(51, N);
BCount = zeros(51, N);
avgQ =  zeros(51, N);
pi_B = zeros(51, N);

GlobalQueue_Plus = zeros(51, N);
GlobalCount_plus = zeros(51, N);
piB_Plus = zeros(51, N);
freqBPlus = zeros(51, N);
QueueLength_plus = zeros(51, N);
totalQ_plus = zeros(51, N);
BCount_plus = zeros(51, N);
avgQPlus =  zeros(51, N);
pi_BPlus = zeros(51, N);

GlobalQueue_Minus = zeros(51, N);
GlobalCount_minus = zeros(51, N);
piB_Minus = zeros(51, N);
freqBMinus = zeros(51, N);
QueueLength_minus = zeros(51, N);
totalQ_minus = zeros(51, N);
BCount_minus = zeros(51, N);
avgQMinus =  zeros(51, N);
pi_BMinus = zeros(51, N);

for t = 1 : T
    for i =  1 : N
        u = rand();
        m = B_user(i)+1;
        m_plus = B_user(i)+windows_size+1;
        m_minus = max(B_user(i)- windows_size, 0)+1;
        BCount(m, i) = BCount(m, i) + 1;
        BCount_plus(m_plus, i) = BCount_plus(m_plus, i) + 1;
        BCount_minus(m_minus, i) = BCount_minus(m_minus, i) + 1;
        if u <  lambda/( lambda + mu) % arrival process
            TotalArrivalCount(m, i) = TotalArrivalCount(m, i) + 1;
            %%%%%%%%%%%%%%%%%%%%%%%%%%% B %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if QueueLength(m, i) < B_user(i)
                QueueLength(m, i) = QueueLength(m, i) + 1;
            else
                GlobalCount(m, i) = GlobalCount(m, i) + 1;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%% B+1 %%%%%%%%%%%%%%%%%%%%%%%%%%%
            if QueueLength_plus(m_plus, i) < B_user(i)+windows_size
                QueueLength_plus(m_plus, i) = QueueLength_plus(m_plus, i) + 1;  
            else
                GlobalCount_plus(m_plus, i) = GlobalCount_plus(m_plus, i) + 1;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%% B-1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if QueueLength_minus(m_minus, i) < max(B_user(i)- windows_size, 0)
                QueueLength_minus(m_minus, i) = QueueLength_minus(m_minus, i) + 1;
            else
                GlobalCount_minus(m_minus, i) = GlobalCount_minus(m_minus, i) + 1;
            end
        else
            QueueLength(m, i) = max(QueueLength(m, i) - 1, 0);
            QueueLength_plus(m_plus, i) = max(QueueLength_plus(m_plus, i) - 1, 0);
            QueueLength_minus(m_minus, i) = max(QueueLength_minus(m_minus, i) - 1, 0);
        end
        totalQ(m, i) = totalQ(m, i) + QueueLength(m, i);
        totalQ_plus(m_plus, i) = totalQ_plus(m_plus, i) + QueueLength_plus(m_plus, i);
        totalQ_minus(m_minus, i) = totalQ_minus(m_minus, i) + QueueLength_minus(m_minus, i);
        
        avgQ(m, i) = totalQ(m, i)/BCount(m, i);
        pi_B(m, i) = GlobalCount(m, i)/ TotalArrivalCount(m, i);
        
        avgQPlus(m_plus, i) = totalQ_plus(m_plus, i)/BCount_plus(m_plus, i);
        pi_BPlus(m_plus, i) = GlobalCount_plus(m_plus, i)/ TotalArrivalCount(m, i);
        
        avgQMinus(m_minus, i) = totalQ_minus(m_minus, i)/BCount_minus(m_minus, i);
        pi_BMinus(m_minus, i) = GlobalCount_minus(m_minus, i)/ TotalArrivalCount(m, i);      
    end
    if t - updateB_t == update_interval
        sum_pi =  pi_B(:,1) + pi_B(:,2);
        for n = 1: N
            m = B_user(n)+1;
            m_plus = B_user(n)+windows_size+1;
            m_minus = max(B_user(n)- windows_size, 0)+1;
            B_track(count+1,n) = B_user(n);
            cost(n) = avgQ(m, n)/lambda + k * ((lambda * sum_pi(m))/ (N * c))^2 * pi_B(m, n);
            cost_plus(n) = avgQPlus(m_plus, n)/lambda + k * ((lambda * (sum_pi(m))) / (N * c))^2 * pi_BPlus(m_plus, n);
            cost_minus(n) = avgQMinus(m_minus, n)/lambda + k * ((lambda * (sum_pi(m))) / (N * c))^2 * pi_BMinus(m_minus, n);
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
        time(count+1) = update_interval * count;
        count = count + 1;
        updateB_t = updateB_t + update_interval;
    end
end

figure(2)
plot(time, B_track(:,1), 'b-o','LineWidth',2,'MarkerSize',3)
hold on
plot(time, B_track(:,2), 'r-*','LineWidth',2,'MarkerSize',3)
% plot(time, B_track(:,3), 'k-+','LineWidth',2,'MarkerSize',3)
% plot(time, B_track(:,4), 'm->','LineWidth',2,'MarkerSize',3)
% plot(time, B_track(:,5), 'c-<','LineWidth',2,'MarkerSize',3)
xlabel('time','FontSize', 18)
ylabel('Threshold','FontSize', 18)
title('\rho = ' + string(rho) + ', c = ' + string(c) ...
    + ', \lambda = ' + string(lambda) + ', k = ' + string(k) , 'FontSize', 18)
% legend({'user 1', 'user 2', 'user 3'}, 'FontSize', 18)
% set(gca,'FontSize',18)
grid on