% Lipschitz Function test self-optimization
clear
lambda = 7;
mu = 4;
rho = lambda / mu;
k = 100;
c = 10;
B_t = 5; % given B_tilde

myfun1 = @(x) (k.*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
x_opt = fzero(myfun1, [-0.9 200]);

B =  0 : .1 : 20;

if rho ~= 1
    d_T_u = rho.^B./(lambda.*(rho.^(B+1)-1).^2) .*...
        (-k*lambda^3*(rho-1)^3*rho^(2*B_t)*log(rho)/(c^2*(rho^(B_t+1)-1)^2)+...
         rho.*(rho.^(B+1)-1)-(B+1).*rho.*log(rho));
else
    d_T_u = 1/(2*lambda) - k*lambda^2/c^2 * (1/(B_t+1))^2 .*(1./(B+1)).^2;
end

figure(1)
plot(B, d_T_u, 'r', 'LineWidth', 2, 'MarkerSize', 2)
grid on