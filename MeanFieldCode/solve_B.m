clear
T = 1e6; % simulation time
lambda = 0.1 : 0.1 : 1.8; %arrival rate
N = 10; % number of users
% lambda = 0 : 0.1 : 1.9; %% there is a bug under this setup
mu = 1; % local service rate
c = 2; % global rate
k = 10; % system parameter
B = 2; %threshold B 
rho = lambda./ mu;

v1 = zeros(1, length(lambda));
v2 = zeros(1, length(lambda));
x1 = zeros(1, length(lambda));
x2 = zeros(1, length(lambda));

for i = 1 : length(lambda)
        if rho(i) == 1
            x_opt = (2.*k.*lambda(i)^3./c^2).^(1/4) - 1;
            x1(i) = floor(x_opt);
            x2(i) = ceil(x_opt);
            v1(i) = (x1(i)+1).^3 .*(x1(i)+2)./2;
            v2(i) = x2(i).*(x2(i)+1).^3./2;
        else
            myfun1 = @(x) (k.*lambda(i).^3.*(1-rho(i)).^3./(c.^2.*rho(i).^3)).*(1 + 1./(rho(i).^(x+1)-1)).^2 ...
                + (rho(i).^(x+1)-1)./log(rho(i)) - x - 1;
            x_opt = fzero(myfun1, [-0.9 200]);
            x1(i) = floor(x_opt);
            x2(i) = ceil(x_opt);
            v1(i) = (1 - rho(i).^(x1(i)+1)).^2.*(x1(i)+1-(x1(i)+2).*rho(i)+rho(i).^(x1(i)+2))./(rho(i).^(2.*x1(i)-1) .* (1-rho(i))^4);
            v2(i) = (1 - rho(i).^(x2(i)+1)).^2.*(x2(i) -(x2(i)+1).*rho(i)+rho(i).^(x2(i)+1))./(rho(i).^(2.*x2(i)-1) .* (1-rho(i))^4);
        end
 end


