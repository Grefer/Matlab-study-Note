function Fvol_GARCH = Vol(code,B,E,Exchange)
    w = windmatlab; 
    %Modeling Interval
    begintime = B;
    endtime = E;
    [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid] = w.wsd(code,'close',begintime,endtime,'Priceadj=B',['tradingcalendar=',Exchange],'Days=Trading');  
    data = [w_wsd_times,w_wsd_data];
    data = rmmissing(data);    %clear NAN
    prices = data(:,2);
    LogReturns = diff(log(prices));
    tradingDays = 243;
    
    %Define GARCH & EGRACH
    function vol = fun(LogReturns)
        md1 = garch('Offset',NaN,'GARCHLags',1,'ARCHLags',1,'Distribution','t');
        opts = optimset('fmincon');
        opts.Algorithm = 'interior-point';    % 'sqp'
        GARCH = estimate(md1,LogReturns,'option',opts);
        vol = sqrt(GARCH.Constant/(1 - GARCH.GARCH{1} - GARCH.ARCH{1}))*sqrt(tradingDays); 
        
%         vF = forecast(GARCH,tradingDays,'Y0',LogReturns); 
%         vol = sqrt(mean(vF))*sqrt(tradingDays);

%         figure
%         subplot(2,1,1)
%         plot(V1(:,1:100))
%         title('GARCH Simulated Conditional Variance')
%         subplot(2,1,2)
%         plot(Y(:,1:100))
%         title('GARCH Simulated Returns')
    end

    %Estimated Volatility & Historical Volatility
    Fvol_GARCH = fun(LogReturns);
   
end

