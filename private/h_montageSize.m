function montage = h_montageSize(num)

montage = [1,1] * ceil(sqrt(num));
if (montage(1)-1)*montage(2) >= num
    montage(1) = montage(1)-1;
end