clear
lambda = 4;
mu = 4;
rho = lambda / mu;
k = 0.8 : .1 : 10;
c = 10;

x_opt = (2.*k.*lambda^3./c^2).^(1/4) - 1;
x1 = floor(x_opt);
x2 = ceil(x_opt);
v1 = (x1+1).^3 .*(x1+2)./2;
v2 = x2.*(x2+1).^3./2;

figure(11920)
plot(x1, v1, 'r','LineWidth',2,'MarkerSize',2)
hold on
plot(x1, v2, 'b','LineWidth',2,'MarkerSize',2)
legend('V_1(x)','V_2(x)')
