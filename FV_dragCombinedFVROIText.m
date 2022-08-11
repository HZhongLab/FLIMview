function FV_dracurrentObjmbinedFVROIText

currentAxes = gca; %lock it in case it is changed during execution.
currentObj = gco;
[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst;

ROIObj = findobj(handles.FLIMview,'Tag','FV_ROI');
ROEObj = findobj(handles.FLIMview, 'tag', 'FV_ROE');
bgROIObj = findobj(handles.FLIMview,'Tag','FV_BGROI');
combinedROIObj = findobj(handles.FLIMview,'Tag','combinedFVROI');
set(vertcat(ROIObj, ROEObj, bgROIObj, combinedROIObj), 'Selected','off', 'SelectionHighlight','off', 'linewidth',1);

set(currentObj,'Selected','on','SelectionHighlight','on');

t0 = clock;
UserData = get(currentObj,'UserData');

for j = 1:length(ROIObj)
    roiUserData = get(ROIObj(j), 'UserData');
    if any(UserData.combinedROINumbers == roiUserData.number)
        set(ROIObj(j), 'lineWidth',3);
    end
end

if isfield(UserData,'timeLastClick') && etime(t0,UserData.timeLastClick) < 0.4
    delete(currentObj);
    combinedROIObj(combinedROIObj==currentObj) = [];
    
    % un-highlight the ROI associated with the deleted combinedFVROI
    set(vertcat(ROIObj, ROEObj, bgROIObj, combinedROIObj), 'Selected','off', 'SelectionHighlight','off', 'linewidth',1);
    
    % re-number the combined ROIs.
    if numel(combinedROIObj)>0
        combinedFVROI_UData = get(combinedROIObj, 'UserData');
        if numel(combinedROIObj)>1
            combinedFVROI_UData = cell2mat(combinedFVROI_UData);
        end
        [numbers, I] = sort([combinedFVROI_UData.number]);%%%%%% working here.
        for i = 1:length(I)
            combinedFVROI_UData(I(i)).number = i + 1000;
            set(combinedFVROI_UData(I(i)).texthandle,'String',num2str(i + 1000),'UserData',combinedFVROI_UData(I(i)));
        end
    end
    return;
else
    UserData.timeLastClick = t0;
    set(currentObj,'UserData',UserData);
end

% rect = [UserData.x - 2.5, UserData.y - 2.5, 5, 5]
% finalRect = dragrect(rect)
% 
% UserData.x = finalRect(1) + finalRect(3)/2;
% UserData.y = finalRect(2) + finalRect(4)/2;
% set(UserData.texthandle, 'Position', [UserData.x, UserData.y], 'UserData',UserData);


currentcurrentAxesUnit = get(currentAxes,'Unit');
set(currentAxes,'Unit','normalized');
rectFigure = get(handles.FLIMview, 'Position');
rectAxes = get(currentAxes, 'Position');
set(currentAxes,'Unit',currentcurrentAxesUnit);

Xlimit = get(currentAxes, 'XLim');
Ylimit = get(currentAxes, 'Ylim');
Ylim = Ylimit(2)-Ylimit(1);
Xlim = Xlimit(2)-Xlimit(1);
xmag = (rectFigure(3)*rectAxes(3))/Xlim;  %pixel/screenpixel
xoffset =rectAxes(1)*rectFigure(3);
ymag = (rectFigure(4)*rectAxes(4))/Ylim;
yoffset = rectAxes(2)*rectFigure(4);

% h = currentObj;

RoiRect = [UserData.roi.xi - 2.5, UserData.roi.yi - 2.5, 5, 5];
rect1w = RoiRect(3)*xmag;
rect1h = RoiRect(4)*ymag;
rect1x = (RoiRect(1)-Xlimit(1))*xmag+xoffset;
rect1y = (Ylimit(2) - RoiRect(2))*ymag + yoffset - rect1h;
rects = [rect1x, rect1y, rect1w, rect1h];

finalRect = dragrect(rects);

newRoiw = finalRect(3)/xmag;
newRoih = finalRect(4)/ymag;
newRoix = (finalRect(1) - xoffset)/xmag +Xlimit(1);
newRoiy = Ylimit(2) - (finalRect(2) - yoffset + finalRect(4))/ymag;
UserData.roi.xi = newRoix + 0.5 * newRoiw;
UserData.roi.yi = newRoiy + 0.5 * newRoih;
set(UserData.texthandle, 'Position', [UserData.roi.xi, UserData.roi.yi], 'UserData',UserData);


% ss_roiQuality;