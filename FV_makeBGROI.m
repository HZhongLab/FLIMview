function FV_makeBGROI(handles)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

obj = get(handles.FLIMview, 'Children');%unselectAll.
set(obj, 'Selected', 'off');%unselectAll.
ROIObj = findobj(handles.FLIMview,'Tag','FV_ROI');
ROEObj = findobj(handles.FLIMview, 'tag', 'FV_ROE');
bgROIObj = findobj(handles.FLIMview,'Tag','FV_BGROI');
combinedROIObj = findobj(handles.FLIMview,'Tag','combinedFVROI');
set(vertcat(ROIObj, ROEObj, bgROIObj, combinedROIObj), 'Selected','off', 'SelectionHighlight','off', 'linewidth',1);

currentAxes = gca; %lock it in case it is changed during execution.

% below is for two purpose: 1) test whether it is the right axes is clicked
% and 2) for duplicating ROIs.
if strcmpi(get(currentAxes, 'tag'), 'intensityImgAxes') % if in intensity
    otherAxes = 'lifetimeImgAxes';
elseif strcmpi(get(currentAxes, 'tag'), 'lifetimeImgAxes')
    otherAxes = 'intensityImgAxes';
else
    return;
end
% above is for two purpose: 1) test whether it is the right axes is clicked
% and 2) for duplicating ROIs.

Roi_size = FV_getROISize(currentStruct.state.ROISizeOpt.value);

switch currentStruct.state.ROIShapeOpt.value
    case 1
        waitforbuttonpress;
        point1 = get(currentAxes,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(currentAxes,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);
        p1 = min(point1,point2);             % calculate locations
        offset = abs(point1-point2);
        if offset(1)<2 && offset(2)<2
            offset = [Roi_size, Roi_size];
        end
        ROI = [p1, offset(1), offset(2)];
        theta = (0:1/40:1)*2*pi;
        xr = ROI(3)/2;
        yr = ROI(4)/2;
        xc = ROI(1) + ROI(3)/2;
        yc = ROI(2) + ROI(4)/2;
        UserData.roi.xi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc;
        UserData.roi.yi = sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc;
    case 2
        waitforbuttonpress;
        point1 = get(currentAxes,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(currentAxes,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);
        p1 = min(point1,point2);             % calculate locations
        offset = abs(point1-point2);
        if offset(1)<2 && offset(2)<2
            offset = [Roi_size, Roi_size];
        end
        UserData.roi.xi = [p1(1),p1(1)+offset(1),p1(1)+offset(1),p1(1),p1(1)];
        UserData.roi.yi = [p1(2),p1(2),p1(2)+offset(2),p1(2)+offset(2),p1(2)];
    case 3
        waitforbuttonpress;
        [BW,UserData.roi.xi,UserData.roi.yi] = roipolyold;
    otherwise
        return;
end

% remove previous BG ROI so that there are only one BG
previousBGROIObj = findobj(currentAxes,'Tag','FV_BGROI');
if ~isempty(previousBGROIObj)
    previousUData = get(previousBGROIObj, 'UserData');
    delete([previousUData.ROIhandle, previousUData.texthandle, previousUData.mirrorTexthandle, previousUData.mirrorROIhandle]);
end

hold on;
h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
set(h,'ButtonDownFcn', 'FV_dragROI', 'Tag', 'FV_BGROI', 'Color','magenta');
hold off;
% i = length(findobj(h_findobj(gcf,'Tag','FV_ROE')));
x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
UserData.texthandle = text(x,y,'BG','HorizontalAlignment',...
    'Center','VerticalAlignment','Middle', 'Color','magenta','ButtonDownFcn', 'FV_dragROIText');
UserData.number = nan;
UserData.ROIType = 'FV_BGROI';
UserData.combinedROINumbers = [];
UserData.ROIhandle = h;
UserData.timeLastClick = clock;
% set(h,'UserData',UserData);
% set(UserData.texthandle,'UserData',UserData);

% below is to make ROI in both axes.
newObj = h_copyobj([UserData.ROIhandle, UserData.texthandle], handles.(otherAxes));
UserData.mirrorROIhandle = newObj(1);
UserData.mirrorTexthandle = newObj(2);

UserData2 = UserData;
UserData2.ROIhandle = newObj(1);
UserData2.texthandle = newObj(2);
UserData2.mirrorROIhandle = UserData.ROIhandle;
UserData2.mirrorTexthandle = UserData.texthandle;


set(UserData.ROIhandle,'UserData',UserData);
set(UserData.texthandle,'UserData',UserData);

set(UserData2.ROIhandle,'UserData',UserData2);
set(UserData2.texthandle,'UserData',UserData2);

FV_roiQuality(handles);
FV_setObjVisibility(handles);

