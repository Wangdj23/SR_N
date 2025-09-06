clear;clc

T = readtable(['Threshold data.xlsx'],'Sheet','Pt');
% T = readtable('Threshold-Data.xlsx','Sheet','Sheet1');
[x, I] = sort(T.NAdditionRate,'ascend');
y = T.RR__(I);

y_ma=movmean(y,11);
data=y_ma;

n=length(data);
s=0;
for i=2:n
for j=1:n
y(i-1,j)=sign(data(i-1,1)-data(j,1));
 g(i-1)=sum(y(i-1,:));
end
end

Ut=cumsum(g);
F=Ut;
Kmax=max(abs(F));
chg_point=find(abs(F)==Kmax);%找出最大值对应的序列号
coef=2*exp(-6*Kmax^2/(n^3+n^2));%显著水平计算

% 计算95%和99%的临界值
alpha_95 = 0.05;
alpha_99 = 0.01;
Kcrit_95 = sqrt(-(n^3 + n^2) / 6 * log(alpha_95 / 2));
Kcrit_99 = sqrt(-(n^3 + n^2) / 6 * log(alpha_99 / 2));

figure
hold on
plot(x(2:n,1),F,'K-','linewidth',1.5);%画出整个曲线的变化趋势
plot([x(chg_point),x(chg_point)],[-Kmax,Kmax],'r--','linewidth',1.5);%画出该竖线即为突变点
% Klim=Kmax-Kmax*0.1;
% plot([x(1),x(n)],[-Klim,-Klim],'b-');
% plot([x(1),x(n)],[Klim,Klim],'b-');
plot([x(1), x(n)], [Kcrit_95, Kcrit_95], 'b-', 'linewidth', 1.2);
plot([x(1), x(n)], [-Kcrit_95, -Kcrit_95], 'b-', 'linewidth', 1.2);
plot([x(1), x(n)], [Kcrit_99, Kcrit_99], 'g--', 'linewidth', 1.2);
plot([x(1), x(n)], [-Kcrit_99, -Kcrit_99], 'g--', 'linewidth', 1.2);

legend('F(t)', 'Change Point', '95% Threshold', '99% Threshold');
title(['Pettitt Test (p = ', num2str(p_value, '%.4f'), ')']);
xlabel('N Addition Rate');
ylabel('U_t');