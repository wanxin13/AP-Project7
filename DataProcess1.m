function [data1,data2,data3] = DataProcess1(data1,data2,data3,n,T)

for t = 1:T
    for i = 1:n
        if data1(t,i) <= -998 || data1(t,i) == -99.99
            data1(t,i) = NaN;
        end
    end
end

for t = 1:T
    for i = 1:n
        if data2(t,i) <= -998 || data2(t,i) == -99.99
            data2(t,i) = NaN;
        end
    end
end

for t = 1:T
    for i = 1:n
        if data3(t,i) <= -998 || data3(t,i) == -99.99
            data3(t,i) = NaN;
        end
    end
end

