function FV_settingQuality(handles)
% this function checks z, intensity, spcRange, lifetime, lifetime lum.

% global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

%%% z
maxProj = get(handles.maxProjOpt,'Value');
[xlim,ylim,zlim] = FV_getLimits(handles);
siz = zlim(2) - zlim(1) + 1;
zLim(1) = str2double(get(handles.zLimStrLow,'String'));
zLim(2) = str2double(get(handles.zLimStrHigh,'String'));

if ~maxProj
    zLim(2) = zLim(1);
end

if zLim(1)<1
    zLim(1) = 1;
end

if zLim(2)<1
    zLim(2) = 1;
end

if zLim(1)>siz
    zLim(1) = siz;
end

if zLim(2)>siz
    zLim(2) = siz;
end

zLim = sort(zLim);
zLim = round(zLim);

set(handles.zLimStrLow,'String',num2str(zLim(1)));
set(handles.zLimStrHigh,'String',num2str(zLim(2)));
if siz > 1
    set(handles.zSliderLow,'SliderStep',[1/(siz-1),3/(siz-1)], 'Value',(zLim(1)-1)/(siz-1));
    set(handles.zSliderHigh,'SliderStep',[1/(siz-1),3/(siz-1)], 'Value',(zLim(2)-1)/(siz-1));
end

%%%% for the z position slider
if (siz - (diff(zLim)+1))==0
    zPos = 0.5;
    set(handles.zPosSlider, 'Value', zPos, 'Enable', 'off');
else
    zPos = (zLim(1) - 1)/(siz - (diff(zLim)+1));
    zPosSliderStep(1) = 1/(siz - (diff(zLim)+1));
    zPosSliderStep(2) = max([zPosSliderStep(1), 0.1]);
    set(handles.zPosSlider, 'SliderStep',zPosSliderStep, 'Value', zPos, 'Enable', 'on');
end

%%
%%%%%%% for Intensity Control %%%%%%%%%%%%%%%%%%%%
[maxIntensity, intensitySliderStep] = FV_getMaxIntensity(handles);

intLimit(1) = str2double(get(handles.intensityLimStrLow,'String'));
intLimit(2) = str2double(get(handles.intensityLimStrHigh,'String'));

if intLimit(1)<0
    intLimit(1) = 0;
end

if intLimit(2)<0
    intLimit(2) = 0;
end

if intLimit(1)>maxIntensity
    intLimit(1) = maxIntensity;
end

if intLimit(2)>maxIntensity
    intLimit(2) = maxIntensity;
end

intLimit = sort(intLimit);
intLimit = round(intLimit);

if intLimit(1) == intLimit(2);
    intLimit(2) = intLimit(1)+1;
end

set(handles.intensityLimStrLow,'String',num2str(intLimit(1)));
set(handles.intensityLimStrHigh,'String',num2str(intLimit(2)));
if maxIntensity > 1
    set(handles.intensitySliderLow,'Value',intLimit(1)/maxIntensity,'SliderStep', intensitySliderStep);
    set(handles.intensitySliderHigh,'Value',intLimit(2)/maxIntensity, 'SliderStep', intensitySliderStep);
end
%%
%%%%%%% for Lifetime Luminance Control %%%%%%%%%%%%%%%%%%%%
lifetimeLumLimit(1) = str2double(get(handles.lifetimeLumStrLow,'String'));
lifetimeLumLimit(2) = str2double(get(handles.lifetimeLumStrHigh,'String'));

if lifetimeLumLimit(1)<0
    lifetimeLumLimit(1) = 0;
end

if lifetimeLumLimit(2)<0
    lifetimeLumLimit(2) = 0;
end

if lifetimeLumLimit(1)>maxIntensity
    lifetimeLumLimit(1) = maxIntensity;
end

if lifetimeLumLimit(2)>maxIntensity
    lifetimeLumLimit(2) = maxIntensity;
end

lifetimeLumLimit = sort(lifetimeLumLimit);
lifetimeLumLimit = round(lifetimeLumLimit);

set(handles.lifetimeLumStrLow,'String',num2str(lifetimeLumLimit(1)));
set(handles.lifetimeLumStrHigh,'String',num2str(lifetimeLumLimit(2)));
if maxIntensity > 1
    set(handles.lifetimeLumSliderLow, 'Value', lifetimeLumLimit(1)/maxIntensity, 'SliderStep', intensitySliderStep);
    set(handles.lifetimeLumSliderHigh, 'Value', lifetimeLumLimit(2)/maxIntensity, 'SliderStep', intensitySliderStep);
end


%%%% lifetime

[minLifetime, maxLifetime] = FV_getLifetimeLimitBoundary(handles);


%%%%%%% for lifetime Control %%%%%%%%%%%%%%%%%%%%
lifetimeLimit(1) = str2double(get(handles.lifetimeLimitLow,'String'));
lifetimeLimit(2) = str2double(get(handles.lifetimeLimitHigh,'String'));

if lifetimeLimit(1)<minLifetime
    lifetimeLimit(1) = minLifetime;
end

if lifetimeLimit(2)<minLifetime
    lifetimeLimit(2) = minLifetime;
end

if lifetimeLimit(1)>maxLifetime
    lifetimeLimit(1) = maxLifetime;
end

if lifetimeLimit(2)>maxLifetime
    lifetimeLimit(2) = maxLifetime;
end

% if get(handles.activityMapOpt,'Value') == 2
%     lifetimeLimit = round(lifetimeLimit*100)/100;
%     set(handles.spc_lifetimeLimit1,'SliderStep',[0.01/(maxLifetime-minLifetime),0.1]);
%     set(handles.spc_lifetimeLimit2,'SliderStep',[0.01/(maxLifetime-minLifetime),0.1]);
%     currentStruct.info.switches.lifetime_limit = lifetimeLimit;
% else
% lifetimeLimit = sort(lifetimeLimit);
lifetimeLimit = round(lifetimeLimit*100)/100;
% currentStruct.info.switches.lifetime_limit = lifetimeLimit;

% if (maxLifetime-minLifetime) > 1
    set(handles.lifetimeSliderLow,'SliderStep',[0.01,0.05]/(maxLifetime-minLifetime),'Value',(lifetimeLimit(1)-minLifetime)/(maxLifetime-minLifetime));
    set(handles.lifetimeSliderHigh,'SliderStep',[0.01,0.05]/(maxLifetime-minLifetime),'Value',(lifetimeLimit(2)-minLifetime)/(maxLifetime-minLifetime));
% end
set(handles.lifetimeLimitLow,'String',num2str(lifetimeLimit(1)));
set(handles.lifetimeLimitHigh,'String',num2str(lifetimeLimit(2)));

% for the lifetime fixed range slider
lifetimeRange = maxLifetime - minLifetime - abs(diff(lifetimeLimit));
if lifetimeRange>0
    lifetimeRangeSliderPos = round((min(lifetimeLimit) - minLifetime)/lifetimeRange*10000)/10000; %otherwise inprecision can make the value larger than 1...
    sliderStep(1) = min([0.01/lifetimeRange, 0.99]);
    sliderStep(2) = min([0.05/lifetimeRange, 0.99]);
    set(handles.lifetimeFixedRangeSlider, 'SliderStep',sliderStep, 'Value', lifetimeRangeSliderPos, 'Enable', 'on');
else
    lifetimeRangeSliderPos = 0.5;
    set(handles.lifetimeFixedRangeSlider, 'Value', lifetimeRangeSliderPos, 'Enable', 'off');
end


%% %%%% SPC range?

spcStartInd = round(str2double(get(handles.spcRangeLow, 'String'))*1000/currentStruct.info.datainfo.psPerUnit);
if spcStartInd < 1
    spcStartInd = 1;
end
spcStart = round(spcStartInd*currentStruct.info.datainfo.psPerUnit/100)/10;
set(handles.spcRangeLow,'String',num2str(spcStart));

spcEndInd = round(str2double(get(handles.spcRangeHigh, 'String'))*1000/currentStruct.info.datainfo.psPerUnit);
if spcEndInd>currentStruct.info.size(1)
    spcEndInd = currentStruct.info.size(1);
end
spcEnd = round(spcEndInd*currentStruct.info.datainfo.psPerUnit/100)/10;
set(handles.spcRangeHigh,'String',num2str(spcEnd));

%%%% update potentially altered state variables.

% maybe should do this way. It should be resource wasteful but computer
% should be fast enough and it make the code clean.
FV_updateStateVar(handles); % note: this function will change the global variable  so currentStruct is obselete

% currentStruct.state.lifetimeLumStrLow.string = num2str(lifetimeLumLimit(1));
% currentStruct.state.lifetimeLumStrHigh.string = num2str(lifetimeLumLimit(2));
% currentStruct.state.lifetimeLimitLow.string = num2str(lifetimeLimit(1));
% currentStruct.state.lifetimeLimitHigh.string = num2str(lifetimeLimit(2));
% currentStruct.state.intensityLimStrLow.string = num2str(intLimit(1));
% currentStruct.state.intensityLimStrHigh.string = num2str(intLimit(2));

%%%% update display.settings % not sure how useful this is (vs getting directly from state). Wait and see.
% currentStruct.display.settings.intensityLimit = intLimit;
% currentStruct.display.settings.lifetimeLumLimit = lifetimeLumLimit; %note this is more than display setting as all calculation is based on lifetimeLumLimit(1).
% currentStruct.display.settings.lifetimeLimit = lifetimeLimit;
% currentStruct.display.settings.zLimit = zLim;
% currentStruct.display.settings.spcRange = [spcStart, spcEnd]; %note this is more than display setting as all calculation is based on it.
% currentStruct.display.settings.spcRangeInd = [spcStartInd, spcEndInd]; 

FV_updateDispSettingVar(handles); % note: this function will change the global variable so currentStruct is obselete


