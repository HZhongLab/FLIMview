function varargout = FV_lifetimeFittingGUI(varargin)
% FV_LIFETIMEFITTINGGUI MATLAB code for FV_lifetimeFittingGUI.fig
%      FV_LIFETIMEFITTINGGUI, by itself, creates a new FV_LIFETIMEFITTINGGUI or raises the existing
%      singleton*.
%
%      H = FV_LIFETIMEFITTINGGUI returns the handle to a new FV_LIFETIMEFITTINGGUI or the handle to
%      the existing singleton*.
%
%      FV_LIFETIMEFITTINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FV_LIFETIMEFITTINGGUI.M with the given input arguments.
%
%      FV_LIFETIMEFITTINGGUI('Property','Value',...) creates a new FV_LIFETIMEFITTINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FV_lifetimeFittingGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FV_lifetimeFittingGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FV_lifetimeFittingGUI

% Last Modified by GUIDE v2.5 26-Oct-2017 21:30:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FV_lifetimeFittingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FV_lifetimeFittingGUI_OutputFcn, ...
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


% --- Executes just before FV_lifetimeFittingGUI is made visible.
function FV_lifetimeFittingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FV_lifetimeFittingGUI (see VARARGIN)

% Choose default command line output for FV_lifetimeFittingGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FV_lifetimeFittingGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FV_lifetimeFittingGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in fixTau1Opt.
function fixTau1Opt_Callback(hObject, eventdata, handles)
% hObject    handle to fixTau1Opt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fixTau1Opt

FV_genericSettingCallback(hObject, handles);


% --- Executes on button press in fixTau2Opt.
function fixTau2Opt_Callback(hObject, eventdata, handles)
% hObject    handle to fixTau2Opt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fixTau2Opt

FV_genericSettingCallback(hObject, handles);


function pop1Str_Callback(hObject, eventdata, handles)
% hObject    handle to pop1Str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pop1Str as text
%        str2double(get(hObject,'String')) returns contents of pop1Str as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pop1Str_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop1Str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pop2Str_Callback(hObject, eventdata, handles)
% hObject    handle to pop2Str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pop2Str as text
%        str2double(get(hObject,'String')) returns contents of pop2Str as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pop2Str_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop2Str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tau1Str_Callback(hObject, eventdata, handles)
% hObject    handle to tau1Str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau1Str as text
%        str2double(get(hObject,'String')) returns contents of tau1Str as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function tau1Str_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau1Str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tau2Str_Callback(hObject, eventdata, handles)
% hObject    handle to tau2Str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau2Str as text
%        str2double(get(hObject,'String')) returns contents of tau2Str as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function tau2Str_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau2Str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in newLifetimePlot.
function newLifetimePlot_Callback(hObject, eventdata, handles)
% hObject    handle to newLifetimePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fig = figure('Tag','FVPlot','ButtonDownFcn','FV_selectCurrentPlot', 'Name', 'Lifetime Curve');
FV_selectCurrentPlot;


% --- Executes on button press in drawLifetime.
function drawLifetime_Callback(hObject, eventdata, handles)
% hObject    handle to drawLifetime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_drawLifetimeCurve(handles);


% --- Executes on button press in holdLifetimePlot.
function holdLifetimePlot_Callback(hObject, eventdata, handles)
% hObject    handle to holdLifetimePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of holdLifetimePlot

FV_genericSettingCallback(hObject, handles);


function drawLifetimeROINum_Callback(hObject, eventdata, handles)
% hObject    handle to drawLifetimeROINum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drawLifetimeROINum as text
%        str2double(get(hObject,'String')) returns contents of drawLifetimeROINum as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function drawLifetimeROINum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drawLifetimeROINum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fixT0Opt.
function fixT0Opt_Callback(hObject, eventdata, handles)
% hObject    handle to fixT0Opt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fixT0Opt

FV_genericSettingCallback(hObject, handles);


function t0Str_Callback(hObject, eventdata, handles)
% hObject    handle to t0Str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t0Str as text
%        str2double(get(hObject,'String')) returns contents of t0Str as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function t0Str_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t0Str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fixBeta6Opt.
function fixBeta6Opt_Callback(hObject, eventdata, handles)
% hObject    handle to fixBeta6Opt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fixBeta6Opt

FV_genericSettingCallback(hObject, handles);


function beta6Str_Callback(hObject, eventdata, handles)
% hObject    handle to beta6Str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beta6Str as text
%        str2double(get(hObject,'String')) returns contents of beta6Str as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function beta6Str_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta6Str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lifetimeSPCRangeStrHigh_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeSPCRangeStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lifetimeSPCRangeStrHigh as text
%        str2double(get(hObject,'String')) returns contents of lifetimeSPCRangeStrHigh as a double

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

spcInd = round(str2double(get(hObject, 'String'))*1000/currentStruct.info.datainfo.psPerUnit);
if spcInd>currentStruct.info.size(1)
    spcInd = currentStruct.info.size(1);
end
spcValue = round(spcInd*currentStruct.info.datainfo.psPerUnit/100)/10;
set(hObject,'String',num2str(spcValue));

FV_genericSettingCallback(hObject, handles);



% --- Executes during object creation, after setting all properties.
function lifetimeSPCRangeStrHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeSPCRangeStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lifetimeSPCRangeStrLow_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeSPCRangeStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lifetimeSPCRangeStrLow as text
%        str2double(get(hObject,'String')) returns contents of lifetimeSPCRangeStrLow as a double

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

spcStartInd = round(str2double(get(handles.lifetimeSPCRangeStrLow, 'String'))*1000/currentStruct.info.datainfo.psPerUnit);
if spcStartInd < 1
    spcStartInd = 1;
end
spcStart = round(spcStartInd*currentStruct.info.datainfo.psPerUnit/100)/10;
set(handles.lifetimeSPCRangeStrLow,'String',num2str(spcStart));

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lifetimeSPCRangeStrLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeSPCRangeStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fitLifetime.
function fitLifetime_Callback(hObject, eventdata, handles)
% hObject    handle to fitLifetime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_executeFitLifetime(handles);


% --- Executes on selection change in lifetimeFittingOpt.
function lifetimeFittingOpt_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeFittingOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lifetimeFittingOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lifetimeFittingOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lifetimeFittingOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeFittingOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
