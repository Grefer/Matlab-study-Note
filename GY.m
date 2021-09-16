function Price=GY(cp,X,T,r,coupon,sigma,mcallshedule,Nstep,Npath)
    dt=T/Nstep;
    %mcallshedule:到期赎回价
    s=cp*ones(Npath,Nstep);
    for j=1:Npath
        for i=1:Nstep-1
            s(j,i+1)=s(j,i)*exp((r-0.5*sigma^2)*dt+sigma*sqrt(dt)*randn); % monte carlo 模拟股价
        end 
    end
    X=X*ones(Npath,1);
    num0=0;
    num1=0;
    p=zeros(Npath,1);
    for j=1:Npath %触发回售条款本质是调整转股价
        for k=0:T-1
            for i=(1+k*Nstep/T+round(0.9/(k+1))*0.5*Nstep/T):((k+1)*Nstep/T-30*floor((k+1)/T)) %转股期限
                if s(j,i:i+29)<(X(j,1)*0.7)
                    X(j,1)=X(j,1)*mean(s(j,i:i+29));
                    break
                end
            end
            for a=(T-min(k+1,T-1))*Nstep/T : Nstep/T-30
                if s(j,a:a+19)>=1.3*X(j,1)  %统计转股修正后触发赎回条款的路径
                    p(j,1)=((100/X(j,1))*s(j,a+28)+coupon(1,1:floor(T*a/Nstep))*ones(floor(T*a/Nstep),1))*exp(-r*dt*a);
                    % 理智的投资者会在公司执行赎回条件之前转股
                    num0=num0+1;
                break
                end
            end
        end
    end
    for j=1:Npath %统计转股价没有修正情况下触发赎回条款的路径
        for i=0.5*Nstep/T:Nstep-30 %转股期限
            if (s(j,i:i+19)>=1.3*X) & (p(j,1)==0)
                p(j,1)=((100/X)*s(j,i+28)+coupon(1,1:floor(T*i/Nstep))*ones(floor(T*i/Nstep),1))*exp(-r*dt*i);
                %理智的投资者会在公司执行赎回条件前转股
                num1=num1+1;
            break
            end
        end
    end
    num=num0+num1;
    for m=1:Npath  %将股票模拟路径中触发赎回条件的去除
        if p(m,1)>0
            s(m,:)=0;
        end
    end
    discount=exp(-r*dt);
    discountvet=exp(-r*dt*(1:Nstep)');
    a=zeros(3,1);
    A=100*s(:,Nstep)./X;
    cashflows=max(mcallshedule,A);
    for i=1:Npath
        if A(i,1)==0
            cashflows(i,1)=0;
        end
    end
    ExerciseTime=Nstep*ones(Npath,1);
    
    for step=Nstep-1:-1:0.5*Nstep/T    %从Nstep-1步开始，步长为1，到1结束
        Inmoney=find(100*s(:,Nstep)./X>100+mean(coupon)*dt*(Nstep-step));   %转股有利的
        y=cashflows(Inmoney).*discountvet(ExerciseTime(Inmoney)-step);  %第n步如果转股，在第n-1步的贴现
        x=100*s(Inmoney,step)./X(Inmoney,1);   %第n步转股
        RegrMat=[ones(length(x),1),x,x.^2]; %回归矩阵
        a=RegrMat\y;    %最小二乘回归
        IntrinsicValue=x;   %第n步内在价值
        ContinuationValue=RegrMat*a;    %模拟第n+1步贴现的价值
        Exercise=find(IntrinsicValue>ContinuationValue);    %第n步执行转股的状态
        k=Inmoney(Exercise);
        cashflows(k)=IntrinsicValue(Exercise);
        ExerciseTime(k)=step;
    end
    Price=mean(cashflows.*discountvet(ExerciseTime)+p(:,1));    %平均值即为可转债价值
    % p=GY(6.24,8.11,6,0.027,[0.2,0.4,0.6,0.8,1.5,2.0],0.33,106.5,250,100)
                