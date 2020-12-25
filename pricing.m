function p = pricing(S0,X,T,r,sigma,n,nPath,CP,coupon)
    %coupon是债券息票矩阵
    s = sPath(S0,r,sigma,T,n*T,nPath);
    X = X * ones(nPath,n*T);
    p = zeros(nPath,1);
    for j = 1:nPath
        for k = 4:T-1
            for i = (1+k*n):(k+1)*n-30*floor((k+1)/T)
                if s(j,i:i+29) < (X(j,i+29)*0.7)
                    X(j,(i+29):end) = AdjustX(s(j,i+29),X(j,i+29),r,(i+29)/n,T,sigma,coupon)
                end
            end
        end
        for a = 
    

            