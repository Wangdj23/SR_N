clear;clc

T = readtable(['threshold_data_sorted.xlsx'],'Sheet','Sheet1');
% T = readtable('Threshold-Data.xlsx','Sheet','Sheet1');
[x, I] = sort(T.NAdditionRate,'ascend');
y = T.RR__(I);

p = polyfit(x,y,2);
y1 = polyval(p,x);

figure
subplot(1,2,1)
scatter(x,y,15,'filled')
set(gca, 'XTickMode', 'auto','fontsize',14);
xlabel('NAdditionRate','fontsize',14,'fontweight','l');
ylabel('RR__','fontsize',14,'fontweight','l');
hold on
plot(x,y1,'-k','LineWidth',1.5)
% plot(repmat(12.5,[3 1]),-1:1,'--r','LineWidth',1.5)
% text(12.5-2,0.33,'12.5','fontsize',12,'fontweight','l','color','r');
ylim([-0.6 0.3])
hold off


y1 = 1;
y2 = numel(x);
window_length = 4;
[t_all,t_thres] = mymoving_ttest(y,y1,y2,window_length,0.1);
subplot(1,2,2)
plot(y1+window_length:y2-window_length,t_all,'-','linewidth',1.5,'color','k') ; hold on;
set(gca,'fontsize',12,'linewidth',1.5,'tickdir','out','box','off', ...
    'xtick',y1+window_length-1:y2-window_length+1, ...
    'xticklabels',x(y1+window_length-1:y2-window_length+1))
h1 = plot(y1+window_length-1:y2-window_length+1,repmat(t_thres,numel(y1+window_length-1:y2-window_length+1),1),'--','linewidth',1.5,'color','b') ;
