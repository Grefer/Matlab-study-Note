function CIR
 %模拟CIR利率期限结构模型

 %参数设定
 Theta = 0.05;
 Kappa = 1.3;
 Sigma = 0.2;
 T=3;
 NbSteps = 156;
 dT = T / NbSteps;
 rInit = 0.05;
 Lambda = 0.3;
 Gamma = sqrt((Kappa+Lambda)^2+2*Sigma^2);
 t=0;
 r=rInit;

 %定义零息票利率R的维度
 R = zeros(NbSteps,1);

 %定义时间间隔步长
 for i=1:NbSteps

    %定义零息债券价格参数A和B
    Temp1=(Gamma+Kappa+Lambda)*(exp(Gamma*(T-t))-1)+2*Gamma;
    Temp2=2*Gamma*exp((Gamma+Kappa+Lambda)*(T-t)/2);
    Temp3=2*(exp(Gamma*(T-t))-1);

    %求取零息债券价格参数A和B
    A = (Temp2/Temp1)^(2*Kappa*Theta/Sigma^2);
    B = Temp3/Temp1;

    %短期利率的模拟
    r = r + Kappa*(Theta-r)*dT + Sigma*sqrt(r)*sqrt(dT)*randn(1);

    %在时刻t,期限为T-t的零息利率R为：
    R(i,1) = (r*B-log(A))/(T-t);
    t=t+dT;
 end

 %绘出利率期限结构（一条路径）
 plot([dT:dT:T], r);

 end