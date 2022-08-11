function FV_loadSpc_stackROI(handles)

global FV_img;

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);
[xlim,ylim,zlim] = FV_getLimits(handles); % need limits to put text at the same location for combinedROIs...
x_spacing = (diff(xlim)+1) / 128 * 15; % original test with 128X128 image.
y_spacing = (diff(ylim)+1) / 128 * 5;

currentFilename = get(handles.currentFileName,'String');
[pname, fname] = fileparts(currentFilename);
analysisNumber = currentStruct.state.analysisNum.value;
if analysisNumber == 1
    analysisNumber = [];
end

roiFilename = fullfile(pname,'Analysis',[fname,'_spcroi',num2str(analysisNumber),'.mat']);

if exist(roiFilename, 'file')
    load(roiFilename);
    
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
    if isfield(Aout,'roi')
        for i = 1:length(Aout.roi)
            if Aout.roiNumber(i) ~= 0 && Aout.roiNumber(i) <= 1000
                UserData(j).roi.xi = Aout.roi(i).xi;
                UserData(j).roi.yi = Aout.roi(i).yi;
                hold on;
                h = plot(UserData(j).roi.xi,UserData(j).roi.yi,'m-');
                set(h,'ButtonDownFcn', 'FV_dragROI', 'Tag', 'FV_ROI', 'Color','red', 'EraseMode','xor');
                hold off;
                ROINumber = Aout.roiNumber(i);
                x = (min(UserData(j).roi.xi) + max(UserData(j).roi.xi))/2;
                y = (min(UserData(j).roi.yi) + max(UserData(j).roi.yi))/2;
                UserData(j).texthandle = text(x,y,num2str(ROINumber),'HorizontalAlignment',...
                    'Center','VerticalAlignment','Middle', 'Color','red', 'EraseMode','xor','ButtonDownFcn', 'FV_dragROIText');
                UserData(j).number = ROINumber;
                UserData(j).ROIType = 'FV_ROI';
                UserData(j).combinedROINumbers = [];
                UserData(j).ROIhandle = h;
                UserData(j).timeLastClick = clock;
                j = j+1;
            elseif Aout.roiNumber(i) > 1000 % will handle combined ROI later. Will only show in intensity image.
                % we will not copy these ROI to the other axes so use a
                % different UData variable.
                combinedROI_UData.roi.xi = (Aout.roiNumber(i) - 1000 - 0.5) * x_spacing; % x-y position for combined ROIs are not recorded in spc_stack so re-create
                combinedROI_UData.roi.yi = y_spacing;
                combinedROI_UData.texthandle = text(combinedROI_UData.roi.xi,combinedROI_UData.roi.yi,num2str(Aout.roiNumber(i)),...
                    'HorizontalAlignment', 'Center','VerticalAlignment','Middle', 'Color','Magenta', ...
                    'ButtonDownFcn', 'FV_dragCombinedFVROIText', 'Tag', 'combinedFVROI');
                combinedROI_UData.number = Aout.roiNumber(i);
                combinedROI_UData.ROIType = 'combinedFVROI';
                combinedROI_UData.combinedROINumbers = Aout.roi(i).combinedROINumbers;
                combinedROI_UData.ROIhandle = combinedROI_UData.texthandle;
                combinedROI_UData.timeLastClick = clock;
                combinedROI_UData.mirrorROIhandle = []; % merge ROI is in intensity axes only.
                combinedROI_UData.mirrorTexthandle = [];
                set(combinedROI_UData.texthandle,'UserData',combinedROI_UData);
            end
        end
    end
    
    
    if isfield(Aout,'bgroi') && ~isempty(Aout.bgroi)
        UserData(j).roi.xi = Aout.bgroi.xi;
        UserData(j).roi.yi = Aout.bgroi.yi;
        hold on;
        h = plot(UserData(j).roi.xi,UserData(j).roi.yi,'m-');
        set(h,'ButtonDownFcn', 'FV_dragROI', 'Tag', 'FV_BGROI', 'Color','magenta');
        hold off;
        ROINumber = nan;
        x = (min(UserData(j).roi.xi) + max(UserData(j).roi.xi))/2;
        y = (min(UserData(j).roi.yi) + max(UserData(j).roi.yi))/2;
        UserData(j).texthandle = text(x,y,'BG','HorizontalAlignment',...
            'Center','VerticalAlignment','Middle', 'Color','magenta','ButtonDownFcn', 'FV_dragROIText');
        UserData(j).number = ROINumber;
        UserData(j).ROIType = 'FV_BGROI';
        UserData(j).combinedROINumbers = [];
        UserData(j).ROIhandle = h;
        UserData(j).timeLastClick = clock;
        j = j+1;
    end
    
    if isfield(Aout,'roe') && ~isempty(Aout.roe)
        for i = 1:length(Aout.roe)
            UserData(j).roi.xi = Aout.roe(i).xi;
            UserData(j).roi.yi = Aout.roe(i).yi;
            hold on;
            h = plot(UserData(j).roi.xi,UserData(j).roi.yi,'m-');
            set(h,'ButtonDownFcn', 'FV_dragROI', 'Tag', 'FV_ROE', 'Color','magenta');
            hold off;
            ROINumber = nan;
            x = (min(UserData(j).roi.xi) + max(UserData(j).roi.xi))/2;
            y = (min(UserData(j).roi.yi) + max(UserData(j).roi.yi))/2;
            UserData(j).texthandle = text(x,y,'EX','HorizontalAlignment',...
                'Center','VerticalAlignment','Middle', 'Color','magenta','ButtonDownFcn', 'FV_dragROIText');
            UserData(j).number = ROINumber;
            UserData(j).ROIType = 'FV_ROE';
            UserData(j).combinedROINumbers = [];
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
    
    if currentStruct.state.loadSettingOpt.value % if also loading settings. This will only load z lim and thresh for lifetime that are saved in spc_stack calc
        %     state = currentStruct.state;
        % %     previousState = state;
        %     fieldNames = fieldnames(Aout.currentSettings.state);
        % %     fieldNames = fieldNames(~ismember(fieldNames, exclusionList));
        %     fieldNames = fieldNames(ismember(fieldNames, inclusionList));
        %     for i = 1:length(fieldNames)
        %         state.(fieldNames{i}) = Aout.currentSettings.state.(fieldNames{i});
        %     end
        FV_img.(currentStructName).state.lifetimeLumStrLow.string = num2str(Aout.threshForLifetime);
        
        %     if state ~= previousState % struct cannot be compare this way... just bypass for now.
        FV_setParaAccordingToState(handles);
        
        ind = find(Aout.roiNumber==0); % this is not always at the end as there may be merged ROIs.
        set(handles.zLimStrLow, 'String', num2str(Aout.roi(ind).z(1)));
        set(handles.zLimStrHigh, 'String', num2str(Aout.roi(ind).z(end)));
        
        FV_settingQuality(handles);% this is needed to set sliders.
        %         FV_updateDispSettingVar(handles); % displaySettings is set within FV_settingQuality.
        
        %         % check, and only regenerate MPET data if necessary to save computation effort
        %         if state.t0Setting.value ~= previousState.t0Setting.value ||...
        %                 ~strcmp(state.spcRangeLow.string, previousState.spcRangeLow.string)  ||...
        %                 ~strcmp(state.spcRangeHigh.string, previousState.spcRangeHigh.string)
        %             FV_calcMPETMap(handles); % recalc MPET map, but leave replot outside of loadsettings.
        %         end
        FV_replot(handles, 'slow');%Note: put getCurrentImg into replot
        %     end
    end
else
    disp(['ROI not loaded!  Cannot find file: ', fname,'_spcroi',num2str(analysisNumber),'.mat']);
end
            
    