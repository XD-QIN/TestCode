
clear
mu = 1; % local service rate
c = 10; %cost efficient
k = 10;
lambda = 4;
rho = lambda/mu;

x = 0:.1:.5;

y = (k.*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;

plot(x,y)