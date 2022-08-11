function ind = h_getindex(siz,BW,z)

ind = [];


if length(siz) == 1
    siz = [siz,siz,1];
elseif length(siz) == 2
    siz = [siz,1];
end

ind2 = find(BW);
L = ones(length(ind2),1);

for i = 1:length(z)
    ind = [ind;sub2ind([siz(1)*siz(2),siz(3)],ind2,z(i)*L)];
end