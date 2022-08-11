function varargout = FV_frameAnalysisGUI(varargin)
% FV_FRAMEANALYSISGUI MATLAB code for FV_frameAnalysisGUI.fig
%      FV_FRAMEANALYSISGUI, by itself, creates a new FV_FRAMEANALYSISGUI or raises the existing
%      singleton*.
%
%      H = FV_FRAMEANALYSISGUI returns the handle to a new FV_FRAMEANALYSISGUI or the handle to
%      the existing singleton*.
%
%      FV_FRAMEANALYSISGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FV_FRAMEANALYSISGUI.M with the given input arguments.
%
%      FV_FRAMEANALYSISGUI('Property','Value',...) creates a new FV_FRAMEANALYSISGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FV_frameAnalysisGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FV_frameAnalysisGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FV_frameAnalysisGUI

% Last Modified by GUIDE v2.5 25-Oct-2017 12:14:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FV_frameAnalysisGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FV_frameAnalysisGUI_OutputFcn, ...
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


% --- Executes just before FV_frameAnalysisGUI is made visible.
function FV_frameAnalysisGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FV_frameAnalysisGUI (see VARARGIN)

% Choose default command line output for FV_frameAnalysisGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FV_frameAnalysisGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FV_frameAnalysisGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in frameAnalysisPlot.
function frameAnalysisPlot_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_frameAnalysisPlot(handles);


% --- Executes on selection change in frameAnalysisPlotDataOpt.
function frameAnalysisPlotDataOpt_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisPlotDataOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns frameAnalysisPlotDataOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from frameAnalysisPlotDataOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frameAnalysisPlotDataOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameAnalysisPlotDataOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in newPlot.
function newPlot_Callback(hObject, eventdata, handles)
% hObject    handle to newPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fig = figure('Tag','FVPlot','ButtonDownFcn','FV_selectCurrentPlot');
FV_selectCurrentPlot;


% --- Executes on button press in frameAnalysisHoldPlotOpt.
function frameAnalysisHoldPlotOpt_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisHoldPlotOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frameAnalysisHoldPlotOpt

FV_genericSettingCallback(hObject, handles);


function frameAnalysisBaselineNum_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisBaselineNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameAnalysisBaselineNum as text
%        str2double(get(hObject,'String')) returns contents of frameAnalysisBaselineNum as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frameAnalysisBaselineNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameAnalysisBaselineNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frameAnalysisPlotROINum_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisPlotROINum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameAnalysisPlotROINum as text
%        str2double(get(hObject,'String')) returns contents of frameAnalysisPlotROINum as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frameAnalysisPlotROINum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameAnalysisPlotROINum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frameAnalysisXLimSetting_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisXLimSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameAnalysisXLimSetting as text
%        str2double(get(hObject,'String')) returns contents of frameAnalysisXLimSetting as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frameAnalysisXLimSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameAnalysisXLimSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frameAnalysisYLimSetting_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisYLimSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameAnalysisYLimSetting as text
%        str2double(get(hObject,'String')) returns contents of frameAnalysisYLimSetting as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frameAnalysisYLimSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameAnalysisYLimSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in frameAnalysisLineColorOpt.
function frameAnalysisLineColorOpt_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisLineColorOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns frameAnalysisLineColorOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from frameAnalysisLineColorOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frameAnalysisLineColorOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameAnalysisLineColorOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in frameAnalysisLineStyleOpt.
function frameAnalysisLineStyleOpt_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisLineStyleOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns frameAnalysisLineStyleOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from frameAnalysisLineStyleOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frameAnalysisLineStyleOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameAnalysisLineStyleOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in frameAnalysisGrpPlotAvgOpt.
function frameAnalysisGrpPlotAvgOpt_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisGrpPlotAvgOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns frameAnalysisGrpPlotAvgOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from frameAnalysisGrpPlotAvgOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frameAnalysisGrpPlotAvgOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameAnalysisGrpPlotAvgOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in frameAnalysisGrpPlot.
function frameAnalysisGrpPlot_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisGrpPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in frameAnalysisGrpCalc.
function frameAnalysisGrpCalc_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisGrpCalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_frameAnalysisGroupCalc(handles);


% --- Executes on button press in frameAnalysisAPosOpt.
function frameAnalysisAPosOpt_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisAPosOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frameAnalysisAPosOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes on selection change in frameAnalysisGrpCalcOpt.
function frameAnalysisGrpCalcOpt_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisGrpCalcOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns frameAnalysisGrpCalcOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from frameAnalysisGrpCalcOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frameAnalysisGrpCalcOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameAnalysisGrpCalcOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in frameAnalysisPauseGrpCalc.
function frameAnalysisPauseGrpCalc_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisPauseGrpCalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frameAnalysisPauseGrpCalc

FV_genericSettingCallback(hObject, handles);
currentValue = get(hObject,'Value');
if currentValue
    uiwait;
else
    uiresume;
end


% --- Executes on button press in frameAnalysisCalc.
function frameAnalysisCalc_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisCalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FVFrameAnalysis = FV_executeFrameAnalysisCalc(handles)


% --- Executes on button press in frameAnalysisLoad.
function frameAnalysisLoad_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_loadFrameAnalysisROI(handles);


% --- Executes on button press in frameAnalysisLoadSettingOpt.
function frameAnalysisLoadSettingOpt_Callback(hObject, eventdata, handles)
% hObject    handle to frameAnalysisLoadSettingOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frameAnalysisLoadSettingOpt

FV_genericSettingCallback(hObject, handles);
