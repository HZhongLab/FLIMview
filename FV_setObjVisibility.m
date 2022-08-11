function FV_setObjVisibility(handles)

% this function handles all visibility settings.

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

state = currentStruct.state;


ROIObj = findobj(handles.FLIMview,'Tag','FV_ROI');
ROEObj = findobj(handles.FLIMview, 'Tag', 'FV_ROE');
bgROIObj = findobj(handles.FLIMview,'Tag','FV_BGROI');
combinedROIObj = findobj(handles.FLIMview,'Tag','combinedFVROI');

allROIObj = vertcat(ROIObj, ROEObj, bgROIObj, combinedROIObj);

% try
    if ~state.hideROIOpt.value %if not hiding ROI, i.e. showing ROI
        set(allROIObj, 'visible', 'on');
        UData = get(allROIObj,'UserData');
        if ~isempty(UData)
            if iscell(UData)
                UData = cell2mat(UData);
            end
            textHandles = [UData.texthandle];
            set(textHandles, 'visible', 'on');
        end
    else
        set(allROIObj, 'visible', 'off');
        UData = get(allROIObj,'UserData');
        if ~isempty(UData)
            if iscell(UData)
                UData = cell2mat(UData);
            end
            textHandles = [UData.texthandle];
            set(textHandles, 'visible', 'off');
        end     
    end
% catch
% end

% try
%     if state.hideScoringDataset.value
%         set(scoringROIObj, 'visible', 'off');
%         set(scoringROITextObj, 'visible', 'off');
%     else
%         set(scoringROIObj, 'visible', 'on');
%         set(scoringROITextObj, 'visible', 'on');
%     end
% catch
% end
% 
% try
%     if state.hideRefDataset.value
%         set(refROIObj, 'visible', 'off');
%         set(refROITextObj, 'visible', 'off');
%     else
%         set(refROIObj, 'visible', 'on');
%         set(refROITextObj, 'visible', 'on');
%     end
% catch
% end
% 
