function simu = simulatePath(S0,r,sigma,T,nStep,nPath)
dT = T/nStep;          %�趨����
simu = NaN(nStep + 1,nPath);
simu(1,:) = S0;            %�趨��ʼֵ
mu = (r - 0.5 * sigma ^2) * dT;
sigmadT = sigma * sqrt(dT);
for i = 1:nPath
    for j = 1:nStep
        simu(j+1,i) = simu(j,i) * exp(mu + sigmadT *randn);
    end
end
end