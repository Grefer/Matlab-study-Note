function p = LSM(r,X,T,s,coupon)
[nPath,nStep] = size(s);
nStep = nStep -1;        
dt = T/nStep;             %�趨����
cashflow = zeros(size(s));   %�趨�ֽ�������
cashflow(:,end) = max(100*s(:,end)/X-102,0);   %���㵽����Ȩ��ֵ�ֽ���
mtime = (nStep + 1)*ones(1,nPath);      %��¼��Ȩ����ִ��ʱ�̣���ʼ��Ϊ��ĩʱ��
for j = size(s,2)-1:-1:2         %����ĩǰһ��ʱ�̵��Ƶ���ǰ��һ��ʱ�̣�����Ϊ-1��
    cashflow(:,j) = max(100*s(:,j)/X-102,0);   %�����i��·����ʵֵ��Ȩ��ֵ�ֽ���
    m = find(cashflow(:,j) > 0);        %������Ȩ���ڼ��ڵ�·��
    cf = cashflow(j+1,m);          %ȡ����·������Ȩ��ֵ�ֽ���
    v = cf.*(exp(-r * dt));          %�ֽ���������ǰһʱ��
    s = s(j,m);           %��ʱ��ģ��Ĺɼ�
    md = fitlm(s,v,'purequadratic');    %�ع�ģ�����
    fun = @(x) (md.Coefficients.Estimate(1) + md.Coefficients.Estimate(2) .* x ...
         +md.Coefficients.Estimate(3) .* x .^ 2);     %���ع鷽�̲���
    HV = fun(s);     %������������Ԥ���ĳ�����Ȩ�ļ�ֵ
    m1 = cashflow(j,m) > HV;   %��m��·���ϱȽϵ�i��ʱ�̳��м�ֵ�ͼ��ڼ�ֵ��С
    cashflow(j+1:end,m(m1)) = 0;   %���м�ֵС�ڼ��ڼ�ֵ������ִ�У�iʱ�̺��ֽ���ȫ��Ϊ0
    n = setdiff(1:nPath,m(m1));    %������Ȩ���ڷǼ��ڵ�·��(����������ִ�е�·��)
    cashflow(j,n) = cashflow(j+1,n) .* exp(-r * dt);   %��o��·���Ͻ�i+1ʱ�̵���Ȩ��ֵ���ֵ�iʱ��
    mtime(m(m1)) = j;   %������Ȩ����ִ��ʱ��
end
%���ղ�����ÿ��·�����ֽ������ֻص�ǰ��ʱ��
for j =  1:nPath
    cashflow(1:j) = cashflow(mtime(j),j) * exp(-r * (mtime(j) - 1)* dt);
end
p = mean(cashflow(1,:));      %�����ֵ���
end
