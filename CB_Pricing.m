function price = CB_Pricing(S0,X,T,r,sigma,n,C,P,nPath,coupon1,coupon2)
    % coupon是债券息票矩阵
    % n为年交易日天数，转债市场默认为250
    % C为赎回条款标识，P为回售条款标识
    
    s = sPath(S0,r,sigma,T,n*T,nPath);
    X = X*ones(nPath,n*T);
    p = zeros(nPath,1);
    AI = zeros(1,n*T);   %应计利息现值
    FI = zeros(1,n*T);   %持有至到期利息现值
    FI(1,:) = coupon2(T);
    
    for i = n:n*T
        if mod(i,n) == 0
            AI(1,i) = coupon1(floor(i/n))*exp(-r*(i/n)) + AI(1,i-1);
        else
            AI(1,i) = AI(1,i-1);
        end
    end
    
    for i = n*T-1:-1:1
        if mod(i,n) == 0
            FI(1,i) = FI(1,i+1)*exp(-r/n) + coupon2(i/n);
        else
            FI(1,i) = FI(1,i+1)*exp(-r/n);
        end
    end
    
    for j = 1:nPath
        if P==1                %如条款含有回售条款，P=1，否则P=0
            for k = T-2:T-1    %回售期
                for i = (1+k*n):(k+1)*n-30
                    if s(j,i:i+29) < (X(j,i+29)*0.7)         %触发回售条件
                        X(j,(i+30):end) = AdjustX(s(j,i+29),X(j,i+29),r,(i+30)/n,T,sigma,coupon1);   %修正股价
                        break
                    end
                end
            end
        end
        if C==1                    %如条款含有赎回条款，C=1，否则C=0
            for i= 0.5*n:n*T-30    %转股期
                if  sum(s(j,i:i+29) >= 1.3*X(j,i),2) >= 15    %触发赎回条件
                    p(j,1)=( 100/X(j,i+30).*s(j,i+30) )*exp(-r*((i+30)/n)) + AI(1,i+30);
                    break
                end
            end
        end
    end
    
    for m = 1:nPath
        if p(m,1) > 0
            s(m,:) = 0;     %剔除触发赎回条款路径的股价
        end
    end
    
    M = 100*s(:,end)./X(:,end);    %期末转股价值
    CP = 100 + coupon2(:,end);     %期末赎回价值
    cashflows=max(CP,M);         
        
    for j = 1:nPath
        if M(j,1) == 0
            cashflows(j,1) = 0;    %剔除触发回售条款路径的现金流
        end
    end
    
    
    Xtime = n*T*ones(nPath,1);    %最优执行时点初始化为期末n*T时点
    discountfactor = exp(-r/n*(1:n*T)');
    
    for step = n*T-1:-1:0.5*n
        Inmoney = find( 100./X(:,step).*s(:,step) > 100+FI(:,step) );    %找出n*T-1时点的价内路径
        y = cashflows(Inmoney).*discountfactor(Xtime(Inmoney)-step);     %价内路径对应的n*T时点现金流折现到前一时点记为Y
        x = s(Inmoney,step);    %价内路径对应的n*T-1时点股价记为X
        RegresMat = [ones(length(x),1),x,x.^2];      %最小二乘法回归
        a = RegresMat\y;
        IntrinsicValue = 100*s(Inmoney,step)./X(Inmoney,1);   %n*T-1时点转股价值
        ContinuationValue = RegresMat*a;          %回归方程所得继续持有价值
        Exercise = find(IntrinsicValue > ContinuationValue);
        k = Inmoney(Exercise);
        cashflows(k) = IntrinsicValue(Exercise);
        Xtime(k) = step;
    end
    
    price = mean(cashflows.*discountfactor(Xtime)+p(:,1));
    
end
    
    

            