clear;clc

T = readtable(['threshold data.xlsx'],'Sheet','Pt');
% T = readtable('Threshold-Data.xlsx','Sheet','Sheet1');
[x, I] = sort(T.NAdditionRate,'ascend');
y = T.RR__(I);

y_ma=movmean(y,6);
figure
subplot(2,1,1)
plot(x,y_ma)


[ UF,UB ] = MannKendall( x,y_ma,0.01);
subplot(2,1,2);
hold on;
plot(UB, 'r-', 'LineWidth', 1.5);
plot(UF, 'b-', 'LineWidth', 1.5);
plot([1 length(x)], [1.96 1.96], 'k--'); % 0.05显著性水平
plot([1 length(x)], [-1.96 -1.96], 'k--');
xlabel('Time/Sequence');
ylabel('Mann-Kendall Statistic');
legend('UB (Backward)', 'UF (Forward)', '95% Significance');
title('Mann-Kendall Trend Test');
grid on;
hold off;

