function offset = h_corr(reference,newimg)

% first dimension is y, second is x.

cc = normxcorr2(reference,newimg); 
[max_cc, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
offset = [ (ypeak-size(reference,1)), (xpeak-size(reference,2)) ];
