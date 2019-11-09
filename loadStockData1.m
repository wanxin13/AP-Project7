function [dates,past1mon,past212mon,past1360mon] = loadStockData1(path)

% past212 is past return from 2 months to 12 months

past1mon= xlsread(path,1,'B15:Z1083');
past212mon = xlsread(path,1,'AB15:AZ1083');
past1360mon = xlsread(path,1,'BB15:BZ1083');

date = xlsread(path,1,'A15:A1083');
date = num2str(date);
dates = datenum(date,'yyyymm');
