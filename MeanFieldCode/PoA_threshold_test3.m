% price of anarchy
% self-optimiation vs overall
% thrshold based continuous B
clear
lambda = 5;
mu = 4; % local service rate
c = 10; %cost efficient
k = .01:.01:10;
priceOfAnarchy = zeros(1, length(k));
rho = lambda / mu;

for i = 1 : length(k)
    if rho == 1
        W = 1/2;
    else
        W = rho/(1-rho) + rho/log(rho);
    end
    if k(i)*lambda^3/c^2 < W/3
        % self-optimization Bs = 0
        T_u = k(i) * lambda^2/c^2;
        % overall B_g = 0
        T_g = k(i) * lambda^2/c^2;
    elseif (k(i)*lambda^3/c^2 >= W/3) && (k(i)*lambda^3/c^2 < W)
        % self-optimization  Bs = 0
        T_u = k(i) * lambda^2/c^2;
        % overall optimization
        if rho == 1
            x_opt = (6*k(i)*lambda^3/c^2)^(1/4) - 1;
        else
            myfun = @(x) (3.*k(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
            x_opt = fzero(myfun, [-0.9 200]);
        end
        if x_opt < 0
            B = 0;
        else
            %B = floor(x_opt):floor(x_opt)+1;
            B = x_opt;
        end
        if rho ~= 1
            pi_0 = (1 - rho)./(1 - rho.^(B+1));
            pi_B = (rho.^B - rho.^(B+1))./(1 - rho.^(B+1));
            E_Q = pi_0 .* rho .* ( 1 - rho.^B)./(1-rho).^2 - B .* rho.^(B+1).*pi_0 ./ (1 - rho);
            E_Q1 = (B+1)./(rho.^(B+1) - 1) + B + 1/(1 - rho);
        else
            pi_B = 1 ./ (B+1);
            E_Q = B./ 2;
        end
        T_g  =  E_Q./lambda + k(i).*lambda^2 .* pi_B.^3 ./ c^2;
    else
        % self-optimization
        if rho == 1
            x_opt = (2*k(i)*lambda^3/c^2)^(1/4) - 1;
        else
            myfun1 = @(x) (k(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
            x_opt = fzero(myfun1, [-0.9 200]);
        end
        if x_opt < 0
            Bs = 0;
        else
            %Bs = floor(x_opt):floor(x_opt)+1;
            Bs = x_opt;
        end
        if rho ~= 1
            pi_0s = (1 - rho)./(1 - rho.^(Bs+1));
            pi_Bs = (rho.^Bs - rho.^(Bs+1))./(1 - rho.^(Bs+1));
            E_Qs = pi_0s .* rho .* ( 1 - rho.^Bs)./(1-rho).^2 - Bs .* rho.^(Bs+1).*pi_0s ./ (1 - rho);
            E_Q1 = (Bs + 1)./(rho.^(Bs+1) - 1) + Bs + 1/(1 - rho);
        else
            pi_Bs = 1 ./ (Bs+1);
            E_Qs = Bs./ 2;
        end
        T_u  =  E_Qs./lambda + k(i).*lambda^2 .* pi_Bs.^3 ./ c^2;
        
        % overall optimization
        if rho == 1
            x_opt = (6*k(i)*lambda^3/c^2)^(1/4) - 1;
        else
            myfun2 = @(x) (3.*k(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
            x_opt = fzero(myfun2, [-0.9 200]);
        end
        if x_opt < 0
            B = 0;
        else
            %B = floor(x_opt):floor(x_opt)+1;
            B = x_opt;
        end
        if rho ~= 1
            pi_0 = (1 - rho)./(1 - rho.^(B+1));
            pi_B = (rho.^B - rho.^(B+1))./(1 - rho.^(B+1));
            E_Q = pi_0 .* rho .* ( 1 - rho.^B)./(1-rho).^2 - B .* rho.^(B+1).*pi_0 ./ (1 - rho);
            E_Q1 = (B+1)./(rho.^(B+1) - 1) + B + 1/(1 - rho);
        else
            pi_B = 1 ./ (B+1);
            E_Q = B./ 2;
        end
        T_g  =  E_Q./lambda + k(i).*lambda^2 .* pi_B.^3 ./ c^2;
    end
    % price of anarchy
    priceOfAnarchy(i) = 1 - min(T_g)/min(T_u);
end

figure(3552865)
plot(k, priceOfAnarchy, 'r','LineWidth',2,'MarkerSize',2)
hold on
plot(W/3,0, 'b-o','LineWidth',2,'MarkerSize',8)
plot(W,0, 'r-s','LineWidth',2,'MarkerSize',8)
xlabel('k','FontSize',18)
ylabel('Price Of Anarchy','FontSize',18)
title('threshold: \rho = ' + string(rho) + ', c = ' + string(c) + ', \lambda = ' + string(lambda) + ', \mu =' + string(mu),'FontSize',14)
set(gca,'fontsize',15) 
grid on