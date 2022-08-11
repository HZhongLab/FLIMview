function FV_loadFrameAnalysisROI(handles)

global FV_img;

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);
% [xlim,ylim,zlim] = FV_getLimits(handles); % need limits to put text at the same location for combinedROIs...

currentFilename = get(handles.currentFileName,'String');
[pname, fname] = fileparts(currentFilename);
analysisNumber = currentStruct.state.analysisNum.value;

roiFilename = fullfile(pname,'Analysis',[fname,'_FVFrameAnalysis_A',num2str(analysisNumber),'.mat']);
load(roiFilename);

FV_img.(currentStructName).lastAnalysis.frameAnalysis = Aout;

% delete previous ROIs.
ROIObj = findobj(handles.FLIMview,'Tag','FV_ROI');
ROEObj = findobj(handles.FLIMview, 'Tag', 'FV_ROE');
bgROIObj = findobj(handles.FLIMview,'Tag','FV_BGROI');
combinedROIObj = findobj(handles.FLIMview,'Tag','combinedFVROI');

allObj = vertcat(ROIObj, ROEObj, bgROIObj, combinedROIObj);
UData = get(allObj, 'UserData');
if numel(allObj)>0
    if numel(allObj)>1
        UData = cell2mat(UData); %convert from cell to structure matrix
    end
    delete(vertcat(ROIObj, ROEObj, bgROIObj));
    delete(vertcat(UData.texthandle)); %there is only text for combinedFVROI so only delete once.
end

% this is trying to recycle codes already made.
currentAxes = 'intensityImgAxes';
otherAxes = 'lifetimeImgAxes';

axes(handles.(currentAxes)); %axes is a very slow command so try to do only once for each axes.
j = 1; % use this to track all ROIs and later copy them all together.
if ~isempty(Aout.allROIInfo.ROI)
    UserData = Aout.allROIInfo.ROI;
    for i = 1:length(UserData)
            hold on;
            h = plot(UserData(j).roi.xi,UserData(j).roi.yi,'m-');
            set(h,'ButtonDownFcn', 'FV_dragROI', 'Tag', 'FV_ROI', 'Color','red', 'EraseMode','xor');
            hold off;
            x = (min(UserData(j).roi.xi) + max(UserData(j).roi.xi))/2;
            y = (min(UserData(j).roi.yi) + max(UserData(j).roi.yi))/2;
            UserData(j).texthandle = text(x,y,num2str(UserData(j).number),'HorizontalAlignment',...
                'Center','VerticalAlignment','Middle', 'Color','red', 'EraseMode','xor','ButtonDownFcn', 'FV_dragROIText');
            UserData(j).ROIhandle = h;
            UserData(j).timeLastClick = clock;
            j = j+1;
    end
end

if isfield(Aout.allROIInfo, 'combinedROI') && ~isempty(Aout.allROIInfo.combinedROI)
    combinedROI_UData = Aout.allROIInfo.combinedROI;
    for i = 1:length(combinedROI_UData)
            % we will not copy these ROI to the other axes so use a
            % different UData variable. therefore, it uses i not j as index
            combinedROI_UData(i).texthandle = text(combinedROI_UData(i).roi.xi,combinedROI_UData(i).roi.yi,num2str(combinedROI_UData(i).number),...
                'HorizontalAlignment', 'Center','VerticalAlignment','Middle', 'Color','Magenta', ...
                'ButtonDownFcn', 'FV_dragCombinedFVROIText', 'Tag', 'combinedFVROI');
            combinedROI_UData(i).ROIhandle = combinedROI_UData(i).texthandle;
            combinedROI_UData(i).timeLastClick = clock;
            set(combinedROI_UData(i).texthandle,'UserData',combinedROI_UData); % set UserData here as combinedROIs are only in intensityImgAxes
    end
end


if ~isempty(Aout.allROIInfo.bgROI)
    UserData(j) = Aout.allROIInfo.bgROI;
    hold on;
    h = plot(UserData(j).roi.xi,UserData(j).roi.yi,'m-');
    set(h,'ButtonDownFcn', 'FV_dragROI', 'Tag', 'FV_BGROI', 'Color','magenta');
    hold off;
    x = (min(UserData(j).roi.xi) + max(UserData(j).roi.xi))/2;
    y = (min(UserData(j).roi.yi) + max(UserData(j).roi.yi))/2;
    UserData(j).texthandle = text(x,y,'BG','HorizontalAlignment',...
    'Center','VerticalAlignment','Middle', 'Color','magenta','ButtonDownFcn', 'FV_dragROIText');
    UserData(j).ROIhandle = h;
    UserData(j).timeLastClick = clock;
    j = j+1;
end

if ~isempty(Aout.allROIInfo.ROE)
    UserData(j:(j+length(Aout.allROIInfo.ROE)-1)) = Aout.allROIInfo.ROE;
    for i = 1:length(Aout.allROIInfo.ROE)
        hold on;
        h = plot(UserData(j).roi.xi,UserData(j).roi.yi,'m-');
        set(h,'ButtonDownFcn', 'FV_dragROI', 'Tag', 'FV_ROE', 'Color','magenta');
        hold off;
        x = (min(UserData(j).roi.xi) + max(UserData(j).roi.xi))/2;
        y = (min(UserData(j).roi.yi) + max(UserData(j).roi.yi))/2;
        UserData(j).texthandle = text(x,y,'EX','HorizontalAlignment',...
            'Center','VerticalAlignment','Middle', 'Color','magenta','ButtonDownFcn', 'FV_dragROIText');
        UserData(j).ROIhandle = h;
        UserData(j).timeLastClick = clock;
        j = j+1;
    end
end

for i = 1:j-1
    newObj = h_copyobj([UserData(i).ROIhandle, UserData(i).texthandle], handles.(otherAxes));
    UserData(i).mirrorROIhandle = newObj(1);
    UserData(i).mirrorTexthandle = newObj(2);
    
    UserData2 = UserData(i);
    UserData2.ROIhandle = newObj(1);
    UserData2.texthandle = newObj(2);
    UserData2.mirrorROIhandle = UserData(i).ROIhandle;
    UserData2.mirrorTexthandle = UserData(i).texthandle;
    
    
    set(UserData(i).ROIhandle,'UserData',UserData(i));
    set(UserData(i).texthandle,'UserData',UserData(i));
    
    set(UserData2.ROIhandle,'UserData',UserData2);
    set(UserData2.texthandle,'UserData',UserData2);
end


FV_setObjVisibility(handles);

if currentStruct.state.frameAnalysisLoadSettingOpt.value % if also loading settings. This is like loading default but only for selected fields.
%     exclusionList = getExclusionList;
    inclusionList = getInclusionList; %better this way as teh there may be more and more fields for state in the future.
    state = currentStruct.state;
    previousState = state;
    fieldNames = fieldnames(Aout.currentSettings.state);
%     fieldNames = fieldNames(~ismember(fieldNames, exclusionList));
    fieldNames = fieldNames(ismember(fieldNames, inclusionList));
    for i = 1:length(fieldNames)
        state.(fieldNames{i}) = Aout.currentSettings.state.(fieldNames{i});
    end
    FV_img.(currentStructName).state = state;
    

    
%     if state ~= previousState % struct cannot be compare this way... just bypass for now.
        FV_setParaAccordingToState(handles);
        
        % additional: z are not recorded in state:
        set(handles.zLimStrLow, 'String', num2str(Aout.currentSettings.display.zLimit(1)));
        set(handles.zLimStrHigh, 'String', num2str(Aout.currentSettings.display.zLimit(2)));
        
        FV_settingQuality(handles);% this is needed to set sliders.
%         FV_updateDispSettingVar(handles); % displaySettings is set within FV_settingQuality.
        
        % check, and only regenerate MPET data if necessary to save computation effort
        if ~strcmp(state.t0Setting.string, previousState.t0Setting.string) ||...
                ~strcmp(state.spcRangeLow.string, previousState.spcRangeLow.string)  ||...
                ~strcmp(state.spcRangeHigh.string, previousState.spcRangeHigh.string) 
            FV_calcMPETMap(handles); % recalc MPET map, but leave replot outside of loadsettings.
        end
        FV_replot(handles, 'slow');%Note:  getCurrentImg is in replot
%     end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function exclusionList = getExclusionList
exclusionList = {
%     'lifetimeLumStrLow'
%     'lifetimeLumStrHigh'
%     'lifetimeLimitLow'
%     'lifetimeLimitHigh'
%     'intensityLimStrLow'
%     'intensityLimStrHigh'
%     'spcRangeLow'
%     'spcRangeHigh'
%     'LT0Input'
    'jumpStep'
%     'viewingAxis'
%     'maxProjOpt'
%     'filterOpt'
%     'intensityCMapOpt'
%     'lifetimeImgDisplayOpt'
%     't0Setting'
    'analysisNum'
    'hideROIOpt'
    'higherMenuOpt'
    'lowerMenuOpt'
    'intensityImgOpt'
    'ROIShapeOpt'
    'ROISizeOpt'
    'loadSettingOpt'
    };

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function list = getInclusionList
list = {
    'lifetimeLumStrLow'
    'lifetimeLumStrHigh'
    'lifetimeLimitLow'
    'lifetimeLimitHigh'
    'intensityLimStrLow'
    'intensityLimStrHigh'
    'spcRangeLow'
    'spcRangeHigh'
    'LT0Input'
%     'jumpStep'
    'viewingAxis'
    'maxProjOpt'
    'filterOpt'
    'intensityCMapOpt'
    'lifetimeImgDisplayOpt'
    't0Setting'
%     'analysisNum'
%     'hideROIOpt'
%     'higherMenuOpt'
%     'lowerMenuOpt'
%     'intensityImgOpt'
%     'ROIShapeOpt'
%     'ROISizeOpt'
%     'loadSettingOpt'
    };
    