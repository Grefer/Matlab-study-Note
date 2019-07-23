function CIR
 %ģ��CIR�������޽ṹģ��

 %�����趨
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

 %������ϢƱ����R��ά��
 R = zeros(NbSteps,1);

 %����ʱ��������
 for i=1:NbSteps

    %������Ϣծȯ�۸����A��B
    Temp1=(Gamma+Kappa+Lambda)*(exp(Gamma*(T-t))-1)+2*Gamma;
    Temp2=2*Gamma*exp((Gamma+Kappa+Lambda)*(T-t)/2);
    Temp3=2*(exp(Gamma*(T-t))-1);

    %��ȡ��Ϣծȯ�۸����A��B
    A = (Temp2/Temp1)^(2*Kappa*Theta/Sigma^2);
    B = Temp3/Temp1;

    %�������ʵ�ģ��
    r = r + Kappa*(Theta-r)*dT + Sigma*sqrt(r)*sqrt(dT)*randn(1);

    %��ʱ��t,����ΪT-t����Ϣ����RΪ��
    R(i,1) = (r*B-log(A))/(T-t);
    t=t+dT;
 end

 %����������޽ṹ��һ��·����
 plot([dT:dT:T], r);

 end