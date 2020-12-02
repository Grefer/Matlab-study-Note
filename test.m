begintime = '20190101';
endtime = '20200101';
code = '600029.SH';
Exchange = 'SSE' ;
[w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid] = w.wsd(code,'close',begintime,endtime,'Priceadj=B',['tradingcalendar=',Exchange] ,'Days=Trading')  %获取收盘价（后复权）