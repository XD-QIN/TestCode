clear
N = 3;
B = randi([0, 100], 1, N);%[100,200,330, 500];
lambda = 6;
mu = 4;
rho = lambda/ mu;
k = 40;
c = 10;
B_range = 0 : 10;
T = 5;
t = 0;
q = @(x) (x+1)./(rho.^(x+1) - 1) + x + 1/(1-rho); % queue length function
pi = @(x) (rho.^x - rho.^(x+1))./(1 - rho.^(x+1)); % probability function
cost = zeros(length(B_range), N); %cost function value
% W_0 = rho * (log(rho) + 1 - rho)/(lambda * (1 - rho) * log(rho) );
% klambda_square = k * lambda^2/c^2;
% B_track = zeros(T, N);
count = 0;
B_star = zeros(N, 1);

for n  = 1 : N
        % B_minus = B;
        % B_minus(n) = [];
        cost(:,n) =  q(B_range)/lambda + k*((lambda * sum(pi(B)))/(N * c))^2 * pi(B_range);
        [min_cost,index] = min(cost(:,n));
        B_star(n) = B_range(index); % update B
end
    
figure(33)
plot(B_range, cost(:,1),'b-o','LineWidth',2.5,'MarkerSize',10)
hold on
plot(B_range, cost(:,2),'r-*','LineWidth',2.5,'MarkerSize',10)
plot(B_range, cost(:,3),'k->','LineWidth',2.5,'MarkerSize',10)