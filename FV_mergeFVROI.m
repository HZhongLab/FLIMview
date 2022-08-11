function FV_mergeFVROI(handles)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

toBeMergedROINumStr = get(handles.toBeMergedROINumStr, 'String');

% to identify the handles of the ROIs to be merged
toBeMergedROINumbers = unique(eval(['[',toBeMergedROINumStr,']']));
% unique() prevents from entering the same ROI multiple times. numbers are also sorted. 

ROIObj = findobj(handles.FLIMview,'Tag','FV_ROI');
n_roi = length(ROIObj);

if isnumeric(toBeMergedROINumbers) && max(toBeMergedROINumbers) <= n_roi && min(toBeMergedROINumbers) > 0 % simple test to avoid errors
    i = length(findobj(handles.FLIMview,'Tag','combinedFVROI'));
    [xlim,ylim,zlim] = FV_getLimits(handles); % need limits to put text at the same location...
    x_pos = (diff(xlim)+1) / 128 * 15; % original test with 128X128 image.
    y_pos = (diff(ylim)+1) / 128 * 5;
    x = (i+1 - 0.5) * x_pos;
    y = y_pos;
    UserData.roi.xi = x;
    UserData.roi.yi = y;
    axes(handles.intensityImgAxes);
    UserData.texthandle = text(x,y,num2str(i+1001),'HorizontalAlignment',...
        'Center','VerticalAlignment','Middle', 'Color','Magenta', ...
        'ButtonDownFcn', 'FV_dragCombinedFVROIText', 'Tag', 'combinedFVROI');
    UserData.number = i+1001;
    UserData.ROIType = 'combinedFVROI';
    UserData.combinedROINumbers = toBeMergedROINumbers;
    UserData.ROIhandle = UserData.texthandle;
    UserData.timeLastClick = clock;
    UserData.mirrorROIhandle = []; % merge ROI is in intensity axes only.
    UserData.mirrorTexthandle = [];
    set(UserData.texthandle,'UserData',UserData);
else
    warning(['ROI number error or out of range: [',toBeMergedROINumStr,'].']);
end
