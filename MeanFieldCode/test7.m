% Lipschitz Function test overall optimization
clear
lambda = 1;
mu = 4;
rho = lambda / mu;
k = 10;
c = 10;
B = 0 : .1 : 20;

if rho ~= 1
    d_T_g = rho.^B .*(c^2*rho.*(rho.^(B+1)-1).^3 -...
        log(rho).*((B+1).*c^2.*rho.*(rho.^(B+1)-1).^2 +...
        3*k*lambda^3*(rho-1)^3.*rho.^(2*B)))./(c^2*lambda.*(rho.^(B+1)-1).^4);
else
    d_T_g = 1/(2*lambda) - 3*k*lambda^3/c^2 .* (1./(B+1)).^4;
end

figure(1)
plot(B, d_T_g, 'r', 'LineWidth', 2, 'MarkerSize', 2)
grid on