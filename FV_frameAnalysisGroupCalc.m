function FV_frameAnalysisGroupCalc(handles)

% global FV_img
[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

set(handles.frameAnalysisPauseGrpCalc,'Enable','on');

currentFilename = currentStruct.info.filename;
if isfield(currentStruct.state, 'frameAnalysisGrpCalcOpt')
    grpCalcOpt = currentStruct.state.frameAnalysisGrpCalcOpt.value;
else
    grpCalcOpt = 1;
end
zLim = currentStruct.display.settings.zLimit;

if ~isfield(currentStruct.activeGroup, 'groupFiles') || isempty(currentStruct.activeGroup.groupFiles)
    display('No active group. Abort!')
    return;
end

if ~ismember(lower(currentFilename),lower({currentStruct.activeGroup.groupFiles.name}'))
    disp('Current image does not belong to the active group!');
    return;
else
    %%%%%%%%%%% Get ROIs %%%%%%%%%%%%%%%%%%%%%%%%%%%
    ROIObj = findobj(handles.FLIMview,'Tag','FV_ROI');
    ROEObj = findobj(handles.FLIMview, 'tag', 'FV_ROE');
    bgROIObj = findobj(handles.FLIMview,'Tag','FV_BGROI');
    combinedROIObj = findobj(handles.FLIMview,'Tag','combinedFVROI');

    allObj = vertcat(ROIObj, ROEObj, bgROIObj, combinedROIObj);
    
    UData = get(allObj, 'UserData');
    if numel(allObj)>0
        if numel(allObj)>1
            UData = cell2mat(UData); %convert from cell to structure matrix
        end
    end
    
    
    %%%%%%%%%%%%% Calc one by one %%%%%%%%%%%%%%%%%%%%%%%%%%
    montage = h_montageSize(length(currentStruct.activeGroup.groupFiles));
    fig = figure('Name', currentStruct.activeGroup.groupName);

    for i = 1:length(currentStruct.activeGroup.groupFiles)
%         currentStruct.display.previousImg = currentStruct.display.intensityImg;
        relativePathFName = fullfile(currentStruct.activeGroup.groupPath, currentStruct.activeGroup.groupFiles(i).relativePath,...
            currentStruct.activeGroup.groupFiles(i).fname);
        if exist(relativePathFName, 'file') %preferentially using relative path filename, if not exist, try absolutely filename.
            filename = relativePathFName;
        elseif exist(currentStruct.activeGroup.groupFiles(i).name, 'file')
            filename = currentStruct.activeGroup.groupFiles(i).name;
        else
            display(['cannot find file: ', currentStruct.activeGroup.groupFiles(i).fname]);
            continue; % this means loop to next i.
        end
        
        [pname, fname, fExt] = fileparts(filename);
        analysisNum = currentStruct.state.analysisNum.value;
        analysisFilename = fullfile(pname,'Analysis',[fname,'_frameAnalysis_A', num2str(analysisNum), '.mat']);

        if ~(ismember(grpCalcOpt, [3, 5]) && exist(analysisFilename, 'file'))% 3 and 5 are un-analyzed only.
            FV_openFile(handles, filename);
            if ismember(grpCalcOpt, [4, 5, 8]) % keep z
                % additional: z are not recorded in state:
                set(handles.zLimStrLow, 'String', num2str(zLim(1)));
                set(handles.zLimStrHigh, 'String', num2str(zLim(2)));
                FV_settingQuality(handles);% this is needed to set sliders.
                FV_updateDispSettingVar(handles);
                FV_replot(handles, 'slow');%Note: put getCurrentImg into replot
            end
            
            if isfield(currentStruct.state, 'frameAnalysisAPosOpt') && currentStruct.state.frameAnalysisAPosOpt.value
                FV_autoPosition(handles);
                pause(3.5);% 5 seems a bit too slow, but 3 sometimes is not enough time.
            elseif ismember(grpCalcOpt, 6)%load ROI and recalc
                FV_loadAnalyzedROI(handles);
            elseif ismember(grpCalcOpt, [7, 8])%load spc_stackROI and recalc
                FV_loadSpc_stackROI(handles);
            end
            
            FV_executeFrameAnalysisCalc(handles);
            F = getframe(handles.intensityImgAxes);
            figure(fig);
            subplot(montage(1),montage(2),i)
            colormap(F.colormap);
            img = image(F.cdata);
            set(gca,'XTickLabel', '', 'YTickLabel', '', 'XTick',[],'YTick',[]);
            xlabel(currentStruct.activeGroup.groupFiles(i).fname);
        end
    end
end

FV_openFile(handles, currentFilename);
FV_loadFrameAnalysisROI(handles);% this also loads analyzed data to FV_img.(currentStructName).lastAnalysis.frameAnalysis.

set(handles.zLimStrLow, 'String', num2str(zLim(1)));%also set to original z values
set(handles.zLimStrHigh, 'String', num2str(zLim(2)));
FV_settingQuality(handles);% this is needed to set sliders.
%         FV_updateDispSettingVar(handles); % displaySettings is set within FV_settingQuality.
FV_replot(handles, 'slow');%Note: put getCurrentImg into replot

set(handles.frameAnalysisPauseGrpCalc,'Enable','off');



