% convergence (WiOpt 20)
clear
N = 3;
B = randi([0, 10], 1, N);%[100,200,330, 500];
lambda = 6;
mu = 4;
rho = lambda/ mu;
k = 20;
c = 10;
B_range = 0 : 100;
s = 0.8;
T = 5;
t = 0;
pk+ = @(x) rho.^((sqrt(rho)*s^2 - sqrt(rho) + 2*x)./(2 + sqrt(rho)*s^2 - sqrt(rho)) )*(rho-1) ./ (rho.^(2*(1+sqrt(rho)*s^2 - sqrt(rho) + x  )./(2 + sqrt(rho) * s^2 - sqrt(rho))  )  -1  );
q = @(x) rho*(log(1/rho)+pk(x).*log(pk(x)./(1-rho + pk(x)*rho) + pk(x).*log(rho))).*(2 + sqrt(rho./(exp(s^2))).*s^2 - sqrt(rho/exp(s^2)) ) ; % queue length function

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
        cost(:,n) =  q(B_range)/lambda + k*((lambda * sum(pk(B)))/(N * c))^2 .* pk(B_range);
        [min_cost,index] = min(cost(:,n));
        B(n) = B_range(index); % update B
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