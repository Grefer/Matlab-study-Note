function s = sPath(S0,r,sigma,T,nStep,nPath)
    dt = T/nStep;          %设定步长
    s = zeros(nPath ,nStep);
    s(:,1) = S0;            %初始化S0
    for j = 1:nPath
        for i = 1:nStep-1
            s(j,i+1) = s(j,i) * exp((r-0.5*sigma^2)*dt + sigma*sqrt(dt) *randn);
        end
    end
    figure
    for j = 1:nPath
        plot(1:length(s(j,:)),s(j,:))
        hold on;
    end
    hold off;
    title('Simulation');
    xlabel('Step')
    ylabel('Stock Price')
end