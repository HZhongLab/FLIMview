function FV_updateInfo(handles)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

currentFilename = get(handles.currentFileName,'String');
[pname, fname, fExt] = fileparts(currentFilename);

pos = get(handles.FLIMview, 'position');% for adjusting font size accordingly
defaultHeight = 550;
sizRatio = pos(4)/defaultHeight;


if isempty(strfind(lower(fname), 'currentfilename'))
    % this is to deal with before opending any real data file...
    % not all update should be included. e.g. group info does not require fname
    
    if isfield(handles, 'analyzedInfo') % not all info fields (those in the variable menu) are available.
        roiFilename = fullfile(pname,'Analysis',[fname,'_FVROI_A*.mat']);
        roiFiles = h_dir(roiFilename);
        if ~isempty(roiFiles)
            numStr = 'A';
            for i = 1:length(roiFiles)
                [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
                pos = strfind(roiFilesName,'_FVROI_A');
                num = roiFilesName(pos+8:end);%find out analysis number (string).
                numStr = [numStr, '#', num, ' '];
            end
            set(handles.analyzedInfo,'String',[numStr, 'analyzed!'],'ForegroundColor','red', 'FontSize',8*sizRatio);
            set(handles.loadAnalyzedROIData,'Enable','on');
        else
            set(handles.analyzedInfo,'String','Not-Analyzed','ForegroundColor','black','FontSize',8*sizRatio);
            set(handles.loadAnalyzedROIData,'Enable','off');
        end
    end
    

    % try
    if isfield(handles, 'spc_stackAnalyzedInfo')
        roiFilename = fullfile(pname,'Analysis',[fname,'_spcroi*.mat']);
        roiFiles = h_dir(roiFilename);
        if ~isempty(roiFiles)
            numStr = 'A';
            for i = 1:length(roiFiles)
                [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
                pos = strfind(roiFilesName,'_spcroi');
                num = roiFilesName(pos+7:end);%find out analysis number (string).
                if isempty(num)
                    num = '1';
                end
                numStr = [numStr, '#', num, ' '];
            end
            set(handles.spc_stackAnalyzedInfo,'String',['spc_stack: ', numStr, 'analyzed!'],...
                'ForegroundColor','red','FontSize',8*sizRatio);
            set(handles.loadAnalyzedSpc_stackData,'Enable','on');
        else
            set(handles.spc_stackAnalyzedInfo,'String','spc_stack: Not-Analyzed.',...
                'ForegroundColor','black','FontSize',8*sizRatio);
            set(handles.loadAnalyzedSpc_stackData,'Enable','off');
        end
    end
    % end
    
    if isfield(handles, 'frameAnalysisInfo') % not all info fields (those in the variable menu) are available.
        roiFilename = fullfile(pname,'Analysis',[fname,'_FVFrameAnalysis_A*.mat']);
        roiFiles = h_dir(roiFilename);
        if ~isempty(roiFiles)
            numStr = 'A';
            for i = 1:length(roiFiles)
                [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
                pos = strfind(roiFilesName,'_FVFrameAnalysis_A');
                num = roiFilesName(pos+18:end);%find out analysis number (string).
                numStr = [numStr, '#', num, ' '];
            end
            set(handles.frameAnalysisInfo,'String',[numStr, 'analyzed!'],'ForegroundColor','red', 'FontSize',8*sizRatio);
            set(handles.frameAnalysisLoad,'Enable','on');
        else
            set(handles.frameAnalysisInfo,'String','No frame analysis.','ForegroundColor','black','FontSize',8*sizRatio);
            set(handles.frameAnalysisLoad,'Enable','off');
        end
    end
    
    if isfield(handles, 'analysisNumToBeCopied') % if yes, there is also 'analysisNumToBeCopiedTo'
        analysisNumber = currentStruct.state.analysisNum.value;
        roiFilename = fullfile(pname,'Analysis',[fname,'_FVROI_A', num2str(analysisNumber), '.mat']);
        if exist(roiFilename, 'file')
            set(handles.analysisNumToBeCopied,'String',['A#', num2str(analysisNumber)],'ForegroundColor','red', 'FontSize',8*sizRatio);
        else
            set(handles.analysisNumToBeCopied,'String',['A#', num2str(analysisNumber)],'ForegroundColor','black', 'FontSize',8*sizRatio);
        end
        
        try
            analysisNumber = currentStruct.state.analysisNumToBeCopiedTo.value;
        catch
            analysisNumber = get(handles.analysisNumToBeCopiedTo, 'Value');
        end
        roiFilename = fullfile(pname,'Analysis',[fname,'_FVROI_A', num2str(analysisNumber), '.mat']);
        if exist(roiFilename, 'file')
            set(handles.analysisNumToBeCopiedTo,'ForegroundColor','red', 'FontSize',8*sizRatio);
        else
            set(handles.analysisNumToBeCopiedTo,'ForegroundColor','black', 'FontSize',8*sizRatio);
        end        
    end

end


try % note this is independent of whether a file is open so it is seperated from the test for currentFilename above
    if isfield(currentStruct.activeGroup,'groupName') && ~isempty(currentStruct.activeGroup.groupName)
        if ~isempty(currentStruct.activeGroup.groupFiles)
            groupFileNames = {currentStruct.activeGroup.groupFiles.fname};
            index = find(ismember(groupFileNames, [fname, fExt]));
        else
            index = [];
        end
        
        if isempty(index)
            imgStatusStr = 'n.i.';
        else
            imgStatusStr = num2str(index);
        end
        set(handles.currentGroupInfo,'String',['Group: ',currentStruct.activeGroup.groupName,...
            '  (',imgStatusStr,' out of ' num2str(length(currentStruct.activeGroup.groupFiles)),')'],...
            'FontSize',9*sizRatio);
        set(handles.openFirstInGroup,'Enable','on');
        set(handles.openPreviousInGroup,'Enable','on');
        set(handles.openNextInGroup,'Enable','on');
        set(handles.openLastInGroup,'Enable','on');
        set(handles.grpCalc,'Enable','on');
        %         set(handles.grpCalcOpt,'Enable','on'); % just leave it on.
        %         set(handles.pauseGrpCalc,'Enable','on');% this is set at FV_groupCalc.
        
        %         set(handles.openAllInGrp, 'Enable', 'on');
    else
        set(handles.currentGroupInfo,'String','Group: None','FontSize',9*sizRatio);
        set(handles.openFirstInGroup,'Enable','off');
        set(handles.openPreviousInGroup,'Enable','off');
        set(handles.openNextInGroup,'Enable','off');
        set(handles.openLastInGroup,'Enable','off');
        set(handles.grpCalc,'Enable','off');
        %         set(handles.grpCalcOpt,'Enable','off');
        %         set(handles.pauseGrpCalc,'Enable','off');%         set(handles.openAllInGrp, 'Enable', 'off');
    end
end


% 
% try
%     if isfield(handles, 'tracingDataInfo')
%         roiFilename = fullfile(pname,'Analysis',[fname,'_V3tracing_A*.mat']);
%         roiFiles = h_dir(roiFilename);
%         if ~isempty(roiFiles)
%             numStr = 'A';
%             for i = 1:length(roiFiles)
%                 [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
%                 pos = strfind(roiFilesName,'_V3tracing_A');
%                 num = roiFilesName(pos+12:end);%find out analysis number (string).
%                 numStr = [numStr, '#', num, ' '];
%             end
%             set(handles.tracingDataInfo,'String',[numStr, 'tracing data available!'],'ForegroundColor','red');
%             set(handles.loadTracingData,'Enable','on');
%         else
%             set(handles.tracingDataInfo,'String','No tracing data available.','ForegroundColor','black');
%             set(handles.loadTracingData,'Enable','off');
%         end
%     end
% end
% 
% try
%     if isfield(handles, 'v2TracingDataInfo')
%         roiFilename = fullfile(pname,'Analysis',[fname,'_tracing*.mat']);
%         roiFiles = h_dir(roiFilename);
%         if ~isempty(roiFiles)
%             numStr = 'A';
%             for i = 1:length(roiFiles)
%                 [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
%                 pos = strfind(roiFilesName,'_tracing');
%                 num = roiFilesName(pos+8:end);%find out analysis number (string).
%                 numStr = [numStr, '#', num, ' '];
%             end
%             set(handles.v2TracingDataInfo,'String',['v2: ', numStr, 'tracing data available!'],'ForegroundColor','red');
%             set(handles.loadV2TracingData,'Enable','on');
%         else
%             set(handles.v2TracingDataInfo,'String','v2: No tracing data available.','ForegroundColor','black');
%             set(handles.loadV2TracingData,'Enable','off');
%         end
%     end
% end
% 
% try
%     if isfield(handles, 'qCamDataInfo')
%         roiFilename = fullfile(pname,'Analysis',[fname,'_qCamROI3_A*.mat']);
%         roiFiles = h_dir(roiFilename);
%         if ~isempty(roiFiles)
%             numStr = 'A';
%             for i = 1:length(roiFiles)
%                 [roiFilesPath, roiFilesName] = fileparts(roiFiles(i).name);
%                 pos = strfind(roiFilesName,'_qCamROI3_A');
%                 num = roiFilesName(pos+11:end);%find out analysis number (string).
%                 numStr = [numStr, '#', num, ' '];
%             end
%             set(handles.qCamDataInfo,'String',[numStr, 'qCam data available!'],'ForegroundColor','red');
%             set(handles.loadQCamData,'Enable','on');
%         else
%             set(handles.qCamDataInfo,'String','No qCam data available.','ForegroundColor','black');
%             set(handles.loadQCamData,'Enable','off');
%         end
%     end
% end

% try
%     h_updateSpineAnalysisFileInfo3(handles);
% end