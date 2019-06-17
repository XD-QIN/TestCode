%randomized vs threshold policy
clear
mu = 1; % local service rate
lambda = 0.01:0.01:1.99; % arrival rate
C = 5; %global server efficient
k = 10;
min_f = zeros(1, length(lambda));
min_g = zeros(1, length(lambda));
priceOfAnarchy =  zeros(1, length(lambda));

for i = 1 : length(lambda)
    %randomized policy
    alpha = 0 : 0.001 : min(1, mu/lambda(i));
    f = alpha./(mu - alpha.*lambda(i)) + k.*lambda(i)^2 .* (1 - alpha).^3 ./ C^2; %object function
    
    % threshold policy
    rho = lambda(i) / mu;
    B = 0 : 1 : 20;
    if lambda(i) ~= 1
        pi_0 = (1 - rho)./(1 - rho.^(B+1));
        pi_B = (rho.^B - rho.^(B+1))./(1 - rho.^(B+1));
        E_Q = pi_0 .* rho .* ( 1 - rho.^B)./(1-rho).^2 - B .* rho.^(B+1).*pi_0 ./ (1 - rho);
        E_Q1 = (B+1)./(rho.^(B+1) - 1) + B + 1/(1 - rho);
    else
        pi_0 = 1 ./ (B+1);
        pi_B = 1 ./ (B+1);
        E_Q = B./ 2;
    end
    g_B =  E_Q./lambda(i) + k.*lambda(i)^2 .* pi_B.^3 ./ C^2; %object function
    
    min_f(i) = min(f);%optimal under randomized policy
    min_g(i) = min(g_B);%optimal under threshold based policy
    
    priceOfAnarchy(i) = 1 - min_g(i)/min_f(i);
end

figure(1)
plot(lambda, priceOfAnarchy, 'r-s','LineWidth',2,'MarkerSize',5)
xlabel('\lambda','FontSize',18)
ylabel('Price Of Anarchy','FontSize',18)
grid on
