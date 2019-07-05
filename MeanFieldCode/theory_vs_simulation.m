%threshold based vs randomized policy
lambda = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
alpha = 100;
B = 6;
mu = 1;
T = 1e7;
Q_B = zeros(T,length(lambda));
Q_R = zeros(T,length(lambda));
E_QB = zeros(1,length(lambda));
E_QB1 = zeros(1,length(lambda));

for i = 1 : length(lambda)
    for t = 1 : T-1
        u = rand();
        if u < lambda(i)/(lambda(i) + mu)
            if Q_B(t,i) < B
                Q_B(t+1,i) = Q_B(t,i) + 1;
            else
                Q_B(t+1,i) = Q_B(t,i);
            end
        else
            Q_B(t+1,i) = max(Q_B(t,i)-1, 0);
        end
    end
    
    rho = lambda(i) / mu;
    
    pi_0 = (1 - rho)./(1 - rho.^(B+1));
    pi_B = (rho.^B - rho.^(B+1))./(1 - rho.^(B+1));
    E_QB(1,i) = pi_0 .* rho .* ( 1 - rho.^B)./(1-rho).^2 - B .* rho.^(B+1).*pi_0 ./ (1 - rho);
    E_QB1(1,i) = (B+1)./(rho.^(B+1) - 1) + B + 1/(1 - rho);
end

for j = 1 : length(lambda)
    for t = 1 : T-1
        u = rand();
        w = rand();
        rho = lambda(j) / mu;
        pi_B = (rho.^B - rho.^(B+1))./(1 - rho.^(B+1));
        if u < lambda(j)/(lambda(j) + mu)
            if w <= (1-pi_B)
                Q_R(t+1,j) = Q_R(t,j) + 1;
            else
                Q_R(t+1,j) = Q_R(t,j);
            end
        else
            Q_R(t+1,j) = max(Q_R(t,j)-1, 0);
        end
    end
end

figure(1)
plot(lambda, mean(Q_B), 'r-s','LineWidth',2.5,'MarkerSize',8)
hold on
plot(lambda, mean(Q_R), 'b-+','LineWidth',2.5,'MarkerSize',8)
plot(lambda, E_QB, 'k-*','LineWidth',2.5,'MarkerSize',8)
legend({'TB','RD','Theroy-TB'}, 'FontSize', 12)            