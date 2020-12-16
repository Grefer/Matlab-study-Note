%% ����˵��
% St---t�չɼ�
% X---��ʼת�ɼ�
% r---�޷�������
% t---��������ʱ��
% T---������
% sigma---������
% I---t��Ӧ����Ϣ
% P---���ۼ۸�
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