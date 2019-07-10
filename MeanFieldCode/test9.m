clear
lambda = 4;
mu = 4;
rho = lambda / mu;
k = 50;
c = 10;


x_opt = (2*k*lambda^3/c^2)^(1/4) - 1;

B = 0 : .1  : 8;
% given x*
f1 = (1/lambda) .* (B./2) + k*lambda^2/c^2 .*(1/(x_opt+1))^2 .* (1./(B+1));
f1_x = (1/lambda) .* (x_opt./2) + k*lambda^2/c^2 .*(1/(x_opt+1))^2 .* (1./(x_opt+1));

% given x_floor
f2 = (1/lambda) .* (B./2) + k*lambda^2/c^2 .*(1/(floor(x_opt)+1))^2 .* (1./(B+1));
f2_x = (1/lambda) .* (floor(x_opt)./2) + k*lambda^2/c^2 .*(1/(floor(x_opt)+1))^2 .* (1./(floor(x_opt)+1));

% given x_ceiling
f3 = (1/lambda) .* (B./2) + k*lambda^2/c^2 .*(1/(floor(x_opt)+1+1))^2 .* (1./(B+1));
f3_x = (1/lambda) .* ((floor(x_opt)+1)./2) + k*lambda^2/c^2 .*(1/((floor(x_opt)+1)+1))^2 .* (1./((floor(x_opt)+1)+1));

figure(887)
plot(B, f1, 'r','LineWidth',2,'MarkerSize',2)
hold on
plot(B, f2, 'b','LineWidth',2,'MarkerSize',2)
plot(B, f3, 'k','LineWidth',2,'MarkerSize',2)

plot(x_opt, f1_x, 'r-o','LineWidth',2,'MarkerSize',8)
plot(floor(x_opt), f2_x, 'b-s','LineWidth',2,'MarkerSize',8)
plot(floor(x_opt)+1, f3_x, 'k-+','LineWidth',2,'MarkerSize',8)

legend({'given x^*', 'given \lfloor {x^*} \rfloor', 'given \lceil x^*\rceil'}, 'FontSize', 16)
grid on