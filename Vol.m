function [Fvol_GRACH,Fvol_EGARCH,Hvol] = Vol(Code,B1,E1,B2,E2,Exchange)
      
    %ģ���������
    begintime = B1;
    endtime = E1;
    [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid] = w.wsd(Code,'close',begintime,endtime,'Priceadj=B','tradingcalendar=''Exchange','Days=Trading')  %��ȡ���̼ۣ���Ȩ��
    SA = [w_wsd_times,w_wsd_data]
    SA = rmmissing(SA);    %�����ֵ
    time = datetime(SA(:,1),'ConvertFrom','datenum');   %�����ݵ�һ��תΪdatetime���鲢����Ϊtime
    prices = SA(:,2);
    LogReturns1 = diff(log(prices));
    %����&test����
    begintime = B2;
    endtime = E2;
    [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid] = w.wsd(Code,'close',begintime,endtime,'Priceadj=B','tradingcalendar=''Exchange','Days=Trading')  %��ȡ���̼ۣ���Ȩ��
    SA = [w_wsd_times,w_wsd_data]
    SA = rmmissing(SA);    %�����ֵ
    time = datetime(SA(:,1),'ConvertFrom','datenum');   %�����ݵ�һ��תΪdatetime���鲢����Ϊtime
    prices = SA(:,2);
    LogReturns2 = diff(log(prices));
    tradingDays = 252;
    %����GARCH��EGARCH����
    function vol = fun1(LogReturns)
        md1 = garch('GARCHLags',1,'ARCHLags',1,'Offset',NaN,'Distribution','t')
        GARCH = estimate(md1,LogReturns)
        V0 = infer(GARCH,LogReturns);
        [V,Y] = simulate(GARCH,252,'NumPaths',10000,'E0',LogReturns,'V0',V0)
        vol = mean(std(Y))*sqrt(tradingDays); 
    end

    function vol = fun2(LogReturns) 
        md2 = egarch('GARCHLags',1,'ARCHLags',1,'LeverageLags',1,'Offset',NaN,'Distribution','t')
        EGARCH = estimate(md2,LogReturns);
        V0 = infer(EGARCH,LogReturns);
        [V,Y] = simulate(EGARCH,252,'NumPaths',10000,'E0',LogReturns,'V0',V0);
        vol = mean(std(Y))*sqrt(tradingDays);
    end
    
    %Ԥ�Ⲩ����&��ʷ������
    Fvol_GRACH = fun1(LogReturns2);
    Fvol_EGRACH = fun2(LogReturns2);
    Hvol = std(LogReturns2)*sqrt(tradingDays);
   
end

