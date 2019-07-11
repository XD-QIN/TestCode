%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%    self-optimization       %%%%%%%
%%%%%%%%%%%        PoA         %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
lambda = 6;
mu = 4;
rho = lambda / mu;
k = 0.1 : .1 : 1e4;
c = 10;
count  = 0;

v1 = zeros(1, length(k));
v2 = zeros(1, length(k));
x1 = zeros(1, length(k));
x2 = zeros(1, length(k));

for l = 1 : 5 % l is the floor x^* and ceil x^*
    for i = 1 : length(k)
        if rho == 1
            x_opt = (2.*k(i).*lambda^3./c^2).^(1/4) - 1;
            x1(i) = floor(x_opt);
            x2(i) = ceil(x_opt);
            v1(i) = (x1(i)+1).^3 .*(x1(i)+2)./2;
            v2(i) = x2(i).*(x2(i)+1).^3./2;
        else
            myfun1 = @(x) (k(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 ...
                + (rho.^(x+1)-1)./log(rho) - x - 1;
            x_opt = fzero(myfun1, [-0.9 200]);
            x1(i) = floor(x_opt);
            x2(i) = ceil(x_opt);
            v1(i) = (1 - rho.^(x1(i)+1)).^2.*(x1(i)+1-(x1(i)+2).*rho+rho.^(x1(i)+2))./(rho.^(2.*x1(i)-1) .* (1-rho)^4);
            v2(i) = (1 - rho.^(x2(i)+1)).^2.*(x2(i) -(x2(i)+1).*rho+rho.^(x2(i)+1))./(rho.^(2.*x2(i)-1) .* (1-rho)^4);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % find the floor start index and end index
    for j = 1 : length(v1)
        if (x1(j) == l)
            index_start_floor = j;
            break
        end
    end
    
    for j = 1 : length(v1)
        if (x1(j) == l+1)
            index_end_floor = j-1;
            break
        end
    end
    
    for m = index_start_floor : index_end_floor
        if (k(m)*lambda^3/c^2 > v1(m))
            floor_end = m-1;
            break
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % find the ceiling start index and end index
    
    for j = 1 : length(v2)
        if (x2(j) == l+1)
            index_start_ceil = j;
            break
        end
    end
    
    for j = 1 : length(v2)
        if (x2(j) == l+2)
            index_end_ceil = j-1;
            break
        end
    end
    
    for m = index_start_ceil : index_end_ceil
        if (k(m)*lambda^3/c^2 > v2(m))
            ceil_start = m;
            break
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    k_floor = k(index_start_floor : floor_end);
    k_ceil = k(ceil_start : index_end_ceil);
    
    % price of anarchy
    % self-optimiation vs overall
    
    priceOfAnarchy_floor = zeros(1, length(k_floor));
    
    
    for i = 1 : length(k_floor)
        if rho == 1
            W = 1/2;
        else
            W = rho/(1-rho) + rho/log(rho);
        end
        if k_floor(i)*lambda^3/c^2 < W/3
            %%%%%%%%%%%%% self-optimization Bs = 0 %%%%%%%%%%%%%
            T_u(1:3) = k_floor(i) * lambda^2/c^2;
            
            %%%%%%%%%%%%%%% overall B_g = 0 %%%%%%%%%%%%%%%%
            T_g(1:3) = k_floor(i) * lambda^2/c^2;
            
            
        elseif (k_floor(i)*lambda^3/c^2 >= W/3) && (k_floor(i)*lambda^3/c^2 < W)
            %%%%%%%%%%%%%%%% self-optimization  Bs = 0 %%%%%%%%%%%%%%
            T_u(1:3) = k_floor(i) * lambda^2/c^2;
            
            %%%%%%%%%%%%% overall optimization %%%%%%%%%%%%%%
            if rho == 1
                x_opt = (6*k_floor(i)*lambda^3/c^2)^(1/4) - 1;
            else
                myfun = @(x) (3.*k_floor(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
                x_opt = fzero(myfun, [-0.9 200]);
            end
            if x_opt < 0
                B(1) = 0;
                B(2) = 0;
                B(3) = 0;
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
            T_g  =  E_Q./lambda + k_floor(i).*lambda^2 .* pi_B.^3 ./ c^2;
        else
            %%%%%%%%%%%%% self-optimization %%%%%%%%%%%%%%
            if rho == 1
                x_opt = (2*k_floor(i)*lambda^3/c^2)^(1/4) - 1;
            else
                myfun1 = @(x) (k_floor(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
                x_opt = fzero(myfun1, [-0.9 200]);
            end
            if x_opt < 0
                Bs(1) = 0;
                Bs(2) = 0;
                Bs(3) = 0;
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
            T_u  =  E_Qs./lambda + k_floor(i).*lambda^2 .* pi_Bs.^3 ./ c^2;
            
            
            %%%%%%%%%%%%% overall optimization%%%%%%%%%%%%%
            if rho == 1
                x_opt = (6*k_floor(i)*lambda^3/c^2)^(1/4) - 1;
            else
                myfun2 = @(x) (3.*k_floor(i).*lambda.^3.*(1-rho).^3./(c.^2.*rho.^3)).*(1 + 1./(rho.^(x+1)-1)).^2 + (rho.^(x+1)-1)./log(rho) - x - 1;
                x_opt = fzero(myfun2, [-0.9 200]);
            end
            if x_opt < 0
                B(1) = 0;
                B(2) = 0;
                B(3) = 0;
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
            T_g  =  E_Q./lambda + k_floor(i).*lambda^2 .* pi_B.^3 ./ c^2;
        end
        
        %%%%%%%%%%%% price of anarchy - floor NE %%%%%%%%%%%%%%%%%
        %%% 1-floor, 2-ceil, 3-continuous
        priceOfAnarchy_floor(i) = 1 - min(T_g(1:2))/(min(T_u(1)));
    end
    
    priceOfAnarchy_ceil = zeros(1, length(k_ceil));
    
    for i = 1 : length(k_ceil)
        if rho == 1
            W = 1/2;
        else
            W = rho/(1-rho) + rho/log(rho);
        end
        if k_ceil(i)*lambda^3/c^2 < W/3
            %%%%%%%%%%%%% self-optimization Bs = 0 %%%%%%%%%%%%%
            T_u(1:3) = k_ceil(i) * lambda^2/c^2;
            %%%%%%%%%%%%%%% overall B_g = 0 %%%%%%%%%%%%%%%%
            T_g(1:3) = k_ceil(i) * lambda^2/c^2;
            
        elseif (k_ceil(i)*lambda^3/c^2 >= W/3) && (k_ceil(i)*lambda^3/c^2 < W)
            %%%%%%%%%%%%%%%% self-optimization  Bs = 0 %%%%%%%%%%%%%%
            T_u(1:3) = k_ceil(i) * lambda^2/c^2;
            
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
    end
    PoA_l = [priceOfAnarchy_floor , priceOfAnarchy_ceil];
    k_l = [k_floor, k_ceil];
    
    if l == 1
        PoA = PoA_l;
        k_poa = k_l;
    else
        PoA = [PoA, PoA_l]; %#ok<AGROW>
        k_poa = [k_poa, k_l]; %#ok<AGROW>
    end
end

figure(12)
plot(k_poa.*lambda^3/c^2, PoA,'ro','LineWidth',2,'MarkerSize',.5)
xlabel('k\lambda^3/c^2','FontSize', 18)
ylabel('PoA','FontSize', 18)
title('PoA : \rho = ' + string(rho) + ', c = ' + string(c) ...
    + ', \lambda = ' + string(lambda) , 'FontSize', 18)
set(gca,'FontSize',18)
grid on

