function [Fvol_GARCH,Fvol_EGARCH,Hvol] = Vol(code,B1,E1,B2,E2,Exchange)
    w = windmatlab;  
    %Modeling Interval
    begintime = B1;
    endtime = E1;
    [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid] = w.wsd(code,'close',begintime,endtime,'Priceadj=B',['tradingcalendar=',Exchange],'Days=Trading');  %获取收盘价（后复权）
    data = [w_wsd_times,w_wsd_data];
    data = rmmissing(data);    %clear NAN
    prices = data(:,2);
    LogReturns1 = diff(log(prices));
    
    %Estimate Interval & Test Sample
    begintime = B2;
    endtime = E2;
    [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid] = w.wsd(code,'close',begintime,endtime,'Priceadj=B',['tradingcalendar=',Exchange],'Days=Trading');  %获取收盘价（后复权）
    data = [w_wsd_times,w_wsd_data];
    data = rmmissing(data);    %clear NAN
    prices = data(:,2);
    LogReturns2 = diff(log(prices));
    tradingDays = 252;
    
    %Define GARCH & EGRACH
    function vol = fun1(LogReturns)
        md1 = garch('Offset',NaN,'GARCHLags',1,'ARCHLags',1,'Distribution','t');
        GARCH = estimate(md1,LogReturns);
        V01 = infer(GARCH,LogReturns);
        [V1,Y] = simulate(GARCH,252,'NumPaths',10000,'E0',LogReturns,'V0',V01);
        vol = mean(std(Y))*sqrt(tradingDays); 
%         figure
%         subplot(2,1,1)
%         plot(V1(:,1:100))
%         title('GARCH Simulated Conditional Variance')
%         subplot(2,1,2)
%         plot(Y(:,1:100))
%         title('GARCH Simulated Returns')
    end

    function vol = fun2(LogReturns) 
        md2 = egarch('GARCHLags',1,'ARCHLags',1,'LeverageLags',1,'Distribution','t');
        EGARCH = estimate(md2,LogReturns);
        V02 = infer(EGARCH,LogReturns);
        [V2,Y] = simulate(EGARCH,252,'NumPaths',10000,'E0',LogReturns,'V0',V02);
        vol = mean(std(Y))*sqrt(tradingDays);
%         figure
%         subplot(2,1,1)
%         plot(V2(:,1:100))
%         title('EGARCH Simulated Conditional Variance')
%         subplot(2,1,2)
%         plot(Y(:,1:100))
%         title('EGRACH Simulated Returns')
    end
    
    %Estimated Volatility & Historical Volatility
    Fvol_GARCH = fun1(LogReturns1);
    Fvol_EGARCH = fun2(LogReturns1);
    Hvol = std(LogReturns2)*sqrt(tradingDays);
   
end

