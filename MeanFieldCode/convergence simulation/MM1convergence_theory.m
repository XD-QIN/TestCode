clear
T = 1e6; % simulation time
lambda = 6;%0 : 0.1 : 1.8; %arrival rate
% lambda = 0 : 0.1 : 1.9; there is a bug under this setup
mu = 4; % local service rate
B = 0:100;
rho = lambda/ mu;

TheoryAvgQ = zeros(length(B), 1);
TheoryPi_B =  zeros(length(B), 1);

for i =  1 : length(B)
    if lambda ~= mu
        TheoryAvgQ(i) = (B(i) + 1)/(rho^(B(i)+1) - 1) + B(i) + 1/(1 - rho);
        TheoryPi_B(i) = (rho^B(i) - rho^(B(i)+1))/(1 - rho^(B(i)+1));
    else
        TheoryAvgQ(i) = B(i) / 2;
        TheoryPi_B(i) = 1 / (B(i) + 1);
    end
end

N = 3;
t = 0;
count = 0;
B_user = [0, 10, 4];%randi([0, 100], 1, N);
T = 200;
k = 20;
c = 10;
windows_size =  1;
while t < T
    time(count+1) = t;
    index1 = B_user(1) + 1;
    index2 = B_user(2) + 1;
    index3 = B_user(3) + 1;
    sum_pi =  TheoryPi_B(index1) + TheoryPi_B(index2) + TheoryPi_B(index3);
    for n = 1: N
        B_track(count+1,n) = B_user(n);
        index = B_user(n) + 1; % index of user n
        cost = TheoryAvgQ(index)/lambda + k * ( (lambda * sum_pi)/ (N * c))^2 * TheoryPi_B(index);
        cost_track(count+1,n) = cost;
        cost_plus = TheoryAvgQ(index+windows_size)/lambda + k * ( (lambda * (sum_pi)) / (N * c))^2 * TheoryPi_B(index+windows_size);
        if cost > cost_plus
            B_user(n) = B_user(n) + 1;
        else
            if index > windows_size
                cost_minus = TheoryAvgQ(index-windows_size)/lambda + k * ( (lambda * (sum_pi))/ (N * c))^2 * TheoryPi_B(index-windows_size);
                if cost > cost_minus
                    B_user(n) = B_user(n) - 1;
                end
            end
        end
%         if index > windows_size
%             cost_minus = TheoryAvgQ(index-windows_size)/lambda + k * ( (lambda * (sum_pi - TheoryPi_B(index) + TheoryPi_B(index-windows_size) ))/ (N * c))^2 * TheoryPi_B(index-windows_size);
%             if cost_plus < cost
%                 B_user(n) = B_user(n) + 1;
%             else
%                 if cost_minus < cost
%                     B_user(n) = B_user(n) - 1;
%                 end
%             end
%         else
%             if cost > cost_plus
%                 B_user(n) = B_user(n) + 1;
%             end
%         end
    end
    t = t + exprnd(1);
    count = count + 1;
end

figure(2)
plot(time,B_track(:,1), 'b-o','LineWidth',2,'MarkerSize',5)
hold on
plot(time,B_track(:,2), 'r-*','LineWidth',2,'MarkerSize',5)
plot(time,B_track(:,3), 'k-+','LineWidth',2,'MarkerSize',5)
xlabel('time','FontSize', 18)
ylabel('Threshold','FontSize', 18)
title('\rho = ' + string(rho) + ', c = ' + string(c) ...
    + ', \lambda = ' + string(lambda) + ', k = ' + string(k) , 'FontSize', 18)
legend({'user 1', 'user 2', 'user 3'}, 'FontSize', 18)
% set(gca,'FontSize',18)
grid on