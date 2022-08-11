function rgbimage = ss_makeRGBLifetimeMap(lifetimeMap,lifetime_limit,project,lutlim)

%Drawing
rgbimage = spc_im2rgb(lifetimeMap, lifetime_limit);
low = lutlim(1);
high = lutlim(2);

if high-low > 0
    gray = (project-low)/(high - low);
else
    gray = 0;
end
gray(gray > 1) = 1;
gray(gray < 0) = 0;
rgbimage(:,:,1)=rgbimage(:,:,1).*gray;
rgbimage(:,:,2)=rgbimage(:,:,2).*gray;
rgbimage(:,:,3)=rgbimage(:,:,3).*gray;

%spc.rgbLifetime = rgbimage;
