function p = pricing(S0,X,T,r,coupon,sigma,CP,nStep,nPath)
    dt = T/nStep;          %设定步长
    s = zeros(nPath ,nStep);
    s(:,1) = S0;            %初始化S0
    for j = 1:nPath
        for i = 1:nStep-1
            s(j,i+1) = s(j,i) * exp((r-0.5*sigma^2)*dt + sigma*sqrt(dt) *randn);
        end
    end
    X = X * ones(nPath,1);
    num0 = 0;
    num1 = 1;
    p = zeros(nPath,1);
    for j = 1:nPath
        for k = T-2:T-1
            for i = (1+k*nStep/T : ((k+1)*nStep/T-30*floor((k+1)/T)
                if s(j,i:i+29) < (X(j,1)*0.7)
                    %X(j,1) = X(j,1)*mean(s(j,i:i+29));
                    W = blsprice(s(j,i+29),X,r,k,sigma)*100/X + (100+coupon(k+1)*round(i+29-k*nStep/T)/250)*exp(-r*(i+29)/(nStep/T));
                    while abs(W-CP) > 0.001
                        if W > CP
                            continue
                        else
                            X(j,1) = X(j,1) - 0.01;
                        end
                    end
                    break
                end
            end
            