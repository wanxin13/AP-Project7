function [rmrf,SMB,HML,rf,UMD] = loadStockData2(path)


rmrf = xlsread(path,2,'B2:B1070');
SMB = xlsread(path,2,'C2:C1070');
HML = xlsread(path,2,'D2:D1070');
rf = xlsread(path,2,'E2:E1070');
UMD = xlsread(path,2,'F2:F1070');
