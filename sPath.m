function PricePath = sPath(S0,r,sigma,T,nStep,nPath)
    dt = T/nStep;          %设定步长
    PricePath = zeros(nPath ,1 + nStep);
    PricePath(:,1) = S0;            %初始化S0
    nudt = (r - 0.5 * sigma^2) * dt;
    sigmadt = sigma * sqrt(dt);
    for i = 1:nPath
        for j = 1:nStep
            PricePath(i,j+1) = PricePath(i,j) * exp(nudt + sigmadt *randn);
        end
    end
    figure
    
    for i = 1:nPath
        plot(1:length(PricePath(i,:)),PricePath(i,:))
        hold on;
    end
    hold off;
    title('Simulation');
    xlabel('Step')
    ylabel('Stock Price')

end