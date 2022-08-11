function varargout = FV_miscGUI(varargin)
% FV_MISCGUI MATLAB code for FV_miscGUI.fig
%      FV_MISCGUI, by itself, creates a new FV_MISCGUI or raises the existing
%      singleton*.
%
%      H = FV_MISCGUI returns the handle to a new FV_MISCGUI or the handle to
%      the existing singleton*.
%
%      FV_MISCGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FV_MISCGUI.M with the given input arguments.
%
%      FV_MISCGUI('Property','Value',...) creates a new FV_MISCGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FV_miscGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FV_miscGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FV_miscGUI

% Last Modified by GUIDE v2.5 21-May-2018 20:38:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FV_miscGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FV_miscGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FV_miscGUI is made visible.
function FV_miscGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FV_miscGUI (see VARARGIN)

% Choose default command line output for FV_miscGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FV_miscGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FV_miscGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in duplicateAnalysis.
function duplicateAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to duplicateAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

currentFilename = currentStruct.info.filename;
[currentPName, currentFName] = h_analyzeFilename(currentFilename);% note: currentFName has extention.
analysisNum = currentStruct.state.analysisNum.value;
targetAnalysisNum = currentStruct.state.analysisNumToBeCopiedTo.value;

if ~isfield(currentStruct.activeGroup, 'groupFiles') || isempty(currentStruct.activeGroup.groupFiles)
    display('No active group. Abort!')
    return;
end

if ~ismember(lower(currentFName),lower({currentStruct.activeGroup.groupFiles.fname}'))
    disp('Analysis not copied! Current image does not belong to the active group!');
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
        
        [pname, fname, fExt] = fileparts(filename);
        analysisFilename = fullfile(pname,'Analysis',[fname,'_FVROI_A', num2str(analysisNum), '.mat']);
        targetAnalysisFilename = fullfile(pname,'Analysis',[fname,'_FVROI_A', num2str(targetAnalysisNum), '.mat']);
        
        if analysisNum~=targetAnalysisNum
            if exist(analysisFilename, 'file')
                copyfile(analysisFilename, targetAnalysisFilename);
            else
                [pname1, fname1] = h_analyzeFilename(analysisFilename);
                display(['cannot find file: ', fname1]);
            end
        end
    end
    FV_updateInfo(handles);
end

        




% --- Executes on selection change in analysisNumToBeCopiedTo.
function analysisNumToBeCopiedTo_Callback(hObject, eventdata, handles)
% hObject    handle to analysisNumToBeCopiedTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns analysisNumToBeCopiedTo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from analysisNumToBeCopiedTo

FV_genericSettingCallback(hObject, handles);
FV_updateInfo(handles);


% --- Executes during object creation, after setting all properties.
function analysisNumToBeCopiedTo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analysisNumToBeCopiedTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function ROINumToBeDel_Callback(hObject, eventdata, handles)
% hObject    handle to ROINumToBeDel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROINumToBeDel as text
%        str2double(get(hObject,'String')) returns contents of ROINumToBeDel as a double

% FV_genericSettingCallback(hObject, handles); % don't save this. Allways reset to 'none'


% --- Executes during object creation, after setting all properties.
function ROINumToBeDel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROINumToBeDel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in delROIFromGrp.
function delROIFromGrp_Callback(hObject, eventdata, handles)
% hObject    handle to delROIFromGrp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

toBeDeletedROIStr = get(handles.ROINumToBeDel, 'string');

try
    if ~strcmpi(toBeDeletedROIStr, 'none')
        toBeDeleteROINumbers = eval(['[', toBeDeletedROIStr, ']',]);
        toBeDeleteROINumbers(toBeDeleteROINumbers==0) = []; % cannot delete ROI#0.
    else
        return;
    end
catch
    error(['error in evaluating ROI str: [',toBeDeletedROIStr,']'])
end

currentFilename = currentStruct.info.filename;
[currentPName, currentFName] = h_analyzeFilename(currentFilename);% note: currentFName has extention.
analysisNum = currentStruct.state.analysisNum.value;

if ~isfield(currentStruct.activeGroup, 'groupFiles') || isempty(currentStruct.activeGroup.groupFiles)
    display('No active group. Abort!')
    return;
end

if ~ismember(lower(currentFName),lower({currentStruct.activeGroup.groupFiles.fname}'))
    disp('Analysis not copied! Current image does not belong to the active group!');
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
        
        [pname, fname, fExt] = fileparts(filename);
        analysisFilename = fullfile(pname,'Analysis',[fname,'_FVROI_A', num2str(analysisNum), '.mat']);
        
        if exist(analysisFilename, 'file')
            data = load(analysisFilename);
            Aout = data.Aout;
            
            currentROINumbers = Aout.ROINumber;
            currentSimpleROI_I = Aout.ROINumber<1000;
            currentCombinedROI_I = Aout.ROINumber>=1000;
            
            ind = find(ismember(Aout.ROINumber(currentSimpleROI_I), toBeDeleteROINumbers));
            %note this can be complicated as there can be combined
            %ROIs. Will only delete simple ROIs for now until later when
            %there is need.
           
            Aout.allROIInfo.ROI(ind-1) = [];%there is no ROI#0 information here.
            numOfRemainingSimpleROI = sum(currentSimpleROI_I)-1-length(ind);
            for j = 1:numOfRemainingSimpleROI
                Aout.allROIInfo.ROI(j).number = j;
            end
            Aout.bgIntensity(ind) = [];
            Aout.ROINumber = horzcat(0:numOfRemainingSimpleROI, currentROINumbers(currentCombinedROI_I));%currentSimpleROI_I also includes ROI#0
            Aout.avgIntensity(ind) = [];
            Aout.integratedIntensity(ind) = [];
            Aout.maxIntensity(ind) = [];
            Aout.MPET(ind) = [];
            Aout.includedPhotonNum(ind) = [];
            Aout.estMPETError(ind) = [];
            Aout.roiVol.total(ind) = [];
            Aout.roiVol.aboveThresh(ind) = [];
            Aout.roiVol.pctIncluded(ind) = [];
            Aout.lifetimeCurve(ind) = [];
            if ~isempty(Aout.lifetimeCurveFit) %it can be empty as fitting is not automatic.
                Aout.lifetimeCurveFit(ind) = [];  
            end
            save(analysisFilename, 'Aout');
        else
            [pname1, fname1] = h_analyzeFilename(analysisFilename);
            display(['cannot find file: ', fname1]);
        end
    end
%     FV_updateInfo(handles);
end
