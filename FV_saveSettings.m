function FV_saveSettings(handles, flag)

% flag =    1 (default), 2 or 3

if ~exist('flag', 'var') || isempty(flag)
    flag = 1;
end

exclusionList = getExclusionList; % there are certain state settings should not be saved. Such as filenames.
FV_saveSettingNotesGUI(handles, flag, exclusionList);

% [currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);
% 
% pname = h_findFilePath('FLIMview.m');
% fileName = fullfile(pname, 'FV_settings.mat');
% 
% if exist(fileName, 'file')
%     load(fileName); %this should load a variable called "settings".
% end
% 
% settings(flag).state = currentStruct.state;
% 
% exclusionList = getExclusionList; % there are certain state settings should not be saved. Such as filenames.
% 
% settings(flag).state = rmfield(settings(flag).state, exclusionList);

% save(fileName, 'settings');

function exclusionList = getExclusionList
exclusionList = {
    'AST_fileName' % this is set for info but really should not be in state settings, so exclude it.
    };
