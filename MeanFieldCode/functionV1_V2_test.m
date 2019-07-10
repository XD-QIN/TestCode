clear
lambda = 5;
mu = 4;
rho = lambda / mu;
k = 0.8 : .1 : 1000;
c = 10;
k_example = 450;

v1 = zeros(1, length(k));
v2 = zeros(1, length(k));

for i = 1 : length(k)
    if rho == 1
        x_opt = (2.*k(i).*lambda^3./c^2).^(1/4) - 1;
        x1 = floor(x_opt);
        x2 = ceil(x_opt);
        v1(i) = (x1+1).^3 .*(x1+2)./2;
        v2(i) = x2.*(x2+1).^3./2;
    else
        myfun1 = @(x) (k(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
        x_opt = fzero(myfun1, [-0.9 200]);
        x1 = floor(x_opt);
        x2 = ceil(x_opt);
        v1(i) = (1 - rho.^(x1+1)).*(x1+1-(x1+2).*rho+rho.^(x1+2))./(rho.^(2.*x1-1) .* (1-rho)^4);
        v2(i) = (1 - rho.^(x2+1)).*(x2 -(x2+1).*rho+rho.^(x2+1))./(rho.^(2.*x1-1) .* (1-rho)^4);
    end
end


figure(11920)
plot(k, v1, 'r','LineWidth',2,'MarkerSize',2)
hold on
plot(k, v2, 'b','LineWidth',2,'MarkerSize',2)
plot(k, k.*lambda^3./c^2, 'k','LineWidth',2,'MarkerSize',2)
plot(k_example, k_example.*lambda^3./c^2,'k-o','LineWidth',2,'MarkerSize',8)
legend('V_1(x)','V_2(x)', 'k\lambda^3/c^2')
title('\rho = ' + string(rho) + ', c = ' + string(c) + ', k_{example} = ' + string(k_example), 'FontSize', 15)
xlabel('k')
ylabel('V_1(x) & V_2(x)')