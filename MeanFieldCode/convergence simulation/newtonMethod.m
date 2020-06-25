% convergence using h function
clear
lambda = 6;
mu = 4;
rho = lambda/ mu;
k = 40;
c = 10;
a = k * lambda^3 * (1 - rho)^3 / (c^2 * rho^3);
b = 1/log(rho);

h = @(u) a * (1 + 1 / u)^2 + b * u - log(u+1)/log(rho);
h_prime = @(u) b * u / (1 + u) - 2 * a * (u + 1)/ u^3;

u = 2;
u_previous = 3;
count = 0;

while abs(u - u_previous) > 1e-5
    u_track(count+1) = u;
    u_previous = u;
    u = u - h(u)/h_prime(u);
    count = count + 1;
end

B = log(u+1)/log(rho)-1;

plot(u_track)