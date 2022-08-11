function climit = h_climit(data,start_per,end_per)

if ~(exist('start_per')==1)|isempty(start_per)
    start_per = 0.05;
end

if ~(exist('end_per')==1)|isempty(end_per)
    end_per = 0.99;
end

try
    temp = sort(data(:));
    temp (isnan(temp)) = [];
    climit = double([temp(round(start_per*length(temp))),temp(round(end_per*length(temp)))]);
catch
    climit = [0,0];
end