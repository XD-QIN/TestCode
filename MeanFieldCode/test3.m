clear
lambda = 1;
mu = 1;
rho = lambda / mu;
k = 10000;
c = 10;

x_opt = (2*k*lambda^3/c^2)^(1/4) - 1; % fixed point 
% B = floor(x_opt);% : floor(x_opt) + 1;

B_t_c = 0 : .001 : 10;
B =  0 : .001 : 50;
B_opt_c = zeros(1 , length(B_t_c));
for i  =  1 : length(B_t_c)
    T_u = (1/lambda).*(B/2) + (k*lambda^2/c^2).*(1/(B_t_c(i) + 1))^2 .* (1./(B+1)); % object function
    [x, index] = min(T_u);
    B_opt_c(i) = B(index);
end

B_opt_theory = zeros(1, length(B_t_c));
for j = 1 : length(B_t_c)
    if (2*k*lambda^3/c^2)^(1/2) / (B_t_c(j) + 1) - 1 > 0
        B_opt_theory(j) = (2*k*lambda^3/c^2)^(1/2) / (B_t_c(j) + 1) - 1;
    else
        B_opt_theory(j) = 0;
    end
end

plot(B_t_c, B_opt_c, 'b', 'LineWidth', 2, 'MarkerSize', 2)
hold on
%plot(B_t, B_opt_theory, 'k', 'LineWidth', 2, 'MarkerSize', 2)
plot(x_opt, x_opt, 'k-o',  'LineWidth', 2, 'MarkerSize', 8)
xlabel('B_t')
ylabel('B_{opt}')
grid on