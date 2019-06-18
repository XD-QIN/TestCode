% randomized policy 
% self-optimal vs social-optimal price of anarchy
clear
mu = 5; % local service rate
%lambda = 0.01:0.01:1.99; % arrival rate
c = 10; %global server efficient
k = 10;
delta = 0.01; % step size

l = 1/mu + delta : delta : k-delta;
lambda = sqrt(l./k).*c;
% l =  C * (1 / ( 3 * mu * k))^(1/2);
% lambda = l : 0.01 : l+5;

priceOfAnarchy = zeros(1, length(lambda));
x = zeros(1, length(lambda));

for i = 1 : length(lambda)
    %self-optimal
    J_u = 0;
    alpha1 = (k^(1/4)*(lambda(i)+mu) - (4*c*sqrt(mu) + sqrt(k)*(lambda(i)-mu)^2 )^(1/2))/(2*k^(1/4)*lambda(i));
    alpha2 = (k^(1/4)*(lambda(i)+mu) + (4*c*sqrt(mu) + sqrt(k)*(lambda(i)-mu)^2 )^(1/2))/(2*k^(1/4)*lambda(i));
    if alpha2 > 1 && alpha1 < 1
        J_u = alpha1./(mu - alpha1.*lambda(i)) + k.*lambda(i)^2 .* (1 - alpha1).^3 ./ c^2; %object function
    end
    
    %global optimal
    alpha = 0 : 0.001 : min(1, mu/lambda(i));
    J_g = alpha./(mu - alpha.*lambda(i)) + k.*lambda(i)^2 .* (1 - alpha).^3 ./ c^2; %object function
    
    priceOfAnarchy(i) = 1 - min(J_g)/J_u;
    x(i) = k * (lambda(i)/c)^2;
end

figure(1)
plot(l, priceOfAnarchy, 'r','LineWidth',2,'MarkerSize',2)
xlabel(' k(\lambda/c)^2','FontSize',18)
ylabel('Price Of Anarchy','FontSize',18)
title('randomized policy, \mu = ' + string(mu) + ', c = ' + string(c) + ', k = ' + string(k) ,'FontSize',18)
set(gca,'fontsize',15) 
grid on