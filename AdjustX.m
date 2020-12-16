%% 参数说明
% St---t日股价
% X---初始转股价
% r---无风险利率
% t---触发回售时点
% T---到期日
% sigma---波动率
% I---t日应计利息
% P---回售价格
function K = AdjustX(St,X,r,t,T,sigma,I,P)
    K = X;
    d1 = (log(St/K) + (r + 0.5 * sigma^2)*(T-t))/(sigma * sqrt(T-t));
    d2 = d1 - sigma*sqrt(T-t);
    pd = makedist('Normal');
    W = (St*cdf(pd,d1) - K*exp(-r*(T-t))*cdf(pd,d2))*100/K + (100+I)*exp(-r*(T-t));
    while abs(W-P) > 0.001
        if W > P
            continue
        else
            K = K - 0.01;
        end
    end
end