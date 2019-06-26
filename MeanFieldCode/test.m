clear
x = 0.07 : 0.001  : 15;
f = 8.*log(x)./log(0.1) + 4;
g = 1./(x);

figure(3)
plot(x,f,'r','LineWidth',2)
hold on
plot(x, g,'b','LineWidth',2)
plot(1,1,'b-s','LineWidth',2, 'MarkerSize', 8)
plot(2.2, -2.74+4, 'r-o','LineWidth',2, 'MarkerSize', 8)
grid on