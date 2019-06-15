%randomized vs threshold policy
clear
mu = 1; % local service rate
lambda = 0.5; % arrival rate
alpha = 0 : 0.001 : 1;
C = 2; %cost efficient
% static fraction
f = alpha./(mu - alpha.*lambda) + 10.*lambda^2 .* (1 - alpha).^3 ./ C^2;

% threshold policy
rho = lambda / mu;

B = 0 : 1 : 20;
if lambda ~= 1
    pi_0 = (1 - rho)./(1 - rho.^(B+1));
    pi_B = (rho.^B - rho.^(B+1))./(1 - rho.^(B+1));
    E_Q = pi_0 .* rho .* ( 1 - rho.^B)./(1-rho).^2 - B .* rho.^(B+1).*pi_0 ./ (1 - rho);
    E_Q1 = (B+1)./(rho.^(B+1) - 1) + B + 1/(1 - rho);
else
    pi_0 = 1 ./ (B+1);
    pi_B = 1 ./ (B+1);
    E_Q = B./ 2;
end

g_B =  E_Q./lambda + 10.*lambda^2 .* pi_B.^3 ./ C^2;

figure(1)
plot(alpha, f, 'r-s','LineWidth',2.5,'MarkerSize',8)
xlabel('\alpha','FontSize',18)
ylabel('f(\alpha)','FontSize',18)
title('randomilized policy, \lambda = ' + string(lambda) + ', C = ' + string(C) ,'FontSize',18)
grid on

figure(2)
plot(1-pi_B, g_B, 'b-s','LineWidth',2.5,'MarkerSize',8)
xlabel('B','FontSize',18)
ylabel('g(B)','FontSize',18)
title('threshold policy , \lambda = ' + string(lambda) + ', C = ' + string(C),'FontSize',18)
grid on

min_f = min(f)
min_g = min(g_B)

% figure(3)
% plot(1-pi_B, E_Q,'b','LineWidth',2.5)
% hold on
% plot(alpha, f,'r','LineWidth',2.5)
% legend('TB','RD')
% axis([0 1 0 10])

figure(4)
plot(alpha, f, 'r-s','LineWidth',2.5)
hold on
plot(1-pi_B, g_B, 'b-*','LineWidth',2.5)
legend('RD','TB')
axis([0 1 0 20])

