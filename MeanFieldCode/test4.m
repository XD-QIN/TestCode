clear
lambda = 1;
mu = 1;
rho = lambda / mu;
k = 100000;
c = 10;

% continuous B
B_t_c = 0 : .001 : 10;
B =  0 : .001 : 50;
B_opt_c = zeros(1 , length(B_t_c));
for i  =  1 : length(B_t_c)
    T_u = (1/lambda).*(B/2) + (k*lambda^2/c^2).*(1/(B_t_c(i) + 1))^2 .* (1./(B+1)); % object function
    [x, index] = min(T_u);
    B_opt_c(i) = B(index);
end

% discrete B
x_opt = (2*k*lambda^3/c^2)^(1/4) - 1; % fixed point
B_t_d = 0 : 1 : 10; %give B_tilde
B_opt_d = zeros(1, length(B_t_d)); % the optimal B given B_tilde
for j = 1 : length(B_t_d)
    if (2*k*lambda^3/c^2)^(1/2) / (B_t_d(j) + 1) - 1 > 0
        B_opt_d(j) = (2*k*lambda^3/c^2)^(1/2) / (B_t_d(j) + 1) - 1;
        B_opt1 = floor(B_opt_d(j)): floor(B_opt_d(j))+1;
        T_u = (1/lambda).*(B_opt1./2) + (k*lambda^2/c^2).*(1/(B_t_d(j) + 1))^2 .* (1./(B_opt1+1));
        if T_u(1) > T_u(2)
            B_opt_d(j) = B_opt1(2);
        else
            B_opt_d(j) = B_opt1(1);
        end
    else
        B_opt_d(j) = 0;
    end
end

plot(B_t_d, B_opt_d, 'rs', 'LineWidth', 2, 'MarkerSize', 8)
hold on
plot(B_t_c, B_opt_c, 'b', 'LineWidth', 2, 'MarkerSize', 2)
plot(x_opt, x_opt, 'ko',  'LineWidth', 2, 'MarkerSize', 8)
legend({'discrete B','continuous B','fixed point x'}, 'FontSize', 15)
xlabel('B_t')
ylabel('B_{opt}')
grid on