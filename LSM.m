function p = LSM(r,K,T,simu)
[nStep,nPath] = size(simu);
nStep = nStep -1;        
dT = T/nStep;             %�趨����
cashflow = zeros(size(simu));   %�趨�ֽ�������
cashflow(end,:) = max(simu(end,:)-K,0);   %���㵽����Ȩ��ֵ�ֽ���
mtime = (nStep + 1)*ones(1,nPath);      %��¼��Ȩ����ִ��ʱ�̣���ʼ��Ϊ��ĩʱ��
for i = size(simu,1)-1:-1:2         %����ĩǰһ��ʱ�̵��Ƶ���ǰ��һ��ʱ�̣�����Ϊ-1��
    cashflow(i,:) = max(simu(i,:)-K,0);   %�����i��·����ʵֵ��Ȩ��ֵ�ֽ���
    m = find(cashflow(i,:) > 0);        %������Ȩ���ڼ��ڵ�·��
    cf = cashflow(i+1,m);          %ȡ����·������Ȩ��ֵ�ֽ���
    v = cf.*(exp(-r * dT));          %�ֽ���������ǰһʱ��
    s = simu(i,m);           %��ʱ��ģ��Ĺɼ�
    md = fitlm(s,v,'purequadratic');    %�ع�ģ�����
    fun = @(x) (md.Coefficients.Estimate(1) + md.Coefficients.Estimate(2) .* x ...
         +md.Coefficients.Estimate(3) .* x .^ 2);     %���ع鷽�̲���
    HV = fun(s);     %������������Ԥ���ĳ�����Ȩ�ļ�ֵ
    m1 = cashflow(i,m) > HV;   %��m��·���ϱȽϵ�i��ʱ�̳��м�ֵ�ͼ��ڼ�ֵ��С
    cashflow(i+1:end,m(m1)) = 0;   %���м�ֵС�ڼ��ڼ�ֵ������ִ�У�iʱ�̺��ֽ���ȫ��Ϊ0
    n = setdiff(1:nPath,m(m1));    %������Ȩ���ڷǼ��ڵ�·��(����������ִ�е�·��)
    cashflow(i,n) = cashflow(i+1,n) .* exp(-r * dT);   %��o��·���Ͻ�i+1ʱ�̵���Ȩ��ֵ���ֵ�iʱ��
    mtime(m(m1)) = i;   %������Ȩ����ִ��ʱ��
end
%���ղ�����ÿ��·�����ֽ������ֻص�ǰ��ʱ��
for i =  1:nPath
    cashflow(1:i) = cashflow(mtime(i),i) * exp(-r * (mtime(i) - 1)* dT);
end
p = mean(cashflow(1,:));      %�����ֵ���
end
