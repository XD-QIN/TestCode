clear
lambda = 4;
mu = 4;
rho = lambda / mu;
k = 320;
c = 10;


x_opt = (2*k*lambda^3/c^2)^(1/4) - 1;

B = 0 : .1  : 8;
% given x*
f1 = (1/lambda) .* (B./2) + k*lambda^2/c^2 .*(1/(x_opt+1))^2 .* (1./(B+1));
f1_x = (1/lambda) .* (x_opt./2) + k*lambda^2/c^2 .*(1/(x_opt+1))^2 .* (1./(x_opt+1));

% given x_floor
f2 = (1/lambda) .* (B./2) + k*lambda^2/c^2 .*(1/(floor(x_opt)+1))^2 .* (1./(B+1));
x2 = floor(x_opt):ceil(x_opt);
f2_x = (1/lambda) .* (x2./2) + k*lambda^2/c^2 .*(1/(floor(x_opt)+1))^2 .* (1./(x2+1));
[y2, index2] = min(f2_x);

% given x_ceiling
f3 = (1/lambda) .* (B./2) + k*lambda^2/c^2 .*(1/(floor(x_opt)+1+1))^2 .* (1./(B+1));
x3 = floor(x_opt):ceil(x_opt);
f3_x = (1/lambda) .* ((x3)./2) + k*lambda^2/c^2 .*(1/(floor(x_opt)+1+1))^2 .* (1./((x3)+1));
[y3, index3] = min(f3_x);

figure(887)
plot(B, f1, 'r','LineWidth',2,'MarkerSize',2)
hold on
plot(B, f2, 'b','LineWidth',2,'MarkerSize',2)
plot(B, f3, 'k','LineWidth',2,'MarkerSize',2)

plot(x_opt, f1_x, 'r-o','LineWidth',2,'MarkerSize',8)
plot(x2(index2), y2, 'b-s','LineWidth',2,'MarkerSize',8)
plot(x3(index3), y3, 'k-+','LineWidth',2,'MarkerSize',8)
title('\rho = ' + string(rho) + ', k = ' + string(k) + ', c = ' + string(c), 'FontSize', 15)
legend({'given x^* = ' + string(x_opt), 'given \lfloor {x^*} \rfloor = ' + string(floor(x_opt)), 'given \lceil x^*\rceil =' + string(ceil(x_opt))}, 'FontSize', 16)
grid on