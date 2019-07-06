clear
lambda = 6;
mu = 4;
rho = lambda / mu;
k = 100;
c = 10;

myfun1 = @(x) (k.*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
x_opt = fzero(myfun1, [-0.9 200]);

B_t_c = 0 : .1 : 20;
B =  0 : .01 : 150;
B_opt_c = zeros(1 , length(B_t_c));
for i  =  1 : length(B_t_c)
    % continuous
    T_g = (1/lambda).* ((B+1)./(rho.^(B+1)-1)+B+1/(1-rho)) + ...
        k*lambda^2/c^2 .*((rho.^B_t_c(i)-rho.^(B_t_c(i)+1))./(1-rho.^(B_t_c(i)+1))).^2 .* (rho.^B - rho.^(B+1))./(1-rho.^(B+1)); % object function
    [y, index] = min(T_g);
    B_opt_c(i) = B(index);
    
   
end

% discrete
B_t_d = 0 : 1 : 20;
B_d = 0 : 1 : 150;
B_opt_d = zeros(1, length(B_t_d));
for j = 1 : length(B_t_d)
    T_g_d = (1/lambda).* ((B_d+1)./(rho.^(B_d+1)-1)+B_d+1/(1-rho)) + ...
        k*lambda^2/c^2 .*((rho.^B_t_d(j)-rho.^(B_t_d(j)+1))./(1-rho.^(B_t_d(j)+1))).^2 .* (rho.^B_d - rho.^(B_d+1))./(1-rho.^(B_d+1));
   [z, index_d] = min(T_g_d);
   B_opt_d(j) = B_d(index_d);
end
figure(89757)
plot(B_t_c, B_opt_c, 'r', 'LineWidth', 2, 'MarkerSize', 2)
hold on
plot(x_opt, x_opt, 'k-o', 'LineWidth', 2, 'MarkerSize', 8)
plot(B_t_d, B_opt_d, 'bs', 'LineWidth', 2, 'MarkerSize', 8)
xlabel('B_t')
ylabel('B_{opt}')
grid on 