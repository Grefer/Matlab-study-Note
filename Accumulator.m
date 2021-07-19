function price = Accumulator(S0,r,sigma,T,nStep,nPath,K,KS,KO,Vc,Va)
%累积/累沽期权定价

s = sPath(S0,r,sigma,T,nStep,nPath);
X = ones(nStep,nPath);
V = ones(nStep,nPath);
cashflow = zeros(nStep,nPath);


for j = 1:nPath
    for i = 1:nStep
        discountfactor(j,i) = exp(-r/365*(i-1));
        if s(j,i) < KO
            X(j,i:-1:1) = K;
            X(j,i:nStep) = KS;
            V(j,i) = Vc/T;
            cashflow(j,i) = (s(j,i)-X(j,i)).*V(j,i)
        elseif s(j,nStep) >= K
            X(j,i) = K;
            V(j,i) = Vc/T;
            cashflow(j,i) = (s(j,i)-X(j,i)).*V(j,i)
        else
            X(j,i) = K;
            V(j,i) = (Vc+Va)/T;
            cashflow(j,i) = (s(j,i)-X(j,i)).*V(j,i)
        end
    end
end
pv = sum(cashflow.*discountfactor,2);
price = mean(pv);
            
            
        end
        
