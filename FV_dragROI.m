function FV_dragROI

currentObj = gco;
currentAxes = gca; %lock it in case it is changed during execution.
currentFig = gcf; %nail it now in case that it change during execution.

if strcmpi(get(currentAxes, 'tag'), 'intensityImgAxes') % if in intensity
    otherAxes = 'lifetimeImgAxes';
elseif strcmpi(get(currentAxes, 'tag'), 'lifetimeImgAxes')
    otherAxes = 'intensityImgAxes';
else
    return; %should never happen. But copy the code from elsewhere so keep it.
end

handles = guihandles(currentFig);

% h_showRoi3(handles);

point1 = get(currentAxes,'CurrentPoint'); % button down detected
point1 = point1(1,1:2);              % extract x and y

ROIObj = findobj(currentAxes,'Tag','FV_ROI');
ROEObj = findobj(currentAxes, 'Tag', 'FV_ROE');
bgROIObj = findobj(currentAxes,'Tag','FV_BGROI');

combinedROIObj = findobj(currentFig,'Tag','combinedFVROI');

ROIObj2 = findobj(handles.(otherAxes),'Tag','FV_ROI');
ROEObj2 = findobj(handles.(otherAxes), 'Tag', 'FV_ROE');
bgROIObj2 = findobj(handles.(otherAxes),'Tag','FV_BGROI');

set(vertcat(ROIObj, ROEObj, bgROIObj, combinedROIObj), 'Selected','off', 'SelectionHighlight','off', 'linewidth',1);
set(vertcat(ROIObj2, ROEObj2, bgROIObj2), 'Selected','off', 'SelectionHighlight','off', 'linewidth',1);

set(currentObj,'Selected','on','SelectionHighlight','off','linewidth',3);

t0 = clock;
UserData = get(currentObj,'UserData');
if isfield(UserData,'timeLastClick') && etime(t0,UserData.timeLastClick) < 0.4
    delete([gco, UserData.texthandle, UserData.mirrorTexthandle, UserData.mirrorROIhandle]);
    if strcmpi(UserData.ROIType, 'FV_ROI') %adjust the ROI numbers if one is deleted.
        ROIObj = findobj(currentAxes,'Tag','FV_ROI');% do this again since there is one less
        ROI_UData = get(ROIObj, 'UserData');
        if ~isempty(ROI_UData) % this can happen when the last ROI is deleted.
            if iscell(ROI_UData) % ROI_UData is a cell if numel(ROIObj)>1
                ROI_UData = cell2mat(ROI_UData);
            end
            [ROINumbers, I] = sort([ROI_UData.number]);
        else
            I = [];
        end
        
        for i = 1:length(ROIObj)
            ROI_UData(i).number = I(i);
            set(ROI_UData(i).texthandle,'String',num2str(I(i)),'UserData',ROI_UData(i));
            set(ROIObj(i),'UserData',ROI_UData(i));
            
            % deal with the mirror ROI
            ROI_UData2 = get(ROI_UData(i).mirrorROIhandle, 'UserData');
            ROI_UData2.number = I(i);
            set(ROI_UData(i).mirrorTexthandle,'String',num2str(I(i)),'UserData',ROI_UData2);
            set(ROI_UData(i).mirrorROIhandle,'UserData',ROI_UData2);        
        end
        
        % also need to remove from combinedFVROI list
        if numel(combinedROIObj)>0
            combinedFVROI_UData = get(combinedROIObj, 'UserData');
            if numel(combinedROIObj)>1
                combinedFVROI_UData = cell2mat(combinedFVROI_UData);
            end
            for k = 1:numel(combinedFVROI_UData)
                combinedFVROI_UData(k).combinedROINumbers(combinedFVROI_UData(k).combinedROINumbers==UserData.number) = [];
                set(combinedROIObj(k), 'UserData', combinedFVROI_UData(k));
            end
        end
    end
    return;
else
    UserData.timeLastClick = t0;
    set(currentObj,'UserData',UserData);
end

currentGcaUnit = get(gca,'Unit');
set(gca,'Unit','normalized');
rectFigure = get(currentFig, 'Position');
rectAxes = get(gca, 'Position');
set(gca,'Unit',currentGcaUnit);

Xlimit = get(gca, 'XLim');
Ylimit = get(gca, 'Ylim');
Ylim = Ylimit(2)-Ylimit(1);
Xlim = Xlimit(2)-Xlimit(1);
xmag = (rectFigure(3)*rectAxes(3))/Xlim;  %pixel/screenpixel
xoffset =rectAxes(1)*rectFigure(3);
ymag = (rectFigure(4)*rectAxes(4))/Ylim;
yoffset = rectAxes(2)*rectFigure(4);

lockROI = get(handles.lockROI,'Value');
if iscell(lockROI)
    lockROI = lockROI{1};
end

if lockROI
    h = vertcat(ROIObj, ROEObj, bgROIObj);
else
    h = currentObj;
end

for i = 1:length(h)
    UData{i} = get(h(i),'UserData');
    RoiRect(i,:) = [min(UData{i}.roi.xi),min(UData{i}.roi.yi),...
            max(UData{i}.roi.xi)-min(UData{i}.roi.xi),max(UData{i}.roi.yi)-min(UData{i}.roi.yi)];
    rect1w = RoiRect(i,3)*xmag;
    rect1h = RoiRect(i,4)*ymag;
    rect1x = (RoiRect(i,1)-Xlimit(1))*xmag+xoffset;
    rect1y = (Ylimit(2) - RoiRect(i,2))*ymag + yoffset - rect1h;
    rects(i,:) = [rect1x, rect1y, rect1w, rect1h];
end

if length(h)==1 && point1(1)>(RoiRect(1)+3/4*RoiRect(3)) && point1(2)>(RoiRect(2)+3/4*RoiRect(4))
    finalRect = rbbox(rects, [rect1x, rect1y+rect1h]);
else
    finalRect = dragrect(rects);
end

for i = 1:length(h)
    newRoiw = finalRect(i,3)/xmag;
    newRoih = finalRect(i,4)/ymag;
    newRoix = (finalRect(i,1) - xoffset)/xmag +Xlimit(1);
    newRoiy = Ylimit(2) - (finalRect(i,2) - yoffset + finalRect(i,4))/ymag;
    
    if RoiRect(i,3) == 0 % it can give Nan and eventually casue error if the ROI size is zero.
        UData{i}.roi.xi = (UData{i}.roi.xi - RoiRect(i,1)) + newRoix;
    else
        UData{i}.roi.xi = (UData{i}.roi.xi - RoiRect(i,1))/RoiRect(i,3)*newRoiw + newRoix;
    end

    if RoiRect(i,4) == 0 % it can give Nan and eventually casue error if the ROI size is zero.
        UData{i}.roi.yi = (UData{i}.roi.yi - RoiRect(i,2)) + newRoiy;
    else
        UData{i}.roi.yi = (UData{i}.roi.yi - RoiRect(i,2))/RoiRect(i,4)*newRoih + newRoiy;
    end

    set(h(i),'XData',UData{i}.roi.xi,'YData',UData{i}.roi.yi,'UserData',UData{i});
    set(UData{i}.texthandle, 'Position', [newRoix+newRoiw/2,newRoiy+newRoih/2],'UserData',UData{i});
    
    % deal with the mirror ROI
    UData2 = get(UData{i}.mirrorROIhandle, 'UserData');
    UData2.roi = UData{i}.roi;
    set(UData{i}.mirrorROIhandle,'XData',UData{i}.roi.xi,'YData',UData{i}.roi.yi,'UserData',UData2);
    set(UData{i}.mirrorTexthandle, 'Position', [newRoix+newRoiw/2,newRoiy+newRoih/2],'UserData',UData2);

end

FV_roiQuality(handles);