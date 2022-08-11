function err = FV_loadSettings(handles, flag)

global FV_img

% flag =    1 (default), 2 or 3

if ~exist('flag', 'var') || isempty(flag)
    flag = 1;
end

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

pname = h_findFilePath('FLIMview.m');
fileName = fullfile(pname, 'FV_settings.mat');

if exist(fileName, 'file')
%     load(fileName); %this should load a variable called "settings".
    temp = load(fileName); % old way of handling is no longer allowed in new MATLAB
    settings = temp.settings;
    err = 0;
else
    disp(['cannot find setting file: ', fileName]);
    err = 1;
    return
end

previousState = currentStruct.state;

if flag <= length(settings) && ~isempty(settings(flag).state) % in case setting has not been set before
    FV_img.(currentStructName).state = settings(flag).state;
    
    % exclusionList = getExclusionList; % when loading settings, there are certain variable should not be loaded.
    
    FV_setParaAccordingToState(handles);
    FV_updateDispSettingVar(handles);
    
    if ~isempty(fieldnames(previousState))% this can happen when FLIMview just start.
        if ~strcmp(settings(flag).state.t0Setting.string, previousState.t0Setting.string) ||...
                ~strcmp(settings(flag).state.spcRangeLow.string, previousState.spcRangeLow.string)  ||...
                ~strcmp(settings(flag).state.spcRangeHigh.string, previousState.spcRangeHigh.string)
            FV_calcMPETMap(handles); % recalc MPET map, but leave replot outside of loadsettings.
        end
    end
    
    FV_setupMenu(handles, 'upper');
    FV_setupMenu(handles, 'lower');
    
    % set check
    for i = 1:length(settings)
        if i==1
            handleName = 'loadDefault';
        else
            handleName = strcat('loadSettings',num2str(i));
        end
        if i==flag
            set(handles.(handleName), 'checked', 'on');
        else
            set(handles.(handleName), 'checked', 'off');
        end
    end
    
end

