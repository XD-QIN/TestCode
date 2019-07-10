% self-optimization 
% relation of B-tilde and B* test
clear
lambda = 4;
mu = 4;
rho = lambda / mu;
k = 450;
c = 10;

if rho ~= 1
    myfun1 = @(x) (k.*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
    x_opt = fzero(myfun1, [-0.9 200]);
else
    x_opt = (2*k*lambda^3/c^2)^(1/4) - 1;
end

B_t_c = 0 : .1 : 10;
B =  0 : .01 : 150;
B_opt_c = zeros(1 , length(B_t_c));
for i  =  1 : length(B_t_c)
    % continuous
    if rho ~= 1
        T_u = (1/lambda).* ((B+1)./(rho.^(B+1)-1)+B+1/(1-rho)) + ...
            k*lambda^2/c^2 .*((rho.^B_t_c(i)-rho.^(B_t_c(i)+1))./(1-rho.^(B_t_c(i)+1))).^2 .* (rho.^B - rho.^(B+1))./(1-rho.^(B+1)); % object function
    else
        T_u = (1/lambda).* B./2 + k*lambda^2/c^2 .*(1./ (B_t_c(i) + 1)).^2 .* (1./(B+1));
    end
    [y, index] = min(T_u);
    B_opt_c(i) = B(index);
end

% discrete
B_t_d = 0 : 1 : 10;
B_d = 0 : 1 : 150;
B_opt_d = zeros(1, length(B_t_d));
for j = 1 : length(B_t_d)
    if rho ~= 1
    T_u_d = (1/lambda).* ((B_d+1)./(rho.^(B_d+1)-1)+B_d+1/(1-rho)) + ...
        k*lambda^2/c^2 .*((rho.^B_t_d(j)-rho.^(B_t_d(j)+1))./(1-rho.^(B_t_d(j)+1))).^2 .* (rho.^B_d - rho.^(B_d+1))./(1-rho.^(B_d+1));
    else
        T_u_d = (1/lambda).* B_d./2 + k*lambda^2/c^2 .*(1./ (B_t_d(j) + 1)).^2 .* (1./(B_d+1));
    end
   [z, index_d] = min(T_u_d);
   B_opt_d(j) = B_d(index_d);
   if B_t_d(j) == B_opt_d(j)
       B_fixed = B_t_d(j);
   end
   
end
figure(5829221)
plot(B_t_c, B_opt_c, 'r', 'LineWidth', 2, 'MarkerSize', 2)
hold on
plot(B_t_d, B_opt_d, 'bs', 'LineWidth', 2, 'MarkerSize', 8)
plot(x_opt, x_opt, 'ko', 'LineWidth', 2, 'MarkerSize', 8)
legend({'continuous B','discrete B','fixed point x'}, 'FontSize', 15)
xlabel('given B_t', 'FontSize', 15)
ylabel('the best response B_{opt}','FontSize', 15)
title('\rho = ' + string(rho) + ', k = ' + string(k) + ', c = ' + string(c), 'FontSize', 15)
grid on 