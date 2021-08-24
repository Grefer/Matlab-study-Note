%自动获取品种各合约收盘价序列并支持合约换月调整
%By Grefer
w = windmatlab;
begintime = '20190702';        %时间序列开始时间
endtime = '20210809';          %时间序列结束时间
code = 'CU.SHF';               %标的品种
flag = 1;                      %换月价格调整开关：1开/-1关

[w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid] = w.wsd(code,'close,trade_hiscode',begintime,endtime,'Days=Trading');  
time = datetime(w_wsd_times,'ConvertFrom','datenum');
price = cell2mat(w_wsd_data(:,1));
contract = cell2mat(w_wsd_data(:,2));

if flag == 1
    for i = 2:length(time)
        if strcmpi(contract(i,:),contract(i-1,:)) == 0
            for j = max(i-5,1):i-1
                [w_wsd_data_1,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid] = w.wsd(contract(i,:),'close',time(j),time(j),'Days=Trading');
                price(j) = w_wsd_data_1;
            end
        end
    end
end
data = timetable(time,price,contract);
filename = 'C:\Users\Grefer\Desktop\Data.xlsx';        %导出Excel文件路径
writetimetable(data,filename);                         
