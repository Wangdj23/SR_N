clear;clc

T = readtable('Threshold-Data.xlsx','Sheet','Sheet1');
[x, I] = sort(T.NAdditionRate,'ascend');
y = T.RR__(I);

% p = polyfit(x,y,2);
% y1 = polyval(p,x);
% figure
% scatter(x,y,15,'filled')
% set(gca, 'XTickMode', 'auto','fontsize',14);
% xlabel('N Addition Rate','fontsize',14,'fontweight','l');
% ylabel('RR++','fontsize',14,'fontweight','l');
% hold on
% plot(x,y1,'-k','LineWidth',1.5)
% plot(repmat(12,[3 1]),-1:1,'--r','LineWidth',1.5)
% text(12-2,0.33,'12','fontsize',12,'fontweight','l','color','r');
% ylim([-0.6 0.3])
% hold off

y = smoothdata(y,'sgolay',9,'Degree',3);
interval = 1;
y = interp1(x,y,min(x):interval:max(x));
x = min(x):interval:max(x);
% p = polyfit(x,y,2);
% y1 = polyval(p,x);
%
% figure
% scatter(x,y,15,'filled')
% set(gca, 'XTickMode', 'auto','fontsize',14);
% xlabel('N Addition Rate','fontsize',14,'fontweight','l');
% ylabel('RR__','fontsize',14,'fontweight','l');
% hold on
% plot(x,y1,'-k','LineWidth',1.5)
% plot(repmat(11,[3 1]),-1:1,'--r','LineWidth',1.5)
% text(11-2,0.33,'11','fontsize',12,'fontweight','l','color','r');
% ylim([-0.6 0.3])
% hold off

figure
y1 = 1;
y2 = numel(x);
% sheet_id = 1;
t_thres = zeros(numel(y1:y2),1);
p_all = zeros(numel(y1:y2),1);
window_length = 10;
[t_all,~] = mymoving_ttest(y,y1,y2,window_length,0.05);

t_thres95 = tinv(1-0.05/2,20-2);
t_thres99 = tinv(1-0.01/2,20-2);
t_thres90 = tinv(1-0.1/2,20-2);

blue_color      = [0 0.4470 0.7410];
plot(x(y1+window_length:y2-window_length),t_all,'-','linewidth',1.5,'color','k') ; hold on;
set(gca,'fontsize',15,'linewidth',1.5,'tickdir','out','box','off')

h2 = gca;
h2.XRuler.TickLength = [0.02,0.001];
h2.XAxis.MinorTick = 'on';
h2.XAxis.MinorTickValues = 5:20;
h2.YAxis.MinorTick = 'off';

xlabel('N Addition Rate','fontsize',18)
ylabel('T-statistic')
ylim([0 4.5])
xlim([8 20])

h90 = plot(5:33,repmat(t_thres90,numel(5:33),1),'--','linewidth',1.5,'color','g') ;
h95 = plot(5:33,repmat(t_thres95,numel(5:33),1),'--','linewidth',1.5,'color','b') ;
h99 = plot(5:33,repmat(t_thres99,numel(5:33),1),'--','linewidth',1.5,'color','r') ;


x_data = x(y1+window_length:y2-window_length);
y_data = t_all;

y_data2 = y_data(x_data<13);
x_data2 = x_data(x_data<13);
left_95 = interp1(y_data2,x_data2,t_thres95)
left_90 = interp1(y_data2,x_data2,t_thres90)

y_data2 = y_data(x_data>12 & x_data<15);
x_data2 = x_data(x_data>12 & x_data<15);
right_95 = interp1(y_data2,x_data2,t_thres95)
right_90 = interp1(y_data2,x_data2,t_thres90)

plot(left_95,t_thres95,'o','color','k','linewidth',1.5) ;
text(left_95,t_thres95-.1,sprintf('%g',left_95),'fontsize',12)
plot(left_90,t_thres90,'o','color','k','linewidth',1.5) ;
text(left_90,t_thres90-.1,sprintf('%g',left_90),'fontsize',12)

plot(right_95,t_thres95,'o','color','k','linewidth',1.5) ;
text(right_95,t_thres95+.1,sprintf('%g',right_95),'fontsize',12)
plot(right_90,t_thres90,'o','color','k','linewidth',1.5) ;
text(right_90,t_thres90+.1,sprintf('%g',right_90),'fontsize',12)

legend([h90,h95,h99],{' 90% level',' 95% level',' 99% level'},'location','Northeast')

