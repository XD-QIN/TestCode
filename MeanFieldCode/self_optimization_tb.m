clear
lambda = 2;
mu = 4; % local service rate
c = 10; %cost efficient
%k = .01:.01:100;
k=1:1:1e7;
rho = lambda / mu;
B_s = zeros(1, length(k));
piBs = zeros(1, length(k));
ratio = zeros(1, length(k));

for i = 1 : length(k)
    if rho == 1
        W = 1/2;
    else
        W = rho/(1-rho) + rho/log(rho);
    end
    if k(i)*lambda^3/c^2 < W
        %%%%%%%%%%%%% self-optimization Bs = 0 %%%%%%%%%%%%%
        T_u(1:3) = k(i) * lambda^2/c^2;
        B_s(1,i) = 0;
        piBs(1,i) = 1;
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
        T_u(1) =  E_Qs(1)./lambda + k(i).*lambda^2 .* pi_Bs(1).^2 .* pi_Bs(2) ./ c^2;  % everyone else floor, one user ceiling
        T_u(2) =  E_Qs(1)./lambda + k(i).*lambda^2 .* pi_Bs(1).^2 .* pi_Bs(1) ./ c^2;  % everyone else floor, one user also floor   
    end
    
    ratio(i) = T_u(1) / T_u(2);
end


figure(11)
plot(k, ratio, 'r','LineWidth',2,'MarkerSize',2)
xlabel('k','FontSize',18)
ylabel('f(ceiling(x)) / f(floor(x))','FontSize',18)
title('threshold self-optimization: \rho = ' + string(rho),'FontSize',9)
set(gca,'fontsize',15)
%axis([0 1e4 0.95 1.05])
grid on