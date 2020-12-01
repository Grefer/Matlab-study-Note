function p = LSM(r,K,T,simu)
[nStep,nPath] = size(simu);
nStep = nStep -1;        
dT = T/nStep;             %设定步长
cashflow = zeros(size(simu));   %设定现金流矩阵
cashflow(end,:) = max(simu(end,:)-K,0);   %计算到期期权价值现金流
mtime = (nStep + 1)*ones(1,nPath);      %记录期权最优执行时刻，初始化为期末时点
for i = size(simu,1)-1:-1:2         %从期末前一个时刻递推到当前下一个时刻（步长为-1）
    cashflow(i,:) = max(simu(i,:)-K,0);   %计算第i条路径的实值期权价值现金流
    m = find(cashflow(i,:) > 0);        %查找期权处于价内的路径
    cf = cashflow(i+1,m);          %取价内路径的期权价值现金流
    v = cf.*(exp(-r * dT));          %现金流贴现至前一时刻
    s = simu(i,m);           %此时点模拟的股价
    md = fitlm(s,v,'purequadratic');    %回归模型拟合
    fun = @(x) (md.Coefficients.Estimate(1) + md.Coefficients.Estimate(2) .* x ...
         +md.Coefficients.Estimate(3) .* x .^ 2);     %求解回归方程参数
    HV = fun(s);     %条件期望方程预估的持有期权的价值
    m1 = cashflow(i,m) > HV;   %在m的路径上比较第i个时刻持有价值和价内价值大小
    cashflow(i+1:end,m(m1)) = 0;   %持有价值小于价内价值，立即执行，i时刻后现金流全部为0
    n = setdiff(1:nPath,m(m1));    %查找期权处于非价内的路径(即不会立即执行的路径)
    cashflow(i,n) = cashflow(i+1,n) .* exp(-r * dT);   %在o的路径上将i+1时刻的期权价值贴现到i时刻
    mtime(m(m1)) = i;   %更新期权最优执行时刻
end
%按照步长将每个路径的现金流贴现回当前零时刻
for i =  1:nPath
    cashflow(1:i) = cashflow(mtime(i),i) * exp(-r * (mtime(i) - 1)* dT);
end
p = mean(cashflow(1,:));      %计算均值输出
end
