function varargout = FV_groupControlGUI(varargin)
% FV_GROUPCONTROLGUI MATLAB code for FV_groupControlGUI.fig
%      FV_GROUPCONTROLGUI, by itself, creates a new FV_GROUPCONTROLGUI or raises the existing
%      singleton*.
%
%      H = FV_GROUPCONTROLGUI returns the handle to a new FV_GROUPCONTROLGUI or the handle to
%      the existing singleton*.
%
%      FV_GROUPCONTROLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FV_GROUPCONTROLGUI.M with the given input arguments.
%
%      FV_GROUPCONTROLGUI('Property','Value',...) creates a new FV_GROUPCONTROLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FV_groupControlGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FV_groupControlGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FV_groupControlGUI

% Last Modified by GUIDE v2.5 08-May-2018 09:27:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FV_groupControlGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FV_groupControlGUI_OutputFcn, ...
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


% --- Executes just before FV_groupControlGUI is made visible.
function FV_groupControlGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FV_groupControlGUI (see VARARGIN)

% Choose default command line output for FV_groupControlGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FV_groupControlGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FV_groupControlGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in makeNewGrp.
function makeNewGrp_Callback(hObject, eventdata, handles)
% hObject    handle to makeNewGrp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_newGroup(handles);


% --- Executes on button press in openGrp.
function openGrp_Callback(hObject, eventdata, handles)
% hObject    handle to openGrp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

d = dir('*.grp');
if isempty(d) && exist(fullfile(pwd, 'Analysis'), 'dir')
    cd Analysis;
    [fname,pname] = uigetfile('*.grp','Select an group file to open');
    cd ..;
else
    [fname,pname] = uigetfile('*.grp','Select an group file to open');
end

if fname~=0
    FV_openGroup(handles, fullfile(pname, fname));
end


% --- Executes on button press in addToCurrentGrp.
function addToCurrentGrp_Callback(hObject, eventdata, handles)
% hObject    handle to addToCurrentGrp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFilename = get(handles.currentFileName,'String');
if isempty(strfind(currentFilename,'currentFileName'))
    FV_addToCurrentGroup(handles, currentFilename); % updateInfo is call within the function.
end


% --- Executes on button press in removeFromCurrentGrp.
function removeFromCurrentGrp_Callback(hObject, eventdata, handles)
% hObject    handle to removeFromCurrentGrp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFilename = get(handles.currentFileName,'String');
FV_removeFromCurrentGroup(handles,currentFilename); % updateInfo is call within the function.


% --- Executes on button press in batchAdd2.
function batchAdd2_Callback(hObject, eventdata, handles)
% hObject    handle to batchAdd2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% [fname, pname] = uigetfile({'*.tif'}, 'MultiSelect', 'on');
% 
% if ischar(pname) %not cancel
%     fname = cellstr(fname);
%     for i = 1:length(fname)
%         FV_addToCurrentGroup(handles, fullfile(pname, fname{i}));
%     end
%     FV_updateInfo(handles);
% end

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

h = FV_searchForGroupGUI;
UData.instanceInd = currentInd;
set(h, 'UserData', UData); % to pass the FLIMview index to the guide.

pos = get(handles.FLIMview, 'Position');
pos2 = get(h,'Position');
pos2(1) = pos(1) + 20;
pos2(2) = pos(2) + pos(4)/2;
set(h,'Position', pos2);

h_handles = guihandles(h);

currentFilename = get(handles.currentFileName,'String');
[pname,fname,fExt] = fileparts(currentFilename);
if isempty(strfind(currentFilename,'currentFileName'))
    set(h_handles.pathName,'String',pname);
    if ~strcmp(fname(end-2:end),'max')
        set(h_handles.fileBasename,'String',fname(1:end-3));
        set(h_handles.maxOpt,'Value',0);
    else
        set(h_handles.fileBasename,'String',fname(1:end-7));
        set(h_handles.maxOpt,'Value',1);
    end
end


% --- Executes on button press in openPreviousInGroup.
function openPreviousInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openPreviousInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_openDiffFileInGrp(handles, 'previous');


% --- Executes on button press in openNextInGroup.
function openNextInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openNextInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_openDiffFileInGrp(handles, 'next');


% --- Executes on button press in openFirstInGroup.
function openFirstInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openFirstInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_openDiffFileInGrp(handles, 'first');


% --- Executes on button press in openLastInGroup.
function openLastInGroup_Callback(hObject, eventdata, handles)
% hObject    handle to openLastInGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_openDiffFileInGrp(handles, 'last');


% --- Executes on button press in grpCalc.
function grpCalc_Callback(hObject, eventdata, handles)
% hObject    handle to grpCalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_groupCalc(handles);


% --- Executes on button press in autoPosWhenGrpCalc.
function autoPosWhenGrpCalc_Callback(hObject, eventdata, handles)
% hObject    handle to autoPosWhenGrpCalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoPosWhenGrpCalc

FV_genericSettingCallback(hObject, handles);


% --- Executes on selection change in grpCalcOpt.
function grpCalcOpt_Callback(hObject, eventdata, handles)
% hObject    handle to grpCalcOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns grpCalcOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from grpCalcOpt

FV_genericSettingCallback(hObject, handles);



% --- Executes during object creation, after setting all properties.
function grpCalcOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grpCalcOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pauseGrpCalc.
function pauseGrpCalc_Callback(hObject, eventdata, handles)
% hObject    handle to pauseGrpCalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pauseGrpCalc

FV_genericSettingCallback(hObject, handles);
currentValue = get(hObject,'Value');
if currentValue
    uiwait;
else
    uiresume;
end


% --- Executes on button press in grpPlot.
function grpPlot_Callback(hObject, eventdata, handles)
% hObject    handle to grpPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_plotGroupFcn(handles);

% --- Executes on button press in checkZPos.
function checkZPos_Callback(hObject, eventdata, handles)
% hObject    handle to checkZPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% this is trying to do a quick check on whether the relative position in z
% is OK for individual ROIs.

FV_checkZPos(handles);

% --- Executes on selection change in grpPlotDataOpt.
function grpPlotDataOpt_Callback(hObject, eventdata, handles)
% hObject    handle to grpPlotDataOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns grpPlotDataOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from grpPlotDataOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function grpPlotDataOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grpPlotDataOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in newGrpPlot.
function newGrpPlot_Callback(hObject, eventdata, handles)
% hObject    handle to newGrpPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fig = figure('Tag','FVPlot','ButtonDownFcn','FV_selectCurrentPlot');
FV_selectCurrentPlot;


% --- Executes on button press in holdGrpPlot.
function holdGrpPlot_Callback(hObject, eventdata, handles)
% hObject    handle to holdGrpPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of holdGrpPlot

FV_genericSettingCallback(hObject, handles);


function baselinePos_Callback(hObject, eventdata, handles)
% hObject    handle to baselinePos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of baselinePos as text
%        str2double(get(hObject,'String')) returns contents of baselinePos as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function baselinePos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baselinePos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function grpPlotROIOpt_Callback(hObject, eventdata, handles)
% hObject    handle to grpPlotROIOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grpPlotROIOpt as text
%        str2double(get(hObject,'String')) returns contents of grpPlotROIOpt as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function grpPlotROIOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grpPlotROIOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xLimSetting_Callback(hObject, eventdata, handles)
% hObject    handle to xLimSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xLimSetting as text
%        str2double(get(hObject,'String')) returns contents of xLimSetting as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function xLimSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xLimSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yLimSetting_Callback(hObject, eventdata, handles)
% hObject    handle to yLimSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yLimSetting as text
%        str2double(get(hObject,'String')) returns contents of yLimSetting as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function yLimSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yLimSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in grpPlotColorOpt.
function grpPlotColorOpt_Callback(hObject, eventdata, handles)
% hObject    handle to grpPlotColorOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns grpPlotColorOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from grpPlotColorOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function grpPlotColorOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grpPlotColorOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in grpPlotStyleOpt.
function grpPlotStyleOpt_Callback(hObject, eventdata, handles)
% hObject    handle to grpPlotStyleOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns grpPlotStyleOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from grpPlotStyleOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function grpPlotStyleOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grpPlotStyleOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in grpPlotAvgOpt.
function grpPlotAvgOpt_Callback(hObject, eventdata, handles)
% hObject    handle to grpPlotAvgOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns grpPlotAvgOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from grpPlotAvgOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function grpPlotAvgOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grpPlotAvgOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
