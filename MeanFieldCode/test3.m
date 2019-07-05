clear
lambda = 1;
mu = 1;
rho = lambda / mu;
k = 5000;
c = 10;

x_opt = (2*k*lambda^3/c^2)^(1/4) - 1; % fixed point 

%B = floor(x_opt);% : floor(x_opt) + 1;

B_t = 3;
B =  0 : .1 : 10;
T_u = (1/lambda).*(B/2) + (k*lambda^2/c^2).*(1/(B_t + 1))^2 .* (1./(B+1)); % object function

plot(B, T_u)
