
clear
lambda = 1;
mu = 3; % local service rate
c = 10; %cost efficient
k = 10;
rho = lambda/mu;
%x = 4;
x = -.5:.1:7;

y = (k.*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;

plot(x,y)
grid on