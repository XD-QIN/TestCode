clear
T = 1e6; % simulation time
lambda = 6;%0 : 0.1 : 1.8; %arrival rate
% lambda = 0 : 0.1 : 1.9; there is a bug under this setup
mu = 4; % local service rate
B = 0:100;
rho = lambda/ mu;
QueueLength = zeros(length(B), 1);
TotalArrivalCount = zeros(length(B), 1);
GlobalCount = zeros(length(B), 1);
pi_B = zeros(length(B), 1);
NumberOfJobInGlobal = zeros(length(B), 1);
totalQ = zeros(length(B), 1);
avgQ = zeros(length(B), 1);
avgQ_old = zeros(length(B), 1);
pi_B_old = zeros(length(B), 1);
LocalCount = zeros(length(B), 1);
N = 3;
count = 0;
B_user = [0, 1, 4];%randi([0, 100], 1, N);
k = 40;
c = 10;
windows_size =  1;
updateB_t = 0;
update_interval = 1e5;
alpha = 1; %average weight

for t = 1 : T
    for i =  1 : length(B)
        u = rand();
        if u <  lambda/( lambda +   mu) % arrival process
            TotalArrivalCount(i) = TotalArrivalCount(i) + 1;
            if QueueLength(i) < B(i)
                LocalCount(i) = LocalCount(i) + 1;
                QueueLength(i) = QueueLength(i) + 1;
            else
                NumberOfJobInGlobal(i) = NumberOfJobInGlobal(i) + 1;
                GlobalCount(i) = GlobalCount(i) + 1;
            end
        else
            QueueLength(i) = max(QueueLength(i) - 1, 0);
        end
        totalQ(i) = totalQ(i) + QueueLength(i);
    end
    avgQ = totalQ/t;
    pi_B = GlobalCount ./ TotalArrivalCount;
    
%     if t/update_interval == 1
%         avgQ = totalQ/update_interval;
%         pi_B = GlobalCount ./ TotalArrivalCount;
%     else
%         avgQ = alpha * totalQ/update_interval + (1 - alpha) * avgQ_old;
%         pi_B = alpha * GlobalCount ./ TotalArrivalCount + (1 - alpha) * pi_B_old;
%     end
    % update threshold
    if t - updateB_t == update_interval
        index1 = B_user(1) + 1;
        index2 = B_user(2) + 1;
        index3 = B_user(3) + 1;
        sum_pi =  pi_B(index1) + pi_B(index2) + pi_B(index3);
        for n = 1: N
            index = B_user(n) + 1;
            B_track(count+1,n) = B_user(n);
            cost = avgQ(index)/lambda + k * ( (lambda * sum_pi)/ (N * c))^2 * pi_B(index);
            cost_track(count+1,n) = cost;
            cost_plus = avgQ(index+windows_size)/lambda + k * ( (lambda * (sum_pi)) / (N * c))^2 * pi_B(index+windows_size);
            if index > windows_size
                cost_minus = avgQ(index-windows_size)/lambda + k * ( (lambda * (sum_pi))/ (N * c))^2 * pi_B(index-windows_size);
                if cost_plus < cost && cost < cost_minus
                    B_user(n) = B_user(n) + 1;
                end
                if cost_plus > cost && cost > cost_minus
                    B_user(n) = B_user(n) - 1;
                end
            else
                if cost > cost_plus
                    B_user(n) = B_user(n) + 1;
                end
            end
        end
        count = count + 1;
        updateB_t = updateB_t + update_interval;
        % save the previous data
%         avgQ_old = avgQ;
%         pi_B_old = pi_B;
        % reset statistcs
%         QueueLength = zeros(length(B), 1);
%         TotalArrivalCount = zeros(length(B), 1);
%         GlobalCount = zeros(length(B), 1);
%         pi_B = zeros(length(B), 1);
%         NumberOfJobInGlobal = zeros(length(B), 1);
%         totalQ = zeros(length(B), 1);
%         avgQ = zeros(length(B), 1);
    end
end

figure(2)
plot(B_track(:,1), 'b-o','LineWidth',2,'MarkerSize',5)
hold on
plot(B_track(:,2), 'r-*','LineWidth',2,'MarkerSize',5)
plot(B_track(:,3), 'k-+','LineWidth',2,'MarkerSize',5)
xlabel('time','FontSize', 18)
ylabel('Threshold','FontSize', 18)
title('\rho = ' + string(rho) + ', c = ' + string(c) ...
    + ', \lambda = ' + string(lambda) + ', k = ' + string(k) , 'FontSize', 18)
legend({'user 1', 'user 2', 'user 3'}, 'FontSize', 18)
% set(gca,'FontSize',18)
grid on