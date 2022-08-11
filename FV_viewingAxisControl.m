function FV_viewingAxisControl(handles)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

previousViewingAxis = currentStruct.display.settings.viewingAxis;

currentViewingAxisOpt = get(handles.viewingAxis, 'Value');
switch currentViewingAxisOpt
    case {1, 4, 7, 10}
        currentViewingAxis = 'X-Y';
    case {2, 5, 8, 11}
        currentViewingAxis = 'X-Z';
    case {3, 6, 9, 12}
        currentViewingAxis = 'Y-Z';
    otherwise
        currentViewingAxis = 'X-Y';
end

% if it is the same viewingAxis, don't do anything.
if strcmpi(previousViewingAxis, currentViewingAxis)
    FV_genericSettingCallback(handles.viewingAxis, handles); %still update the state variable to make it sync.
    return;
end

% first get all the parameters.
[xlim,ylim,zlim] = FV_getLimits(handles); % this is mainly for the zlim.

switch currentViewingAxisOpt
    case {4, 5, 6}
        deltaDepth = 0;
    case 7
        deltaDepth = 1;
    case {8, 9}
        deltaDepth = 5;
    case 10
        deltaDepth = 3;
    case {11, 12}
        deltaDepth = 15;
    otherwise
        deltaDepth = 0;
end
        

switch currentViewingAxisOpt
    case {1, 2, 3}
        set(handles.zLimStrLow,'String', num2str(zlim(1)));
        set(handles.zLimStrHigh,'String', num2str(zlim(2)));
        
    case {4, 7, 10} %'X-Y'
        [x, y] = ginput(1);
        currentAxesTag = get(gca, 'Tag');
        if ~ismember(currentAxesTag, {'intensityImgAxes', 'lifetimeImgAxes'})
            % if not valid input, set it back to the previous value, and leave.
            FV_setParaAccordingToState(handles, 'viewingAxis');
            return;
        end
        depth = y; % if it is changed to "X-Y", then the current y is future depth.
        set(handles.zLimStrLow,'String', num2str(depth - deltaDepth)); % it can be off bound but will get fixed in FV_settingQuality
        set(handles.zLimStrHigh,'String', num2str(depth + deltaDepth)); % it can be off bound but will get fixed in FV_settingQuality
        
    case {5, 8, 11} %'X-Z'
        [x, y] = ginput(1);
        currentAxesTag = get(gca, 'Tag');
        if ~ismember(currentAxesTag, {'intensityImgAxes', 'lifetimeImgAxes'})
            % if not valid input, set it back to the previous value, and leave.
            FV_setParaAccordingToState(handles, 'viewingAxis');
            return;
        end
        if strcmpi(previousViewingAxis, 'X-Y')
            depth = y; % if it was "X-Y", then the current y is future depth.
        else
            depth = x; % if it was "Y-Z", then the current x is future depth.
        end
        set(handles.zLimStrLow,'String', num2str(depth - deltaDepth)); % it can be off bound but will get fixed in FV_settingQuality
        set(handles.zLimStrHigh,'String', num2str(depth + deltaDepth)); % it can be off bound but will get fixed in FV_settingQuality        

    case {6, 9, 12} %'Y-Z'
        [x, y] = ginput(1);
        currentAxesTag = get(gca, 'Tag');
        if ~ismember(currentAxesTag, {'intensityImgAxes', 'lifetimeImgAxes'})
            % if not valid input, set it back to the previous value, and leave.
            FV_setParaAccordingToState(handles, 'viewingAxis');
            return;
        end
        depth = x; % whether it was "X-Y" or "X-Z", the current x is future depth.
        set(handles.zLimStrLow,'String', num2str(depth - deltaDepth)); % it can be off bound but will get fixed in FV_settingQuality
        set(handles.zLimStrHigh,'String', num2str(depth + deltaDepth)); % it can be off bound but will get fixed in FV_settingQuality        
    otherwise
end

FV_autoSetAxesRatio(handles); % don't set AxesRatio earlier because may opt to do nothing.
[xlim,ylim,zlim] = FV_getLimits(handles); %xlim and ylim depends on Axes Ratio. so get limit again after setting ratio.

set(handles.intensityImgAxes,'XLim',xlim,'YLim',ylim); %always reset to full size - for now. may change in the future.
set(handles.lifetimeImgAxes,'XLim',xlim,'YLim',ylim);

FV_settingQuality(handles); % this updates display as well as state.
FV_replot(handles);
