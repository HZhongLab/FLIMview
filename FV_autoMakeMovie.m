function FV_autoMakeMovie(handles)

global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

if isfield(currentStruct.state, 'imageOpt')
    imageOpt = currentStruct.state.imageOpt.value;
else
    imageOpt = get(handles.imageOpt, 'value');
end

if imageOpt == 1
    imgAxesStr = 'intensityImgAxes';
else
    imgAxesStr = 'lifetimeImgAxes';
end

if isfield(currentStruct.state, 'movieContentOpt')
    movieContentOpt = currentStruct.state.movieContentOpt.value;
else
    movieContentOpt = get(handles.movieContentOpt, 'value');
end

if isfield(currentStruct.state, 'ROIOpt')
    ROIOpt = currentStruct.state.ROIOpt.value;
else
    ROIOpt = get(handles.ROIOpt, 'value');
end

if ROIOpt == 2 
    selectedROIObj = findobj(handles.FLIMview,'Tag','FV_ROI', 'Selected', 'on');
    if ~isempty(selectedROIObj)
        UserData = get(selectedROIObj,'UserData');
        currentSelectedROINumber = UserData.number; % save this so that one need to reselect it everytime.
    else
        currentSelectedROINumber = [];
    end
end


zLim = currentStruct.display.settings.zLimit;


switch movieContentOpt
    case {1, 2, 3, 4} % z stack views
        maxOpt = currentStruct.state.maxProjOpt.value;
        
        set(handles.maxProjOpt,'Value',0);
        FV_genericSettingCallback(handles.maxProjOpt, handles);
        
        switch movieContentOpt
            case 1
                ind = 1:diff(zLim)+1;
            case 2 % end to begin
                ind = diff(zLim)+1:-1:1;
            case 3 % begin to end to begin
                ind = [1:diff(zLim)+1, diff(zLim):-1:1];
            case 4 % end to begin to end
                ind = [diff(zLim)+1:-1:1, 2:diff(zLim)+1];
        end
        
        currentXLim = get(handles.(imgAxesStr), 'XLim');
        currentYLim = get(handles.(imgAxesStr), 'YLim');
        if ROIOpt == 2
            [xlim, ylim] = internal_getActiveROILimit(handles);
            currentXLim = get(handles.(imgAxesStr), 'XLim');
            currentYLim = get(handles.(imgAxesStr), 'YLim');
            set(handles.(imgAxesStr), 'XLim', xlim, 'YLim', ylim);
        end
        
        for i = 1:length(ind)
            set(handles.zLimStrLow,'String',num2str(zLim(1)+ind(i)-1));
            FV_settingQuality(handles); % this function includes update state and displaySetting variables and sets sliders.
            FV_replot(handles, 'slow');
            drawnow;
            mov(i) = getframe(handles.(imgAxesStr));
        end
        
        % work till here.
        set(handles.maxProjOpt,'Value',maxOpt);
        set(handles.zLimStrLow,'String',num2str(zLim(1)));
        set(handles.zLimStrHigh,'String',num2str(zLim(2)));
        FV_settingQuality(handles); % this function includes update state and displaySetting variables and sets sliders.    otherwise
        FV_replot(handles, 'slow');
        if ROIOpt == 2 % reset after ROI movie.
            set(handles.(imgAxesStr), 'XLim', currentXLim, 'YLim', currentYLim);
        end
    case {5, 6} % grp movie
        currentFilename = currentStruct.info.filename;
        [currentPName, currentFName] = h_analyzeFilename(currentFilename);% note: currentFName has extention.
%         zLim = currentStruct.display.settings.zLimit;
        
        if ~isfield(currentStruct.activeGroup, 'groupFiles') || isempty(currentStruct.activeGroup.groupFiles)
            display('No active group. Abort!')
            return;
        end
        
        if ~ismember(lower(currentFName),lower({currentStruct.activeGroup.groupFiles.fname}'))
            disp('Current image does not belong to the active group!');
            return;
        else            
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
                
                FV_openFile(handles, filename);
                if movieContentOpt==6
                    FV_loadAnalyzedROI(handles);
                end
                if ROIOpt == 2 % use selected ROI.
                    internal_selectrROI(handles, imgAxesStr, currentSelectedROINumber);
                    [xlim, ylim] = internal_getActiveROILimit(handles);
                    if ~isempty(xlim)
                        set(handles.(imgAxesStr), 'xlim', xlim, 'ylim', ylim);
                    end
                end
                mov(i) = getframe(handles.(imgAxesStr));
            end
            FV_openFile(handles, currentFilename)
        end
        
        FV_openFile(handles, currentFilename);
%         FV_loadAnalyzedROI(handles);% this also loads analyzed data to FV_img.(currentStructName).lastAnalysis.calcFVROI.
        
        set(handles.zLimStrLow, 'String', num2str(zLim(1)));%also set to original z values
        set(handles.zLimStrHigh, 'String', num2str(zLim(2)));
        FV_settingQuality(handles);% this is needed to set sliders.
        %         FV_updateDispSettingVar(handles); % displaySettings is set within FV_settingQuality.
        FV_replot(handles, 'slow');%Note: put getCurrentImg into replot
    otherwise

end

FV_img.(currentStructName).movie.mov = mov;



function [xlim, ylim] = internal_getActiveROILimit(handles)

selectedROIObj = findobj(handles.FLIMview,'Tag','FV_ROI', 'Selected', 'on');
% first find the image axes and get the image
% parentObj = get(selectedROIObj, 'parent');
% then get the image
if ~isempty(selectedROIObj)
    % now get the ROI info.
    UserData = get(selectedROIObj,'UserData');
    xlim = [min(UserData.roi.xi),max(UserData.roi.xi)];
    ylim = [min(UserData.roi.yi),max(UserData.roi.yi)];
else
    xlim = [];
    ylim = [];
end

function internal_selectrROI(handles, imgAxesStr, currentSelectedROINumber)

ROIObj = findobj(handles.FLIMview,'Tag','FV_ROI');
ROEObj = findobj(handles.FLIMview, 'Tag', 'FV_ROE');
bgROIObj = findobj(handles.FLIMview,'Tag','FV_BGROI');

combinedROIObj = findobj(handles.FLIMview,'Tag','combinedFVROI');

ROIObj2 = findobj(handles.(imgAxesStr),'Tag','FV_ROI');
% ROEObj2 = findobj(handles.(imgAxesStr), 'Tag', 'FV_ROE');
% bgROIObj2 = findobj(handles.(imgAxesStr),'Tag','FV_BGROI');

set(vertcat(ROIObj, ROEObj, bgROIObj, combinedROIObj), 'Selected','off', 'SelectionHighlight','off', 'linewidth',1);
% set(vertcat(ROIObj2, ROEObj2, bgROIObj2), 'Selected','off', 'SelectionHighlight','off', 'linewidth',1);

ROI_UData = get(ROIObj2, 'UserData');
if ~isempty(ROI_UData) % this can happen when there is no ROI.
    if iscell(ROI_UData) % ROI_UData is a cell if numel(ROIObj)>1
        ROI_UData = cell2mat(ROI_UData);
    end
    ROINumbers = [ROI_UData.number];
    I2 = (ROINumbers==currentSelectedROINumber);
    if ~isempty(I2)
        set(ROI_UData(I2).ROIhandle, 'Selected','on', 'SelectionHighlight','off', 'linewidth',3)
    end
end


% set(currentObj,'Selected','on','SelectionHighlight','off','linewidth',3);
