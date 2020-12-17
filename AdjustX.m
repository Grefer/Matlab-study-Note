%% ����˵��
% St---t�չɼ�
% X---��ʼת�ɼ�
% r---�޷�������
% t---��������ʱ��
% T---������
% sigma---������
% I---t��Ӧ����Ϣ
% P---���ۼ۸�
function K = AdjustX(St,X,r,t,T,sigma,I,CP)
    K = X;
    W = blsprice(St,K,r,T-t,sigma)*100/K + (100+I)*exp(-r*(T-t));
    while abs(W-CP) > 0.001
        if W > CP
            continue
        else
            K = K - 0.01;
        end
    end
end