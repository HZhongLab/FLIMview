function varargout = FV_roiControlGUI(varargin)
% FV_ROICONTROLGUI MATLAB code for FV_roiControlGUI.fig
%      FV_ROICONTROLGUI, by itself, creates a new FV_ROICONTROLGUI or raises the existing
%      singleton*.
%
%      H = FV_ROICONTROLGUI returns the handle to a new FV_ROICONTROLGUI or the handle to
%      the existing singleton*.
%
%      FV_ROICONTROLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FV_ROICONTROLGUI.M with the given input arguments.
%
%      FV_ROICONTROLGUI('Property','Value',...) creates a new FV_ROICONTROLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FV_roiControlGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FV_roiControlGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FV_roiControlGUI

% Last Modified by GUIDE v2.5 20-May-2018 17:13:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FV_roiControlGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FV_roiControlGUI_OutputFcn, ...
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


% --- Executes just before FV_roiControlGUI is made visible.
function FV_roiControlGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FV_roiControlGUI (see VARARGIN)

% Choose default command line output for FV_roiControlGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FV_roiControlGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FV_roiControlGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in makeBGROI.
function makeBGROI_Callback(hObject, eventdata, handles)
% hObject    handle to makeBGROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_makeBGROI(handles);


% --- Executes on button press in makeROI.
function makeROI_Callback(hObject, eventdata, handles)
% hObject    handle to makeROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_makeROI(handles);

% --- Executes on button press in lockROI.
function lockROI_Callback(hObject, eventdata, handles)
% hObject    handle to lockROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lockROI

FV_genericSettingCallback(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over lockROI.
function lockROI_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to lockROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function lockROI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lockROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

currentValue = get(hObject,'Value');
handles = guihandles(hObject);
if currentValue
    set(handles.lockROI,'Value',currentValue,'BackgroundColor',[0.8 0.8 0.8]);
else
    set(handles.lockROI,'Value',currentValue,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
end


% --- Executes on selection change in ROIShapeOpt.
function ROIShapeOpt_Callback(hObject, eventdata, handles)
% hObject    handle to ROIShapeOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ROIShapeOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ROIShapeOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ROIShapeOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROIShapeOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in ROISizeOpt.
function ROISizeOpt_Callback(hObject, eventdata, handles)
% hObject    handle to ROISizeOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ROISizeOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ROISizeOpt

FV_genericSettingCallback(hObject, handles);



% --- Executes during object creation, after setting all properties.
function ROISizeOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROISizeOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in makeXOutROI.
function makeXOutROI_Callback(hObject, eventdata, handles)
% hObject    handle to makeXOutROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_makeROE(handles)


% --- Executes on button press in deleteAll.
function deleteAll_Callback(hObject, eventdata, handles)
% hObject    handle to deleteAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);
h = get(handles.intensityImgAxes,'Children');
g = findobj(h,'Type','Image');
h(h==g(1)) = [];
delete(h);
h = get(handles.lifetimeImgAxes,'Children');
g = findobj(h,'Type','Image');
h(h==g(1)) = [];
delete(h);


% --- Executes on button press in autoPositionROI.
function autoPositionROI_Callback(hObject, eventdata, handles)
% hObject    handle to autoPositionROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_autoPosition(handles);


% --- Executes on selection change in autoPosOpt.
function autoPosOpt_Callback(hObject, eventdata, handles)
% hObject    handle to autoPosOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns autoPosOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from autoPosOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function autoPosOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to autoPosOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mergeROI.
function mergeROI_Callback(hObject, eventdata, handles)
% hObject    handle to mergeROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_mergeFVROI(handles);


function toBeMergedROINumStr_Callback(hObject, eventdata, handles)
% hObject    handle to toBeMergedROINumStr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of toBeMergedROINumStr as text
%        str2double(get(hObject,'String')) returns contents of toBeMergedROINumStr as a double


% --- Executes during object creation, after setting all properties.
function toBeMergedROINumStr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to toBeMergedROINumStr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in analysisNum.
function analysisNum_Callback(hObject, eventdata, handles)
% hObject    handle to analysisNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns analysisNum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from analysisNum

FV_genericSettingCallback(hObject, handles);
FV_updateInfo(handles);


% --- Executes during object creation, after setting all properties.
function analysisNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analysisNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in hideROIOpt.
function hideROIOpt_Callback(hObject, eventdata, handles)
% hObject    handle to hideROIOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hideROIOpt

FV_genericSettingCallback(hObject, handles);
FV_setObjVisibility(handles);


% --- Executes on button press in calcROI.
function calcROI_Callback(hObject, eventdata, handles)
% hObject    handle to calcROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

calcFVROI = FV_executeCalcROI(handles)


% --- Executes on button press in loadSettingOpt.
function loadSettingOpt_Callback(hObject, eventdata, handles)
% hObject    handle to loadSettingOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loadSettingOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes on button press in loadAnalyzedROIData.
function loadAnalyzedROIData_Callback(hObject, eventdata, handles)
% hObject    handle to loadAnalyzedROIData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_loadAnalyzedROI(handles)


% --- Executes on button press in loadAnalyzedSpc_stackData.
function loadAnalyzedSpc_stackData_Callback(hObject, eventdata, handles)
% hObject    handle to loadAnalyzedSpc_stackData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_loadSpc_stackROI(handles)


% --- Executes on button press in copyROIImg.
function copyROIImg_Callback(hObject, eventdata, handles)
% hObject    handle to copyROIImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_copyROIImg(handles);


% --- Executes on selection change in calcOpt.
function calcOpt_Callback(hObject, eventdata, handles)
% hObject    handle to calcOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns calcOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from calcOpt


% --- Executes during object creation, after setting all properties.
function calcOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calcOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in undoAPos.
function undoAPos_Callback(hObject, eventdata, handles)
% hObject    handle to undoAPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_restoreROIPos(handles);


% --- Executes on button press in loadASTData.
function loadASTData_Callback(hObject, eventdata, handles)
% hObject    handle to loadASTData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global FV_img;

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

[fname,pname] = uigetfile('*.dat*','Select a data file to open');
if ~(pname == 0)
    data = h_AST_readData(fullfile(pname,fname));
else
    return;
end

animalState.absDateNum = data(1,:);
animalState.relativeTimeInMin = (data(1,:) - data(1,1))*24*60;
animalState.activity = data(2,:);
if size(data,1)>2
    animalState.rawData = data(3,:);
else
    animalState.rawData = zeros(size(animalState.activity));
end
animalState.filename = fullfile(fullfile(pname,fname));

FV_img.(currentStructName).associatedData.animalState = animalState;

% set(handles.AST_fileName, 'String', animalState.filename);
FV_img.(currentStructName).state.AST_fileName.string = animalState.filename;
