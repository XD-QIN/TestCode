% price of anarchy
% self-optimiation vs overall
% thrshold based
clear
mu = 3.7; % local service rate
c = 10; %cost efficient
k = 10;
delta = 0.01; % step size
v = 0 + delta : delta : k*c-delta;
lambda = (v .* c^2./k).^(1/3);
priceOfAnarchy = zeros(1, length(lambda));
%x = zeros(1, length(lambda));
rho = zeros(1, length(lambda));

for i = 1 : length(v)
    rho(i) = lambda(i) / mu;
    if rho(i) == 1
        W = 1/2;
    else
        W = rho(i)/(1-rho(i)) + rho(i)/log(rho(i));
    end
    if v(i) < W/3
        % self-optimal Bs = 0
        T_u = k * lambda(i)^2/c^2;
        % overall B_g = 0
        T_g = k * lambda(i)^2/c^2;
    elseif (v(i) >= W/3) && (v(i) < W)
        % self-optimal  Bs = 0
        T_u = k * lambda(i)^2/c^2;
        % overall
        B = 0 : 1 : 100;
        if rho(i) ~= 1
            pi_0 = (1 - rho(i))./(1 - rho(i).^(B+1));
            pi_B = (rho(i).^B - rho(i).^(B+1))./(1 - rho(i).^(B+1));
            E_Q = pi_0 .* rho(i) .* ( 1 - rho(i).^B)./(1-rho(i)).^2 - B .* rho(i).^(B+1).*pi_0 ./ (1 - rho(i));
            E_Q1 = (B+1)./(rho(i).^(B+1) - 1) + B + 1/(1 - rho(i));
        else
            pi_B = 1 ./ (B+1);
            E_Q = B./ 2;
        end
        T_g  =  E_Q./lambda(i) + k.*lambda(i)^2 .* pi_B.^3 ./ c^2;
    else
        % self-optimal
        if rho(i) == 1
            x_opt = (2*k*lambda(i)^3/c^2)^(1/4) - 1;
        else
            myfun = @(x) (k.*lambda(i).^3.*(1-rho(i)).^3./(c.^2.*rho(i).^3)).*(1 + 1./(rho(i).^(x+1)-1)).^2 + (rho(i).^(x+1)-1)./log(rho(i)) - x - 1;
            x_opt = fzero(myfun, [0 100]);
        end
        if x_opt < 0
            Bs = 0;
        else
            Bs = floor(x_opt):floor(x_opt)+1;
        end
        if rho(i) ~= 1
            pi_0s = (1 - rho(i))./(1 - rho(i).^(Bs+1));
            pi_Bs = (rho(i).^Bs - rho(i).^(Bs+1))./(1 - rho(i).^(Bs+1));
            E_Qs = pi_0s .* rho(i) .* ( 1 - rho(i).^Bs)./(1-rho(i)).^2 - Bs .* rho(i).^(Bs+1).*pi_0s ./ (1 - rho(i));
            E_Q1 = (Bs + 1)./(rho(i).^(Bs+1) - 1) + Bs + 1/(1 - rho(i));
        else
            pi_Bs = 1 ./ (Bs+1);
            E_Qs = Bs./ 2;
        end
        T_u  =  E_Qs./lambda(i) + k.*lambda(i)^2 .* pi_Bs.^3 ./ c^2;
        
        % overall optimization
        B = 0 : 1 : 1000;
        if rho(i) ~= 1
            pi_0 = (1 - rho(i))./(1 - rho(i).^(B+1));
            pi_B = (rho(i).^B - rho(i).^(B+1))./(1 - rho(i).^(B+1));
            E_Q = pi_0 .* rho(i) .* ( 1 - rho(i).^B)./(1-rho(i)).^2 - B .* rho(i).^(B+1).*pi_0 ./ (1 - rho(i));
            E_Q1 = (B+1)./(rho(i).^(B+1) - 1) + B + 1/(1 - rho(i));
        else
            pi_B = 1 ./ (B+1);
            E_Q = B./ 2;
        end
        T_g  =  E_Q./lambda(i) + k.*lambda(i)^2 .* pi_B.^3 ./ c^2;
    end
    priceOfAnarchy(i) = 1 - min(T_g)/min(T_u);
end

figure(1)
plot(lambda, priceOfAnarchy, 'r','LineWidth',2,'MarkerSize',2)
hold on
xlabel('\lambda','FontSize',18)
ylabel('Price Of Anarchy','FontSize',18)
title('threshold-based policy, \mu = ' + string(mu) + ', c = ' + string(c) + ', k = ' + string(k) ,'FontSize',18)
set(gca,'fontsize',15) 
grid on