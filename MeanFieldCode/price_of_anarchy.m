%randomized vs threshold policy
clear
mu = 1; % local service rate
lambda = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9]; % arrival rate
alpha = 0 : 0.001 : 1;
C = 2; %cost efficient
min_f = zeros(1, length(lambda));
min_g = zeros(1, length(lambda));
priceOfAnarchy =  zeros(1, length(lambda));

for i = 1 : length(lambda)
    %randomized policy
    f = alpha./(mu - alpha.*lambda(i)) + 10.*lambda(i)^2 .* (1 - alpha).^3 ./ C^2; %object function
    
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
    g_B =  E_Q./lambda(i) + 10.*lambda(i)^2 .* pi_B.^3 ./ C^2; %object function
    
    min_f(i) = min(f);%optimal under randomized policy
    min_g(i) = min(g_B);%optimal under threshold based policy
    
    priceOfAnarchy(i) = 1 - min_g(i)/min_f(i);
end

figure(1)
plot(lambda, priceOfAnarchy, 'r-s','LineWidth',2.5,'MarkerSize',8)
xlabel('\lambda','FontSize',18)
ylabel('Price Of Anarchy','FontSize',18)
grid on

% figure(1)
% plot(alpha, f, 'r-s','LineWidth',2.5,'MarkerSize',8)
% xlabel('\alpha','FontSize',18)
% ylabel('f(\alpha)','FontSize',18)
% title('randomilized policy, \lambda = ' + string(lambda) + ', C = ' + string(C) ,'FontSize',18)
% grid on
% 
% figure(2)
% plot(1-pi_B, g_B, 'b-s','LineWidth',2.5,'MarkerSize',8)
% xlabel('B','FontSize',18)
% ylabel('g(B)','FontSize',18)
% title('threshold policy , \lambda = ' + string(lambda) + ', C = ' + string(C),'FontSize',18)
% grid on

% figure(3)
% plot(1-pi_B, E_Q,'b','LineWidth',2.5)
% hold on
% plot(alpha, f,'r','LineWidth',2.5)
% legend('TB','RD')
% axis([0 1 0 10])

% figure(4)
% plot(alpha, f, 'r','LineWidth',2.5)
% hold on
% plot(1-pi_B, g_B, 'b-*','LineWidth',2.5)
% legend('RD','TB')
% axis([0 1 0 20])

