function FV_copyROIImg(handles)

% [currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

selectedROIObj = findobj(handles.FLIMview,'Tag','FV_ROI', 'Selected', 'on');
if ~isempty(selectedROIObj)
    % first find the image axes and get the image
    parentObj = get(selectedROIObj, 'parent');
    % then get the image
    imgObj = findobj(parentObj, 'Type', 'image');
    img = get(imgObj, 'CData');
    climit = get(parentObj, 'CLim');% climit is a axes property; this is no need if it is RGB image (e.g. MPET maps). but also does not hurt.
    cmap = get(handles.FLIMview, 'Colormap'); % colormap is figure property
    
    % now get the ROI info.
    UserData = get(selectedROIObj,'UserData');
    BW = roipoly(img, UserData.roi.xi, UserData.roi.yi);
    xInd = round(min(UserData.roi.xi):max(UserData.roi.xi));
    yInd = round(min(UserData.roi.yi):max(UserData.roi.yi));

    img1 = img.*repmat(BW, 1, 1, size(img, 3)); % this can provide a highlighted view for round and roipoly ROIs.
    img2 = img1(yInd, xInd, :);
    disp(['Copied ROI size = [',num2str(length(yInd)), ', ', num2str(length(xInd)),']']); 
    figureXSize = 2*(length(xInd)+1);%plus 1 because in image there is half more pixel on each side.
    figureYSize = 2*(length(yInd)+1);
    
    % on my laptop, see like x cannot be smaller than 242...
    if figureXSize < 250
        figureYSize = figureYSize/figureXSize*250;%need to change ySize first before changing xSize.
        figureXSize = 250;
    end
    
    h = figure('units', 'pixel', 'position',[100 100 figureXSize figureYSize]);
    if size(img,3)>1 %RGB image
        h_imagesc(img2);%this is an RGB image.
    else
        h_imagesc(img2, climit);
        colormap(cmap);
    end
    print('-dbitmap','-noui','-zbuffer',h);%"zbuffer" does not give the partial outline at the edge of images.
    delete(h);
else
    disp('No selected ROI');
end
