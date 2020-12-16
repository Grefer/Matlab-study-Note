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
    W = blsprice(St,K,r,T-t,sigma)*100/K + (100+I)*exp(-r*(T-t));
    while abs(W-P) > 0.001
        if W > P
            continue
        else
            K = K - 0.01;
        end
    end
end