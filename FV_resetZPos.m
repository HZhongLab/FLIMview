function FV_resetZPos(handles)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

zPos = get(handles.zPosSlider,'Value');
[xlim,ylim,zlim] = FV_getLimits(handles);
zSiz = zlim(2) - zlim(1) + 1;

zLow = currentStruct.display.settings.zLimit(1);
zHigh = currentStruct.display.settings.zLimit(2);

previousZPos = (zLow - 1)/(zSiz - (zHigh-zLow+1));

deltaZ = round((zPos - previousZPos)*(zSiz - (zHigh-zLow+1)));

set(handles.zLimStrLow, 'String', num2str(zLow+deltaZ));
set(handles.zLimStrHigh, 'String', num2str(zHigh+deltaZ));

FV_settingQuality(handles);
FV_replot(handles, 'slow');

