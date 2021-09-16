function price=OptionZQAsiaDoubleStrikePrice111(s00,s0,sr,K1,r,T,sigma,N,resdays)

rng(10)

% 双执行价格，K1=入场价格，K2=入场价格加减一定数值
% 初始时入场价s00一般等于s0，当交易已开始后用当天起始价s0模拟接下来路径
% sr 采价期已实现序列,1Xn的序列,初始时取值[]

%若存在某一天采价低于入场价格-保底价格，则结算金额=min[（K1-K2）,K1-期权结算价]+保底，反之min[（K1-K2）,K1-期权结算价]
%最小二乘蒙特卡洛模拟方法
%T为到期时间，N为均价期长度，T>=N，T取值为整数，不是年化时间
%-1为看跌
%by QS



delt=1/243;
M=50000;

%s=zeros(M,T);
% for j=1:M
%     %期货价格的模拟。风险中性世界，期货预期收益率为0.
%     s(j,1)=s0*exp((0-sigma^2/2)*delt+normrnd(0,sigma*sqrt(delt)));
%     for i=2:T
%         s(j,i)=s(j,i-1)*exp((0-sigma^2/2)*delt+normrnd(0,sigma*sqrt(delt)));
%     end;
% end

%采用对偶变量缩减方差

price_ls = zeros(M,1);
if resdays>=N   %只要剩余天数大于等于采价天数，就不用在乎之前的路径
    T=resdays;
    s1=zeros(M/2,T);
    s2=zeros(M/2,T);
    for j=1:M/2
        %期货价格的模拟。风险中性世界，期货预期收益率为0.
        rand1=normrnd(0,sigma*sqrt(delt));
        s1(j,1)=s0*exp((0-sigma^2/2)*delt+rand1);
        s2(j,1)=s0*exp((0-sigma^2/2)*delt-rand1);
        for i=2:T
            rand1=normrnd(0,sigma*sqrt(delt));
            s1(j,i)=s1(j,i-1)*exp((0-sigma^2/2)*delt+rand1);
            s2(j,i)=s2(j,i-1)*exp((0-sigma^2/2)*delt-rand1);
        end
    end
    s=[s1;s2];
    
    %if cp == -1
        for i=1:M
            if min(s(i,T-N+1:T))<K1 %这里注意K1或者s0有可能改动

                price_ls(i,1)=(max(284.09,K1-mean(min(s00,s(i,T-N+1:T)),2)))*exp(-r*delt*resdays);%mean(X,2)每行平均值，2代表行
            else
                price_ls(i,1)=0;
            end        
%     else
%         yy=max(mean(s(:,T-N+1:T),2)-K,minPay)*exp(-r*delt*resdays);
        end
else

    s1=zeros(M/2,resdays);
    s2=zeros(M/2,resdays);
    %avgsp=avgp*(N-resdays);%avgp为已结束的采价期内入场价和收盘价较小值的均价
    for j=1:M/2
        %期货价格的模拟。风险中性世界，期货预期收益率为0.
        rand1=normrnd(0,sigma*sqrt(delt));
        s1(j,1)=s0*exp((0-sigma^2/2)*delt+rand1);%如果交易已经发生，起点s0要用最新的当前s
        s2(j,1)=s0*exp((0-sigma^2/2)*delt-rand1);
        for i=2:resdays
            rand1=normrnd(0,sigma*sqrt(delt));
            s1(j,i)=s1(j,i-1)*exp((0-sigma^2/2)*delt+rand1);
            s2(j,i)=s2(j,i-1)*exp((0-sigma^2/2)*delt-rand1);
        end;
    end
    s=[s1;s2];
    s=[repmat(sr,[M,1]),s];

    for i=1:M
        if min(s(i,:))<K1 %对照条款这里的s00，有可能改动
            price_ls(i,1)=(max(284.09,K1-mean(min(s00,s(i,T-N+1:T)),2)))*exp(-r*delt*resdays);%mean(X,2)每行平均值，2代表行
        else
            price_ls(i,1)=0;
        end        
    end
end



price=mean(price_ls);


end

%delta=(OptionZQAsiaDoubleStrikePrice(24000,24000+20,[],24000,23000,0.03,23,0.35,23,23,200)-OptionZQAsiaDoubleStrikePrice(24000,24000-20,[],24000,23000,0.03,23,0.35,23,23,200))/40*吨数/16