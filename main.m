% main.m
% This script when run should compute all values and make all plots
% required by the project.
% To do so, you must fill the functions in the functions/ folder,
% and create scripts in the scripts/ folder to make the required
% plots.

% Add folders to path
addpath('./functions/','./scripts/');

% Add plot defaults
plotDefaults;

%% Exercise a
T = 1069;
N = 25;
[dates,past1mon,past212mon,past1360mon] = loadStockData1('C:\Users\wc145\Desktop\ECON676\PS7\Problem_Set7.xls');
[rmrf,SMB,HML,rf,UMD] = loadStockData2('C:\Users\wc145\Desktop\ECON676\PS7\Problem_Set7.xls');

[past1mon,past212mon,past1360mon] = DataProcess1(past1mon,past212mon,past1360mon,N,T);
[UMD] = DataProcess2(UMD,T);

% regress each of 75 portfolios on Jan and Jan dummy
Jan = zeros(T,1);
for t = 1:T
    if mod(t+5,12) == 0
        Jan(t,1) = 1;
    end
end
% Jan mean returns for 75 portfolios
beta11 = zeros(N,1);
beta12 = zeros(N,1);
beta13 = zeros(N,1);
for i = 1:N
    beta11(i,1) = regress(past1mon(:,i), Jan);
    beta12(i,1) = regress(past212mon(:,i), Jan);
    beta13(i,1) = regress(past1360mon(:,i), Jan);
end
% Jan excess return for 75 portfolios 
beta21 = zeros(N,2);
beta22 = zeros(N,2);
beta23 = zeros(N,2);
for i = 1:N
    beta21(i,:) = regress(past1mon(:,i)-rf, [ones(T,1) Jan]);
    beta22(i,:) = regress(past212mon(:,i)-rf, [ones(T,1) Jan]);
    beta23(i,:) = regress(past1360mon(:,i)-rf, [ones(T,1) Jan]);
end
% There is a strong Jan seasonal effect, excess return largest for smallest
% past losers and smallest for largest past winners, it may partly due to
% market effect or size effect and for 1360mon, may due to value effect(
% winnner and loser).
% The largest happens in 212 smallest loser, maybe went through tax-loss
% selling and bounce back

% regress each of 75 portfolios on Dec and Jan dummy
Dec = zeros(T,1);
for t = 1:T
    if mod(t+6,12) == 0
        Dec(t,1) = 1;
    end
end
beta31 = zeros(N,3);
beta32 = zeros(N,3);
beta33 = zeros(N,3);
for i = 1:N
    beta31(i,:) = regress(past1mon(:,i)-rf, [ones(T,1) Dec Jan]);
    beta32(i,:) = regress(past212mon(:,i)-rf, [ones(T,1) Dec Jan]);
    beta33(i,:) = regress(past1360mon(:,i)-rf, [ones(T,1) Dec Jan]);
end
% the smallest Dec premium happens in 212 smallest loser, Dec seasonal is
% not significant

% relation between past returns and expected returns
cum1past1mon = zeros(T,N);
cum1past212mon = zeros(T,N);
cum1past1360mon = zeros(T,N);
cum12past1mon = zeros(T,N);
cum12past212mon = zeros(T,N);
cum12past1360mon = zeros(T,N);
cum60past1mon = zeros(T,N);
cum60past212mon = zeros(T,N);
cum60past1360mon = zeros(T,N);
% past 1 mon return
for i = 1:N
    for t = 2:T
        cum1past1mon(t,i) = past1mon(t-1,i);
        cum1past212mon(t,i) = past212mon(t-1,i);
        cum1past1360mon(t,i) = past1360mon(t-1,i);
    end
end
% cumulative return from t-2 to t-12
for i = 1:N
    for t = 13:T
        cum12past1mon(t,i) = sum(past1mon(t-12:t-2,i));
        cum12past212mon(t,i) = sum(past212mon(t-12:t-2,i));
        cum12past1360mon(t,i) = sum(past1360mon(t-12:t-2,i));
    end
end
% cumulative return from t-13 to t-60
for i = 1:N
    for t = 61:T
        cum60past1mon(t,i) = sum(past1mon(t-60:t-13,i));
        cum60past212mon(t,i) = sum(past212mon(t-60:t-13,i));
        cum60past1360mon(t,i) = sum(past1360mon(t-60:t-13,i));
    end
end

portfolio = [past1mon past212mon past1360mon];
cum1 = [cum1past1mon cum1past212mon cum1past1360mon];
cum12 = [cum12past1mon cum12past212mon cum12past1360mon];
cum60 = [cum60past1mon cum60past212mon cum60past1360mon];

% cross section regress every month
beta4 = zeros(T,4);
for i = 1:T
    beta4(i,:) = regress(portfolio(i,:)'-ones(75,1)*rf(i,1), [ones(75,1) cum1(i,:)' cum12(i,:)' cum60(i,:)']);
end
mean0 = mean(beta4(61:end,1));
mean1 = mean(beta4(61:end,2));
mean212 = mean(beta4(61:end,3));
mean1360 = mean(beta4(61:end,4));
std0 = std(beta4(61:end,1));
std1 = std(beta4(61:end,2));
std212 = std(beta4(61:end,3));
std1360 = std(beta4(61:end,4));
t0 = mean0*sqrt(T-60)/std0;
t1 = mean1*sqrt(T-60)/std1;
t212 = mean212*sqrt(T-60)/std212;
t1360 = mean1360*sqrt(T-60)/std1360;

% e
beta5 = zeros(75,5);
info = zeros(75,1);
std5 = nanstd(portfolio)';
for i = 1:75
    beta5(i,:) = regress( portfolio(:,i)-rf, [ones(T,1) rmrf SMB HML UMD]);
    info(i,1) = beta5(i,1)/std5(i,1);
end
% long the first short the 15th
r_max = zeros(T,1);
r_max(1,1) = portfolio(1,5);
for t = 1:T
    r_max(t,1) = portfolio(t,1)-portfolio(t,5);
end
% cum = [cum1 cum12 cum60];
% for i = 2:12
%     for n = 1:75
%         for m = 1:75
%             if cum(i,n) == max(cum(i,:)) || cum(i,m) == min(cum(i,:))
%                 r_max(i,1) = portfolio(i,n)-portfolio(i,m);
%             end
%         end
%     end
% end
% for i = 13:T
%     for n = 1:75
%         for m = 1:75
%             if cum(i,n) == max(cum(i,:)) || cum(i,m) == min(cum(i,:))
%                 r_max(i,1) = portfolio(i,n)-portfolio(i,m);
%             end
%         end
%     end
% end
% % for t = 1:T
% %     if mod(t+5,12) == 0
% %         r_max(t,1) = portfolio(t,1)-rf(i,1);
% %     end
% % end
% % for t = 1:T
% %     if mod(t+5,12) == 0
% %         r_max(t,1) = portfolio(t,25)- portfolio(t,1);
% %     end
% % end
mean_max = nanmean(r_max);
std_max = nanstd(r_max);
SR_max_1 = (mean_max)/std_max;
SR_max = sqrt(12)*(mean_max)/std_max;


% g 
M = 5000;
rng(1);
R = ceil(75.*rand(T,M));
port = zeros(T,M);
for t = 1:T
     port(t,:) = portfolio(t, R(t,:));
end
mean_M = zeros(M,1);
std_M = zeros(M,1);
SR_M = zeros(M,1);
for i = 1:M
    mean_M(i,1) = nanmean(port(:,i));
    std_M(i,1) = nanstd(port(:,i));
    [~,~,~,a.tstat] = ttest(port(:,i));
    SR_M(i,1) = sqrt(12)*(mean_M(i,1) - nanmean(rf))/std_M(i,1);
end
number = 0;
for i = 1:M
    if SR_M(i,1) > SR_max
        number = number + 1;
    end
end
ratio = number/M;
histogram(t_M);        


