% convergence (WiOpt 20)
clear
N = 3;
B = randi([0, 5], 1, N);%[100,200,330, 500];
lambda = 6;
mu = 4;
rho = lambda/ mu;
k = 33;
c = 10;
B_range = 0 : 100;
T = 15;
t = 0;
q = @(x) (x+1)./(rho.^(x+1) - 1) + x + 1/(1-rho); % queue length function
pi = @(x) (rho.^x - rho.^(x+1))./(1 - rho.^(x+1)); % probability function
cost = zeros(length(B_range), N); %cost function value
% W_0 = rho * (log(rho) + 1 - rho)/(lambda * (1 - rho) * log(rho) );
% klambda_square = k * lambda^2/c^2;
% B_track = zeros(T, N);
count = 0;

while t < T
    B_track(count+1,:) = B;
    time(count+1) = t;
    for n  = 1 : N
        % B_minus = B;
        % B_minus(n) = [];
        cost(:,n) =  q(B_range)/lambda + k*((lambda * sum(pi(B)))/(N * c))^2 * pi(B_range);
        index = B(n) + 1;
        if cost(index,n) > cost(index+1,n)
            B(n) = B(n) + 1;
        else
            if index > 1 && cost(index,n) > cost(index-1,n)
                B(n) = B(n) - 1;
            end
        end
        %[min_cost,index] = min(cost(:,n));
        % B(n) = B_range(index); % update B
    end
    t = t + exprnd(1);
    count = count + 1;
end

figure(1)
plot(time,B_track(:,1), 'b-o','LineWidth',2.5,'MarkerSize',10)
hold on
plot(time,B_track(:,2), 'r-*','LineWidth',2.5,'MarkerSize',10)
plot(time,B_track(:,3), 'k-+','LineWidth',2.5,'MarkerSize',10)
%plot(time,B_track(:,4), 'c-^','LineWidth',2.5,'MarkerSize',10)
%plot(time,B_track(:,5), 'm->','LineWidth',2.5,'MarkerSize',10)
xlabel('time','FontSize', 18)
ylabel('Threshold','FontSize', 18)
title('\rho = ' + string(rho) + ', c = ' + string(c) ...
    + ', \lambda = ' + string(lambda) + ', k = ' + string(k) , 'FontSize', 18)
legend({'user 1', 'user 2', 'user 3'}, 'FontSize', 18)
% set(gca,'FontSize',18)
grid on

figure(2)
plot(cost(:,3), 'b-o','LineWidth',2.5,'MarkerSize',10)