function FV_updateStateVar(handles)

% note: FV_settingQuality should not be called within this function as
% FV_settingQuality calls FV_updateStateVar.

global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

state = currentStruct.state;

state.lifetimeLumStrLow.string = get(handles.lifetimeLumStrLow, 'String');
state.lifetimeLumStrHigh.string = get(handles.lifetimeLumStrHigh, 'String');
state.lifetimeLimitLow.string = get(handles.lifetimeLimitLow, 'String');
state.lifetimeLimitHigh.string = get(handles.lifetimeLimitHigh, 'String');
state.intensityLimStrLow.string = get(handles.intensityLimStrLow, 'String');
state.intensityLimStrHigh.string = get(handles.intensityLimStrHigh, 'String');
state.spcRangeLow.string = get(handles.spcRangeLow, 'String');
state.spcRangeHigh.string = get(handles.spcRangeHigh, 'String');
state.LT0Input.string = get(handles.LT0Input, 'String');
state.t0Setting.string = get(handles.t0Setting, 'String');

state.jumpStep.string = get(handles.jumpStep, 'String');

state.viewingAxis.value = get(handles.viewingAxis, 'Value');
state.maxProjOpt.value = get(handles.maxProjOpt, 'Value');
state.filterOpt.value = get(handles.filterOpt, 'Value');
state.intensityCMapOpt.value = get(handles.intensityCMapOpt, 'Value');
state.lifetimeImgDisplayOpt.value = get(handles.lifetimeImgDisplayOpt, 'Value');
state.analysisNum.value = get(handles.analysisNum(1), 'Value');% there can be two. one in variable menu...
state.hideROIOpt.value = get(handles.hideROIOpt(1), 'Value');% there can be two. one in variable menu...
state.higherMenuOpt.value = get(handles.higherMenuOpt, 'Value');
state.lowerMenuOpt.value = get(handles.lowerMenuOpt, 'Value');
state.intensityImgOpt.value = get(handles.intensityImgOpt, 'Value');

FV_img.(currentStructName).state = state;
