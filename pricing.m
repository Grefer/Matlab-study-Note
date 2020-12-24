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
    p = zeros(nPath,1);
    for j = 1:nPath
        for i = nStep/T*4:nStep-30
            if s(j,i:i+29) < (X(j,1)*0.7)
                k = i/(nStep/T)
                %X(j,1) = X(j,1)*mean(s(j,i:i+29));
                W = blsprice(s(j,i+29),X,r,k,sigma)*100/X + (100+coupon(ceil(k)*mod(i*T/nStep)/250)*exp(-r*k))
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
        for a = 
    

            