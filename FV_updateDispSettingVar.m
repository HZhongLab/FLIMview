function FV_updateDispSettingVar(handles)

global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

% set(handles.intensityLimStrLow,'String',num2str(intLimit(1)));
% set(handles.intensityLimStrHigh,'String',num2str(intLimit(2)));

settings = currentStruct.display.settings;

settings.intensityLimit =...
    [str2double(get(handles.intensityLimStrLow, 'String')), str2double(get(handles.intensityLimStrHigh, 'String'))];

settings.lifetimeLumLimit =...
    [str2double(get(handles.lifetimeLumStrLow, 'String')), str2double(get(handles.lifetimeLumStrHigh, 'String'))]; %note this is more than display setting as all calculation is based on lifetimeLumLimit(1).

settings.lifetimeLimit =...
    [str2double(get(handles.lifetimeLimitLow, 'String')), str2double(get(handles.lifetimeLimitHigh, 'String'))];

settings.zLimit =...
    [str2double(get(handles.zLimStrLow, 'String')), str2double(get(handles.zLimStrHigh, 'String'))];

settings.spcRange =...
    [str2double(get(handles.spcRangeLow, 'String')), str2double(get(handles.spcRangeHigh, 'String'))]; %note this is more than display setting as all calculation is based on it.

if isfield(currentStruct.info, 'datainfo') && isfield(currentStruct.info.datainfo, 'psPerUnit')
    settings.spcRangeInd =...
        round(settings.spcRange*1000/currentStruct.info.datainfo.psPerUnit);
else % this would happen before loading the first image. use a default value
    nsPerUnit = 12.5/64; %12.5 ns divided into 64 bins.
    settings.spcRangeInd = round(settings.spcRange / nsPerUnit);
end

settings.t0 = str2double(get(handles.t0Setting, 'String'));
% t0Setting = t0Strings{currentStruct.state.t0Setting.value};
% try
%     eval(t0Setting)
%     settings.t0 = t0;
%     settings.PRFsigma = PRFsigma;
% catch
%     warning('t0 setting error! Default t0 = 2.33, PRFsigma = 0.148. %Slice_960 nm 2017-07')
%     settings.t0 = 2.33;
%     settings.PRFsigma = 0.148;
% end

settings.LT0 = str2double(get(handles.LT0Input, 'String'));

switch (get(handles.viewingAxis, 'Value'))
    case {1, 4, 7, 10}
        settings.viewingAxis = 'X-Y';
    case {2, 5, 8, 11}
        settings.viewingAxis = 'X-Z';
    case {3, 6, 9, 12}
        settings.viewingAxis = 'Y-Z';
    otherwise
        settings.viewingAxis = 'X-Y';
end

settings.XYRatio = eval(get(handles.XYRatio, 'String'));

FV_img.(currentStructName).display.settings = settings;
