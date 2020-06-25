% convergence (WiOpt 20)
clear
N = 4;
B = [10,0,1, 12];%[4, 0, 2];% randi([0, 10], 1, N);%
lambda = 7;
mu = 5;
rho = lambda/ mu;
k = 34;
c = 13;
B_range = 0 : 10;
T = 6;
t = 0;
q = @(x) (x+1)./(rho.^(x+1) - 1) + x + 1/(1-rho); % queue length function
pi = @(x) (rho.^x - rho.^(x+1))./(1 - rho.^(x+1)); % probability function
cost = zeros(length(B_range), N); %cost function value
% W_0 = rho * (log(rho) + 1 - rho)/(lambda * (1 - rho) * log(rho) );
% klambda_square = k * lambda^2/c^2;
% B_track = zeros(T, N);
count = 0;
B_new = zeros(N,1);

while t < T
    B_track(count+1,:) = B;
    time(count+1) = t;
    for n  = 1 : N
        % B_minus = B;
        % B_minus(n) = [];
        cost(:,n) =  q(B_range)/lambda + k*((lambda * sum(pi(B)))/(N * c))^2 * pi(B_range);
        g_track(n, count+1) = k*((lambda * sum(pi(B)))/(N * c))^2;
        cost_track(:, n, count+1) = cost(:,n);
        [min_cost,index] = min(cost(:,n));
        B_new(n) = B_range(index); 
    end
    B = B_new; % update B
    t = t + 1;%exprnd(1);
    count = count + 1;
end

figure(1)
plot(time,B_track(:,1), 'b-o','LineWidth',2.5,'MarkerSize',10)
hold on
plot(time,B_track(:,2), 'r-*','LineWidth',2.5,'MarkerSize',10)
plot(time,B_track(:,3), 'k-+','LineWidth',2.5,'MarkerSize',10)
plot(time,B_track(:,4), 'c-^','LineWidth',2.5,'MarkerSize',10)
%plot(time,B_track(:,5), 'm->','LineWidth',2.5,'MarkerSize',10)
xlabel('time','FontSize', 18)
ylabel('Threshold','FontSize', 18)
title('\rho = ' + string(rho) + ', c = ' + string(c) ...
    + ', \lambda = ' + string(lambda) + ', k = ' + string(k) , 'FontSize', 18)
legend({'user 1', 'user 2', 'user 3'}, 'FontSize', 18)
% set(gca,'FontSize',18)
grid on

figure(2)
plot(B_range, cost_track(:, 1, 1), 'b-o','LineWidth',2.5,'MarkerSize',10)
hold on
plot(B_range, cost_track(:, 1, 2), 'r-o','LineWidth',2.5,'MarkerSize',10)
plot(B_range, cost_track(:, 1, 3), 'k-o','LineWidth',2.5,'MarkerSize',10)
plot(B_range, cost_track(:, 1, 4), 'm-o','LineWidth',2.5,'MarkerSize',10)
xlabel('B', 'FontSize', 18)
ylabel('cost', 'FontSize', 18)
legend({'1st iteration', '2nd iteration', '3rd iteration', '4th iteration'}, 'FontSize', 18)

