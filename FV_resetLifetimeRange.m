function FV_resetLifetimeRange(handles)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

lifetimeRangePos = get(handles.lifetimeFixedRangeSlider,'Value');

[minLifetime, maxLifetime] = FV_getLifetimeLimitBoundary(handles);

previousLifetimeLimit = currentStruct.display.settings.lifetimeLimit;
lifetimeRange = maxLifetime - minLifetime - abs(diff(previousLifetimeLimit));

previousPos = (min(previousLifetimeLimit) - minLifetime)/lifetimeRange;

deltaLifetime = (lifetimeRangePos - previousPos)*lifetimeRange;

set(handles.lifetimeLimitLow, 'String', num2str(previousLifetimeLimit(1)+deltaLifetime));
set(handles.lifetimeLimitHigh, 'String', num2str(previousLifetimeLimit(2)+deltaLifetime));

FV_settingQuality(handles);
FV_replot(handles, 'fast');

