clear
T = 1e3; % simulation time
update_interval = 10;
lambda = 6;%0 : 0.1 : 1.8; %arrival rate
N = 1000;% 1000 users
mu = 4; % local service rate
B_user = randi([0, 20], 1, N);
k = 40;
c = 10;
count = 0;
windows_size =  1;
updateB_t = 0;
rho = lambda/ mu;
B = 0 : 50;

TotalArrivalCount = zeros(length(B), N);
cost = zeros(length(B), N);

GlobalQueue = zeros(length(B), N);
GlobalCount = zeros(length(B), N);
QueueLength = zeros(length(B), N);
totalQ = zeros(length(B), N);
BCount = zeros(length(B), N);
avgQ =  zeros(length(B), N);
pi_B = zeros(length(B), N);
index = zeros(N, 1);
sum_pi = 0;
% M/M/1/K average queue length and blocking probability3
q = @(x) (x+1)./(rho.^(x+1) - 1) + x + 1/(1-rho); % queue length function
pi = @(x) (rho.^x - rho.^(x+1))./(1 - rho.^(x+1)); % probability function

for t = 1 : T
    for i =  1 : N % N users 
        u = rand();
        m = B_user(i)+1;
        BCount(m, i) = BCount(m, i) + 1;
        if u <  lambda/( lambda + mu) % arrival process
            TotalArrivalCount(m, i) = TotalArrivalCount(m, i) + 1;
            %%%%%%%%%%%%%%%%%%%%%%%%%%% B %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if QueueLength(m, i) < B_user(i)
                QueueLength(m, i) = QueueLength(m, i) + 1;
            else
                GlobalCount(m, i) = GlobalCount(m, i) + 1;
            end
        else
            QueueLength(m, i) = max(QueueLength(m, i) - 1, 0); 
        end
        totalQ(m, i) = totalQ(m, i) + QueueLength(m, i);
        avgQ(m, i) = totalQ(m, i)/BCount(m, i);
        pi_B(m, i) = GlobalCount(m, i)/ TotalArrivalCount(m, i);
    end
    if t - updateB_t == update_interval
        B_track(count+1,:) = B_user;
        sum_pi = 0;
        for j = 1 : N
            index(j) = B_user(j) + 1;
            sum_pi = sum_pi + pi_B(index(j), j);
        end
        for n = 1: N
            cost(:,n) =  q(B)./lambda + k*((lambda * sum_pi)/(N * c))^2 .* pi(B);
            [min_cost,index] = min(cost(:,n));
            B_new(n) = B(index); 
        end
        B_user = B_new;
        time(count+1) = update_interval * count;
        count = count + 1;
        updateB_t = updateB_t + update_interval;
    end
end

figure(2)
plot(time, B_track(:,1), 'b-o','LineWidth',2,'MarkerSize',8)
hold on
plot(time, B_track(:,2), 'r-*','LineWidth',2,'MarkerSize',8)
plot(time, B_track(:,3), 'k-+','LineWidth',2,'MarkerSize',8)
plot(time, B_track(:,4), 'm->','LineWidth',2,'MarkerSize',8)
plot(time, B_track(:,5), 'c-<','LineWidth',2,'MarkerSize',3)
xlabel('time','FontSize', 18)
ylabel('Threshold','FontSize', 18)
title('\rho = ' + string(rho) + ', c = ' + string(c) ...
    + ', \lambda = ' + string(lambda) + ', k = ' + string(k) , 'FontSize', 18)
legend({'user 1', 'user 2', 'user 3', 'user 4','user 5'}, 'FontSize', 18)
% set(gca,'FontSize',18)
grid on