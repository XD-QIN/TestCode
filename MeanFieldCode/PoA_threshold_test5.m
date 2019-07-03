% price of anarchy
% self-optimiation vs overall
% thrshold based discrete B
% plot pi_B, B, PoA, 
clear
lambda = 6;
mu = 4; % local service rate
c = 10; %cost efficient
%k = .01:.01:100;
k=.01:.01:10000;
priceOfAnarchy = zeros(1, length(k));
priceOfAnarchy_cont = zeros(1, length(k));
priceOfAnarchy_cont_lower = zeros(1, length(k));
rho = lambda / mu;
B_g = zeros(1, length(k));
B_s = zeros(1, length(k));
piBs = zeros(1, length(k));
piBg = zeros(1, length(k));
ratio = zeros(1, length(k));

for i = 1 : length(k)
    if rho == 1
        W = 1/2;
    else
        W = rho/(1-rho) + rho/log(rho);
    end
    if k(i)*lambda^3/c^2 < W/3
%%%%%%%%%%%%% self-optimization Bs = 0 %%%%%%%%%%%%%
        T_u(1:3) = k(i) * lambda^2/c^2;
        B_s(1,i) = 0;
        piBs(1,i) = 1;
%%%%%%%%%%%%%%% overall B_g = 0 %%%%%%%%%%%%%%%%
        T_g(1:3) = k(i) * lambda^2/c^2;
        B_g(1,i) = 0;
        piBg(1,i) = 1;
        
    elseif (k(i)*lambda^3/c^2 >= W/3) && (k(i)*lambda^3/c^2 < W)
%%%%%%%%%%%%%%%% self-optimization  Bs = 0 %%%%%%%%%%%%%%
        T_u(1:3) = k(i) * lambda^2/c^2;
        B_s(1,i) = 0;
        piBs(1,i) = 1;
%%%%%%%%%%%%% overall optimization %%%%%%%%%%%%%%
        if rho == 1
            x_opt = (6*k(i)*lambda^3/c^2)^(1/4) - 1;
        else
            myfun = @(x) (3.*k(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
            x_opt = fzero(myfun, [-0.9 200]);
        end
        if x_opt < 0
            B(1) = 0;
            B(2) = 0;
            B(3) = 0;
            B_g(1,i) = 0;
            piBg(1,i) = 1;
        else
            %B = floor(x_opt):floor(x_opt)+1;
            B(1) = floor(x_opt);
            B(2) = floor(x_opt) + 1;
            B(3) = x_opt;
            %B = x_opt;
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
        if T_g(1) > T_g(2)
            B_g(1,i) = B(1);
            piBg(1,i) = pi_B(1);
        else
            B_g(1,i) = B(2);
            piBg(1,i) = pi_B(2);
        end
        
    else
 %%%%%%%%%%%%% self-optimization %%%%%%%%%%%%%%
        if rho == 1
            x_opt = (2*k(i)*lambda^3/c^2)^(1/4) - 1;
        else
            myfun1 = @(x) (k(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
            x_opt = fzero(myfun1, [-0.9 200]);
        end
        if x_opt < 0
            Bs(1) = 0;
            Bs(2) = 0;
            Bs(3) = 0;
            B_s(1,i) = 0;
            piBs(1,i) = 1;
        else
            %Bs = floor(x_opt):floor(x_opt)+1;
            %Bs = x_opt;
            Bs(1) = floor(x_opt);
            Bs(2) = floor(x_opt) + 1;
            Bs(3) = x_opt;
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
        if T_u(1) > T_u(2)
            B_s(1,i) = Bs(1);
            piBs(1,i) = pi_Bs(1);
        else
            B_s(1,i) = Bs(2);
            piBs(1,i) = pi_Bs(2);
        end
        
%%%%%%%%%%%%% overall optimization%%%%%%%%%%%%%
        if rho == 1
            x_opt = (6*k(i)*lambda^3/c^2)^(1/4) - 1;
        else
            myfun2 = @(x) (3.*k(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
            x_opt = fzero(myfun2, [-0.9 200]);
        end
        if x_opt < 0
            B(1) = 0;
            B(2) = 0;
            B(3) = 0;
            B_g(1,i) = 0;
            piBg(1,i) = 1;
        else
            B(1) = floor(x_opt);
            B(2) = floor(x_opt) + 1;
            B(3) = x_opt;
            %B = floor(x_opt):floor(x_opt)+1;
            %B = x_opt;
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
        if T_g(1) > T_g(2)
            B_g(1,i) = B(1);
            piBg(1,i) = pi_B(1);
        else
            B_g(1,i) = B(2);
            piBg(1,i) = pi_B(2);
        end
    end
    
%%%%%%%%%%%% price of anarchy %%%%%%%%%%%%%%%%%
    priceOfAnarchy(i) = 1 - min(T_g(1:2))/(T_u(1));
    priceOfAnarchy_cont(i) = 1 - T_g(3)/T_u(1);
    priceOfAnarchy_cont_lower(i) = 1 - min(T_g)/(T_u(3));
    ratio(i) = T_g(1) / T_g(2);
end

figure(1)
plot(k, ratio, 'r','LineWidth',2,'MarkerSize',2)
xlabel('k','FontSize',18)
ylabel('f(ceiling(x)) / f(floor(x))','FontSize',18)
title('threshold: \rho = ' + string(rho) + ', c = ' + string(c) + ', \lambda = ' + string(lambda) + ', \mu =' + string(mu),'FontSize',14)
set(gca,'fontsize',15)
axis([0 1e4 0.95 1.05])
grid on

% figure(1)
% plot(k, priceOfAnarchy, 'r','LineWidth',2,'MarkerSize',2)
% hold on
% % xlabel('k','FontSize',18)
% % ylabel('Price Of Anarchy','FontSize',18)
% % title('threshold: \rho = ' + string(rho) + ', c = ' + string(c) + ', \lambda = ' + string(lambda) + ', \mu =' + string(mu),'FontSize',14)
% % set(gca,'fontsize',15)
% % grid on
% % figure(2)
% plot(k, priceOfAnarchy_cont, 'b','LineWidth',2,'MarkerSize',2)
% % plot(k, priceOfAnarchy_cont_lower, 'k','LineWidth',2,'MarkerSize',2)
% % plot(W/3,0, 'b-o','LineWidth',2,'MarkerSize',8)
% %plot(W,0, 'r-s','LineWidth',2,'MarkerSize',8)
% %legend({'discrete B', 'continuous B'}, 'FontSize',14)
% xlabel('k','FontSize',18)
% ylabel('Price Of Anarchy-upper bound','FontSize',18)
% title('threshold: \rho = ' + string(rho) + ', c = ' + string(c) + ', \lambda = ' + string(lambda) + ', \mu =' + string(mu),'FontSize',14)
% set(gca,'fontsize',15)
% grid on

