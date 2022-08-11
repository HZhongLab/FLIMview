function d = h_calcDistance(pos1,pos2)

if size(pos1,1)==1 && size(pos2,1)>1
    pos1 = repmat(pos1, [size(pos2,1), 1]);
elseif size(pos1,1)>1 && size(pos2,1)==1
    pos2 = repmat(pos2, [size(pos1,1), 1]);
end

d = sqrt(sum((pos1-pos2).^2,2));
    