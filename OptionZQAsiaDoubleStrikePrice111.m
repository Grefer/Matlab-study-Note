function price=OptionZQAsiaDoubleStrikePrice111(s00,s0,sr,K1,r,T,sigma,N,resdays)

rng(10)

% ˫ִ�м۸�K1=�볡�۸�K2=�볡�۸�Ӽ�һ����ֵ
% ��ʼʱ�볡��s00һ�����s0���������ѿ�ʼ���õ�����ʼ��s0ģ�������·��
% sr �ɼ�����ʵ������,1Xn������,��ʼʱȡֵ[]

%������ĳһ��ɼ۵����볡�۸�-���׼۸��������=min[��K1-K2��,K1-��Ȩ�����]+���ף���֮min[��K1-K2��,K1-��Ȩ�����]
%��С�������ؿ���ģ�ⷽ��
%TΪ����ʱ�䣬NΪ�����ڳ��ȣ�T>=N��TȡֵΪ�����������껯ʱ��
%-1Ϊ����
%by QS



delt=1/243;
M=50000;

%s=zeros(M,T);
% for j=1:M
%     %�ڻ��۸��ģ�⡣�����������磬�ڻ�Ԥ��������Ϊ0.
%     s(j,1)=s0*exp((0-sigma^2/2)*delt+normrnd(0,sigma*sqrt(delt)));
%     for i=2:T
%         s(j,i)=s(j,i-1)*exp((0-sigma^2/2)*delt+normrnd(0,sigma*sqrt(delt)));
%     end;
% end

%���ö�ż������������

price_ls = zeros(M,1);
if resdays>=N   %ֻҪʣ���������ڵ��ڲɼ��������Ͳ����ں�֮ǰ��·��
    T=resdays;
    s1=zeros(M/2,T);
    s2=zeros(M/2,T);
    for j=1:M/2
        %�ڻ��۸��ģ�⡣�����������磬�ڻ�Ԥ��������Ϊ0.
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
            if min(s(i,T-N+1:T))<K1 %����ע��K1����s0�п��ܸĶ�

                price_ls(i,1)=(max(284.09,K1-mean(min(s00,s(i,T-N+1:T)),2)))*exp(-r*delt*resdays);%mean(X,2)ÿ��ƽ��ֵ��2������
            else
                price_ls(i,1)=0;
            end        
%     else
%         yy=max(mean(s(:,T-N+1:T),2)-K,minPay)*exp(-r*delt*resdays);
        end
else

    s1=zeros(M/2,resdays);
    s2=zeros(M/2,resdays);
    %avgsp=avgp*(N-resdays);%avgpΪ�ѽ����Ĳɼ������볡�ۺ����̼۽�Сֵ�ľ���
    for j=1:M/2
        %�ڻ��۸��ģ�⡣�����������磬�ڻ�Ԥ��������Ϊ0.
        rand1=normrnd(0,sigma*sqrt(delt));
        s1(j,1)=s0*exp((0-sigma^2/2)*delt+rand1);%��������Ѿ����������s0Ҫ�����µĵ�ǰs
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
        if min(s(i,:))<K1 %�������������s00���п��ܸĶ�
            price_ls(i,1)=(max(284.09,K1-mean(min(s00,s(i,T-N+1:T)),2)))*exp(-r*delt*resdays);%mean(X,2)ÿ��ƽ��ֵ��2������
        else
            price_ls(i,1)=0;
        end        
    end
end



price=mean(price_ls);


end

%delta=(OptionZQAsiaDoubleStrikePrice(24000,24000+20,[],24000,23000,0.03,23,0.35,23,23,200)-OptionZQAsiaDoubleStrikePrice(24000,24000-20,[],24000,23000,0.03,23,0.35,23,23,200))/40*����/16