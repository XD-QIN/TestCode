clear
lambda = 5;
mu = 4;
rho = lambda / mu;
k = 0.1 : .1 : 300;
c = 10;
k_example = 106;

v1 = zeros(1, length(k));
v2 = zeros(1, length(k));
x1 = zeros(1, length(k));
x2 = zeros(1, length(k));
x_opt = zeros(1, length(k));

for i = 1 : length(k)
    if rho == 1
        x_opt(i) = (2.*k(i).*lambda^3./c^2).^(1/4) - 1;
        x1(i) = floor(x_opt(i));
        if x1(i) < 0
            x1(i) = 0;
        end
        x2(i) = ceil(x_opt(i));
    else
        myfun1 = @(x) (k(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
        x_opt(i) = fzero(myfun1, [-0.9 200]);
        x1(i) = floor(x_opt(i));
        if x1(i) < 0
            x1(i) = 0;
        end
        x2(i) = ceil(x_opt(i));
    end
end


figure(11920)
plot(k, x1, 'r','LineWidth',2,'MarkerSize',2)
hold on
plot(k, x2, 'b','LineWidth',2,'MarkerSize',2)
plot(k, x_opt, 'k','LineWidth',2,'MarkerSize',2)
legend('\lfloor x^* \rfloor','\lceil x^* \rceil')
title('\rho = ' + string(rho) + ', c = ' + string(c) + ', k_{example} = ' + string(k_example), 'FontSize', 15)
xlabel('k')
ylabel('floor(x^*) & ceil(x^*)')
grid on