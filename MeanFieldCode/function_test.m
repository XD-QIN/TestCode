clear
k = 9000;
c = 10;
rho =  0.6;
lambda = rho;
delta = 0.001 ; % step

u = -1+delta  : delta : rho - 1;

a =  ( 3 * k * lambda^3 * (1 - rho)^3 ) / (c^2 * rho^3);
f = a .* (1 + 1./u).^2 + u./log(rho);
g = log(u+1)./log(rho);

figure(99)
plot(u,f,'r','LineWidth',2)
hold on
plot(u, g,'b','LineWidth',2)
plot(rho-1,1,'b-o','LineWidth',2, 'MarkerSize',5)
axis([-1.05 rho-1 0 max(g)])
legend({'polynomial','log'}, 'FontSize', 14)
xlabel('u', 'FontSize', 18)
ylabel('function', 'FontSize', 18)
title('\rho = ' + string(rho) +', k = ' + string(k) + ', c = ' + string(c), 'FontSize', 18)
grid on