function [data1] = DataProcess2(data1,T)

for t = 1:T
        if data1(t) <= -998 || data1(t) == -99.99
            data1(t) = NaN;
        end
end