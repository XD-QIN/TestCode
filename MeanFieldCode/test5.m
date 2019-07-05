clear
lambda = 1;
mu = 1;
rho = lambda / mu;
k = 10000;
c = 10;

x_opt = (2*k*lambda^3/c^2)^(1/4) - 1; % fixed point 
% B = floor(x_opt);% : floor(x_opt) + 1;

B_t_c = 1;
B =  0 : .1 : 50;
B_opt_c = zeros(1 , length(B_t_c));

T_u = (1/lambda).*(B/2) + (k*lambda^2/c^2).*(1/(B_t_c + 1))^2 .* (1./(B+1)); % object function


plot(B, T_u, 'b', 'LineWidth', 2, 'MarkerSize', 2)

