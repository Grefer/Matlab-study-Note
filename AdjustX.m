function K = AdjustX(St,X,r,t,T,sigma,coupon)
    K = X;
    CP = 100 + coupon(ceil(t))*(t-fix(t));
    i = 0;
    I = 0;
    while i < (T-t)
        I = I + coupon(6-i)*exp(-r*(T-t-i));
        i = i+1;
    end
    W = blsprice(St,K,r,T-t,sigma)*fix(100/K)+(100/K-fix(100/K)) + (100*exp(-r*(T-t))+I);
    while abs(W-CP) > 0.01
        if W > CP
            return
        else
            K = K - 0.01;
        end
        W = blsprice(St,K,r,T-t,sigma)*100/K + (100*exp(-r*(T-t))+I);
    end
end