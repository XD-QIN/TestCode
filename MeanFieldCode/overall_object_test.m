% threshold based policy 
% overall optimization 
% object function test
clear
lambda = .2;
mu = 1;
c  =  10;
k = 600;

rho = lambda / mu; 
b = 5;
a = ((rho.^b-rho.^(b+1))./(1-rho.^(b+1))).^2;

B = 0 : .1 : 5;
if rho ~= 1
 Tg = 1/lambda .*((B+1)./(rho.^(B+1)-1) + B + 1/(1-rho) ) + k*lambda^2/c^2 .* a.* ((rho.^B-rho.^(B+1))./(1-rho.^(B+1)));
end

min(Tg)

figure(20)
plot(B, Tg,'r-s','LineWidth',2,'MarkerSize',2)
xlabel('threshold B','FontSize', 18)
ylabel('cost function T_g(B)', 'FontSize', 18)
title('\lambda = ' + string(lambda) + ', \mu = ' + string(mu) + ', c = ' + string(c) + ', k = ' + string(k) ,'FontSize',18)