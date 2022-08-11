function FV_openFile(handles, fname)

global FV_img;

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

if exist(fname, 'file')
    [pathname,filename,fExt] = fileparts(fname);
    if isempty(pathname)
        pathname = pwd;
    end
    if ~strcmpi(pathname(end-2:end),'spc') % images files are usually under a folder called 'spc'
        if exist(fullfile(pathname, 'spc'), 'dir')
            pathname = fullfile(pathname, 'spc');
        end
    end
    cd (pathname);
    
    filestr = fullfile(pathname,[filename,fExt]); % this is to reused the spc_stack codes

%     if isfield(currentStruct.image,'currentImg') % this is no longer
%     needed as all fields will be initialized to ensure structures are the
%     same across instances and images.
    currentStruct.display.previousIntensityImg = currentStruct.display.intensityImg;
    currentStruct.display.previousActivityImg = currentStruct.display.activityImg;
%     end
    [currentStruct.info, currentStruct.image.imageMod, currentStruct.image.intensity] = FV_loadSpcTiff(filestr);
    
    FV_img.(currentStructName) = currentStruct;

    set(handles.currentFileName,'String',filestr);
    [xlim,ylim,zlim] = FV_getLimits(handles);
    
    set(handles.zLimStrLow,'String', num2str(zlim(1)));
    set(handles.zLimStrHigh,'String', num2str(zlim(2)));
    
%     ss_zStackQuality(handles);
    set([handles.intensityImgAxes; handles.lifetimeImgAxes],'XLim',xlim,'YLim',ylim);
    FV_settingQuality(handles); % this combines former zStackQuality, intensityQuality and lifetimeQuality, and spcSetRange.
    % FV_updateStateVar and FV_updateDispSettingVar are called within FV_settingQuality
    
    FV_calcMPETMap(handles);
%     ss_getCurrentSpcImg(handles);  
%     ss_intensityQuality(handles);
%     ss_lifetimeQuality(handles);
    FV_replot(handles, 'slow');%Note: put getCurrentImg into replot
    
    
%     ss_roiQuality(handles.spc_stack);
    FV_updateInfo(handles);
else
        disp('Not a valid spc file name');
end
