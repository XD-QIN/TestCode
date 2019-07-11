%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% ceil NE self-optimization %%%%%%%
%%%%%%%            PoA             %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
lambda = 4;
mu = 4;
rho = lambda / mu;
k = 0.1 : .1 : 300;
c = 10;
count  = 0;

v1 = zeros(1, length(k));
v2 = zeros(1, length(k));
x1 = zeros(1, length(k));
x2 = zeros(1, length(k));

for i = 1 : length(k)
    if rho == 1
        x_opt = (2.*k(i).*lambda^3./c^2).^(1/4) - 1;
        x1(i) = floor(x_opt);
        x2(i) = ceil(x_opt);
        v1(i) = (x1(i)+1).^3 .*(x1(i)+2)./2;
        v2(i) = x2(i).*(x2(i)+1).^3./2;
    else
        myfun1 = @(x) (k(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
        x_opt = fzero(myfun1, [-0.9 200]);
        x1(i) = floor(x_opt);
        x2(i) = ceil(x_opt);
        v1(i) = (1 - rho.^(x1(i)+1)).^2.*(x1(i)+1-(x1(i)+2).*rho+rho.^(x1(i)+2))./(rho.^(2.*x1(i)-1) .* (1-rho)^4);
        v2(i) = (1 - rho.^(x2(i)+1)).^2.*(x2(i) -(x2(i)+1).*rho+rho.^(x2(i)+1))./(rho.^(2.*x2(i)-1) .* (1-rho)^4);
    end
end

for j = 1 : length(v1)
    if (x1(j) == 2)
        index_start = j;
        break
    end
end

for j = 1 : length(v1)
    if (x1(j) == 3)
        index_end = j-1;
        break
    end
end

for m = index_start : index_end
    if (k(m)*lambda^3/c^2 > v2(m))
        ceil_start = m;
        break
    end
end

k_ceil = k(ceil_start : index_end);

% price of anarchy
% self-optimiation vs overall
% thrshold based discrete B
% plot pi_B, B, PoA, 

priceOfAnarchy_ceil = zeros(1, length(k_ceil));
B_g = zeros(1, length(k_ceil));
B_s = zeros(1, length(k_ceil));
piBs = zeros(1, length(k_ceil));
piBg = zeros(1, length(k_ceil));
ratio = zeros(1, length(k_ceil));

for i = 1 : length(k_ceil)
    if rho == 1
        W = 1/2;
    else
        W = rho/(1-rho) + rho/log(rho);
    end
    if k_ceil(i)*lambda^3/c^2 < W/3
%%%%%%%%%%%%% self-optimization Bs = 0 %%%%%%%%%%%%%
        T_u(1:3) = k_ceil(i) * lambda^2/c^2;
        B_s(1,i) = 0;
        piBs(1,i) = 1;
%%%%%%%%%%%%%%% overall B_g = 0 %%%%%%%%%%%%%%%%
        T_g(1:3) = k_ceil(i) * lambda^2/c^2;
        B_g(1,i) = 0;
        piBg(1,i) = 1;
        
    elseif (k_ceil(i)*lambda^3/c^2 >= W/3) && (k_ceil(i)*lambda^3/c^2 < W)
%%%%%%%%%%%%%%%% self-optimization  Bs = 0 %%%%%%%%%%%%%%
        T_u(1:3) = k_ceil(i) * lambda^2/c^2;
        B_s(1,i) = 0;
        piBs(1,i) = 1;
%%%%%%%%%%%%% overall optimization %%%%%%%%%%%%%%
        if rho == 1
            x_opt = (6*k_ceil(i)*lambda^3/c^2)^(1/4) - 1;
        else
            myfun = @(x) (3.*k_ceil(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
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
        T_g  =  E_Q./lambda + k_ceil(i).*lambda^2 .* pi_B.^3 ./ c^2;
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
            x_opt = (2*k_ceil(i)*lambda^3/c^2)^(1/4) - 1;
        else
            myfun1 = @(x) (k_ceil(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
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
        T_u  =  E_Qs./lambda + k_ceil(i).*lambda^2 .* pi_Bs.^3 ./ c^2;

        
%%%%%%%%%%%%% overall optimization%%%%%%%%%%%%%
        if rho == 1
            x_opt = (6*k_ceil(i)*lambda^3/c^2)^(1/4) - 1;
        else
            myfun2 = @(x) (3.*k_ceil(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
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
        T_g  =  E_Q./lambda + k_ceil(i).*lambda^2 .* pi_B.^3 ./ c^2;
    end
    
%%%%%%%%%%%% price of anarchy - floor NE %%%%%%%%%%%%%%%%%
%%% 1-floor, 2-ceil, 3-continuous
    priceOfAnarchy_ceil(i) = 1 - min(T_g(1:2))/(min(T_u(2)));
    ratio(i) = T_u(1) / T_u(2);
end

figure(22322)
plot(k_ceil.*lambda^3./c^2, priceOfAnarchy_ceil, 'b','LineWidth',2,'MarkerSize',2)
xlabel('k\lambda^3/c^2','FontSize', 15)
ylabel('PoA','FontSize', 15)
title('PoA (Ceiling NE): \rho = ' + string(rho) + ', c = ' + string(c), 'FontSize', 15)

