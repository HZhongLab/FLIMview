function varargout = FLIMview(varargin)
% FLIMVIEW MATLAB code for FLIMview.fig
%      FLIMVIEW, by itself, creates a new FLIMVIEW or raises the existing
%      singleton*.
%
%      H = FLIMVIEW returns the handle to a new FLIMVIEW or the handle to
%      the existing singleton*.
%
%      FLIMVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLIMVIEW.M with the given input arguments.
%
%      FLIMVIEW('Property','Value',...) creates a new FLIMVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FLIMview_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FLIMview_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FLIMview

% Last Modified by GUIDE v2.5 04-Jun-2022 00:40:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FLIMview_OpeningFcn, ...
                   'gui_OutputFcn',  @FLIMview_OutputFcn, ...
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


% --- Executes just before FLIMview is made visible.
function FLIMview_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FLIMview (see VARARGIN)

% Choose default command line output for FLIMview
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FLIMview wait for user response (see UIRESUME)
% uiwait(handles.FLIMview);

global FV_img;

% delete(findobj('Type','figure','Children',[])); %sometimes there may be an empty figure created...
[existingInst, nextInst] = FV_existingInst;

currentStruct = struct('instanceInd', nextInst, 'info',struct,'image',struct,'display',struct,'state',struct,'gh',struct,'lastAnalysis',struct,'internal',struct, 'activeGroup', struct);
display = struct('previousIntensityImg', zeros(64), 'previousActivityImg', zeros(64),...
    'intensityImg', zeros(64), 'activityImg', zeros(64), 'settings', struct);
currentStruct.display = display;

image = struct('imageMod', [], 'intensity', [], 'MPETMap', [], 'MPETIntensity', []);
currentStruct.image = image;

currentStruct.gh.currentHandles = guihandles(hObject);

windowName = ['FLIMview Instance ', num2str(nextInst)];
UData.instanceInd = nextInst;

set(handles.FLIMview, 'UserData', UData, 'Name', windowName);
FV_img.(['Inst', num2str(nextInst)]) = currentStruct;


err = FV_loadSettings(handles,1);% setting 1 is default.

if err % if there is error or if there is no setting file
    FV_updateStateVar(handles);
    FV_updateDispSettingVar(handles);
end

FV_setupMenu(handles, 'upper');
FV_setupMenu(handles, 'lower');

% axes(handles.imageAxes);
% im = ones(128,128,3);
% image(im,'ButtonDownFcn','h_doubleClickMakeRoi3');
% set(handles.imageAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'imageAxes','ButtonDownFcn','h_doubleClickMakeRoi3' );


% --- Outputs from this function are returned to the command line.
function varargout = FLIMview_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on key press with focus on FLIMview or any of its controls.
function FLIMview_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to FLIMview (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

FV_hotKeyControls(handles, eventdata);

% --- Executes on key press with focus on FLIMview and none of its controls.
function FLIMview_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to FLIMview (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when FLIMview is resized.
function FLIMview_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to FLIMview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_resizingFcn(handles)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function lifetimeLumSliderLow_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeLumSliderLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
maxIntensity = FV_getMaxIntensity(handles);
value2 = round(value*maxIntensity);
set(handles.lifetimeLumStrLow,'String',num2str(value2));
FV_settingQuality(handles);
FV_replot(handles, 'slow');


% --- Executes during object creation, after setting all properties.
function lifetimeLumSliderLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeLumSliderLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function lifetimeLumSliderHigh_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeLumSliderHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
maxIntensity = FV_getMaxIntensity(handles);
value2 = round(value*maxIntensity);
set(handles.lifetimeLumStrHigh,'String',num2str(value2));
FV_settingQuality(handles);
FV_replot(handles, 'slow');


% --- Executes during object creation, after setting all properties.
function lifetimeLumSliderHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeLumSliderHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function lifetimeLumStrLow_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeLumStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lifetimeLumStrLow as text
%        str2double(get(hObject,'String')) returns contents of lifetimeLumStrLow as a double

FV_settingQuality(handles); % this function includes update state and displaySetting variables and sets sliders.
FV_replot(handles, 'slow');


% --- Executes during object creation, after setting all properties.
function lifetimeLumStrLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeLumStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lifetimeLumStrHigh_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeLumStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lifetimeLumStrHigh as text
%        str2double(get(hObject,'String')) returns contents of lifetimeLumStrHigh as a double

FV_settingQuality(handles); % this function includes update state and displaySetting variables and sets sliders.
FV_replot(handles, 'slow'); % usually 'fast' is good, but in case it goes below the low limit then get switched.


% --- Executes during object creation, after setting all properties.
function lifetimeLumStrHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeLumStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in maxProjOpt.
function maxProjOpt_Callback(hObject, eventdata, handles)
% hObject    handle to maxProjOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of maxProjOpt

FV_settingQuality(handles);
FV_replot(handles, 'slow');

% --- Executes on slider movement.
function intensitySliderLow_Callback(hObject, eventdata, handles)
% hObject    handle to intensitySliderLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
maxIntensity = FV_getMaxIntensity(handles);
value2 = round(value*maxIntensity);
set(handles.intensityLimStrLow,'String',num2str(value2));
FV_settingQuality(handles);
FV_replot(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function intensitySliderLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intensitySliderLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function intensitySliderHigh_Callback(hObject, eventdata, handles)
% hObject    handle to intensitySliderHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
maxIntensity = FV_getMaxIntensity(handles);
value2 = round(value*maxIntensity);
set(handles.intensityLimStrHigh,'String',num2str(value2));
FV_settingQuality(handles);
FV_replot(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function intensitySliderHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intensitySliderHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function intensityLimStrLow_Callback(hObject, eventdata, handles)
% hObject    handle to intensityLimStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intensityLimStrLow as text
%        str2double(get(hObject,'String')) returns contents of intensityLimStrLow as a double

FV_settingQuality(handles); % this function includes update state and displaySetting variables and sets sliders.
FV_replot(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function intensityLimStrLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intensityLimStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function intensityLimStrHigh_Callback(hObject, eventdata, handles)
% hObject    handle to intensityLimStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intensityLimStrHigh as text
%        str2double(get(hObject,'String')) returns contents of intensityLimStrHigh as a double

FV_settingQuality(handles); % this function includes update state and displaySetting variables and sets sliders.
FV_replot(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function intensityLimStrHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intensityLimStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zLimStrLow_Callback(hObject, eventdata, handles)
% hObject    handle to zLimStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zLimStrLow as text
%        str2double(get(hObject,'String')) returns contents of zLimStrLow as a double

FV_settingQuality(handles); % this function includes update state and displaySetting variables and sets sliders.
FV_replot(handles, 'slow');


% --- Executes during object creation, after setting all properties.
function zLimStrLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zLimStrLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zLimStrHigh_Callback(hObject, eventdata, handles)
% hObject    handle to zLimStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zLimStrHigh as text
%        str2double(get(hObject,'String')) returns contents of zLimStrHigh as a double

FV_settingQuality(handles); % this function includes update state and displaySetting variables and sets sliders.
FV_replot(handles, 'slow');


% --- Executes during object creation, after setting all properties.
function zLimStrHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zLimStrHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function zSliderLow_Callback(hObject, eventdata, handles)
% hObject    handle to zSliderLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
[xlim,ylim,zlim] = FV_getLimits(handles);
zLow = round(value*(diff(zlim))+1);
set(handles.zLimStrLow, 'String', num2str(zLow));
FV_settingQuality(handles);
FV_replot(handles, 'slow');


% --- Executes during object creation, after setting all properties.
function zSliderLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zSliderLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function zSliderHigh_Callback(hObject, eventdata, handles)
% hObject    handle to zSliderHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
[xlim,ylim,zlim] = FV_getLimits(handles);
zHigh = round(value*(diff(zlim))+1);
set(handles.zLimStrHigh, 'String', num2str(zHigh));
FV_settingQuality(handles);
FV_replot(handles, 'slow');

% --- Executes during object creation, after setting all properties.
function zSliderHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zSliderHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in openImg.
function openImg_Callback(hObject, eventdata, handles)
% hObject    handle to openImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% [currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

[fname,pname] = uigetfile('*.tif','Select an imaging file to open');
if ~(pname == 0)
    FV_openFile(handles,fullfile(pname,fname));
end


% --- Executes on button press in jumpPrevious.
function jumpPrevious_Callback(hObject, eventdata, handles)
% hObject    handle to jumpPrevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

step = str2double(get(handles.jumpStep, 'string'));
FV_openAnotherFile(handles, -step)

% --- Executes on button press in openPrevious.
function openPrevious_Callback(hObject, eventdata, handles)
% hObject    handle to openPrevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_openAnotherFile(handles, -1);

% --- Executes on button press in openNext.
function openNext_Callback(hObject, eventdata, handles)
% hObject    handle to openNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_openAnotherFile(handles, 1);


% --- Executes on button press in jumpNext.
function jumpNext_Callback(hObject, eventdata, handles)
% hObject    handle to jumpNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

step = str2double(get(handles.jumpStep, 'string'));
FV_openAnotherFile(handles, step)


function jumpStep_Callback(hObject, eventdata, handles)
% hObject    handle to jumpStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jumpStep as text
%        str2double(get(hObject,'String')) returns contents of jumpStep as a double


% --- Executes during object creation, after setting all properties.
function jumpStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jumpStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in autoSetLifetimeLum.
function autoSetLifetimeLum_Callback(hObject, eventdata, handles)
% hObject    handle to autoSetLifetimeLum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

intensityCLim = currentStruct.display.settings.intensityLimit;

climit = round(h_climit(currentStruct.display.intensityImg,0.55,0.95));
if climit(1) <= intensityCLim(1)
    climit(1) = intensityCLim(1) + 1; % at least 1.
end
climit(2) = intensityCLim(1) + 0.65*diff(intensityCLim);

set(handles.lifetimeLumStrLow,'String', num2str(climit(1)));
set(handles.lifetimeLumStrHigh,'String', num2str(climit(2)));

FV_settingQuality(handles);
FV_replot(handles, 'slow');


% --- Executes on button press in autoSetIntensityLimits.
function autoSetIntensityLimits_Callback(hObject, eventdata, handles)
% hObject    handle to autoSetIntensityLimits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

climit = round(h_climit(currentStruct.display.intensityImg,0.1,0.99));
if climit(1) == 0
    climit(1) = 1; % at least 1.
end
set(handles.intensityLimStrLow,'String', num2str(climit(1)));
set(handles.intensityLimStrHigh,'String', num2str(climit(2)));

FV_settingQuality(handles);
FV_replot(handles, 'fast');


% --- Executes on button press in fullZ.
function fullZ_Callback(hObject, eventdata, handles)
% hObject    handle to fullZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[xlim,ylim,zlim] = FV_getLimits(handles);
set(handles.zLimStrLow,'String', num2str(1));
set(handles.zLimStrHigh,'String', num2str(zlim(2)));
set(handles.maxProjOpt,'Value', 1);

FV_settingQuality(handles);
FV_replot(handles, 'slow');


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in viewingAxis.
function viewingAxis_Callback(hObject, eventdata, handles)
% hObject    handle to viewingAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns viewingAxis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from viewingAxis

FV_viewingAxisControl(handles);
% FV_genericSettingCallback(hObject, handles);%update state only after everything is set.
% state is now updated within FV_viewingAxesControl.


% --- Executes during object creation, after setting all properties.
function viewingAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to viewingAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function XYRatio_Callback(hObject, eventdata, handles)
% hObject    handle to XYRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XYRatio as text
%        str2double(get(hObject,'String')) returns contents of XYRatio as a double

FV_genericSettingCallback(handles);


% --- Executes during object creation, after setting all properties.
function XYRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XYRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function lifetimeSliderLow_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeSliderLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
[minLifetime, maxLifetime] = FV_getLifetimeLimitBoundary(handles);
lifetimeRange = maxLifetime - minLifetime;
newValue = value*lifetimeRange  + minLifetime;
set(handles.lifetimeLimitLow, 'String', num2str(newValue));
FV_settingQuality(handles);
FV_replot(handles, 'fast');

% --- Executes during object creation, after setting all properties.
function lifetimeSliderLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeSliderLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function lifetimeSliderHigh_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeSliderHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = get(hObject,'Value');
[minLifetime, maxLifetime] = FV_getLifetimeLimitBoundary(handles);
lifetimeRange = maxLifetime - minLifetime;
newValue = value*lifetimeRange + minLifetime;
set(handles.lifetimeLimitHigh, 'String', num2str(newValue));
FV_settingQuality(handles);
FV_replot(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function lifetimeSliderHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeSliderHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function lifetimeLimitLow_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeLimitLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lifetimeLimitLow as text
%        str2double(get(hObject,'String')) returns contents of lifetimeLimitLow as a double

FV_settingQuality(handles); % this function includes update state and displaySetting variables and sets sliders.
FV_replot(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function lifetimeLimitLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeLimitLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lifetimeLimitHigh_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeLimitHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lifetimeLimitHigh as text
%        str2double(get(hObject,'String')) returns contents of lifetimeLimitHigh as a double

FV_settingQuality(handles); % this function includes update state and displaySetting variables and sets sliders.
FV_replot(handles, 'fast');


% --- Executes during object creation, after setting all properties.
function lifetimeLimitHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeLimitHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in autoSetLifetime.
function autoSetLifetime_Callback(hObject, eventdata, handles)
% hObject    handle to autoSetLifetime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in intensityCMapOpt.
function intensityCMapOpt_Callback(hObject, eventdata, handles)
% hObject    handle to intensityCMapOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns intensityCMapOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from intensityCMapOpt


% --- Executes during object creation, after setting all properties.
function intensityCMapOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intensityCMapOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lifetimeImgDisplayOpt.
function lifetimeImgDisplayOpt_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeImgDisplayOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lifetimeImgDisplayOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lifetimeImgDisplayOpt

value = get(hObject, 'Value');

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);
previousValue = currentStruct.state.lifetimeImgDisplayOpt.value;
lifetimeLimit = currentStruct.display.settings.lifetimeLimit;
LT0 = currentStruct.display.settings.LT0;

switch value
    case 1
        set([handles.LT0Text, handles.LT0Input], 'Visible', 'off');
        switch previousValue % try to automatically change the values.
            case 2
            case 3
                set(handles.lifetimeLimitLow, 'String', num2str(lifetimeLimit(1) + LT0));
                set(handles.lifetimeLimitHigh, 'String', num2str(lifetimeLimit(2) + LT0));
            case 4
                set(handles.lifetimeLimitLow, 'String', num2str(lifetimeLimit(1)*LT0 + LT0));
                set(handles.lifetimeLimitHigh, 'String', num2str(lifetimeLimit(2)*LT0 + LT0));
        end
    case 2
        set([handles.LT0Text, handles.LT0Input], 'Visible', 'off');
    case 3
        set([handles.LT0Text, handles.LT0Input], 'Visible', 'on');
        switch previousValue % try to automatically change the values.
            case 1
                set(handles.lifetimeLimitLow, 'String', num2str(lifetimeLimit(1) - LT0));
                set(handles.lifetimeLimitHigh, 'String', num2str(lifetimeLimit(2) - LT0));
            case 2
            case 4
                set(handles.lifetimeLimitLow, 'String', num2str(lifetimeLimit(1)*LT0));
                set(handles.lifetimeLimitHigh, 'String', num2str(lifetimeLimit(2)*LT0));
        end
    case 4
        set([handles.LT0Text, handles.LT0Input], 'Visible', 'on');
        switch previousValue % try to automatically change the values.
            case 1
                set(handles.lifetimeLimitLow, 'String', num2str((lifetimeLimit(1) - LT0)/LT0));
                set(handles.lifetimeLimitHigh, 'String', num2str((lifetimeLimit(2) - LT0)/LT0));
            case 2
            case 3
                set(handles.lifetimeLimitLow, 'String', num2str(lifetimeLimit(1)/LT0));
                set(handles.lifetimeLimitHigh, 'String', num2str(lifetimeLimit(2)/LT0));
        end
    otherwise
end
FV_updateStateVar(handles); % need to first update the setting, which affects FV_settingQuality.
FV_settingQuality(handles);
FV_replot(handles, 'slow');


% --- Executes during object creation, after setting all properties.
function lifetimeImgDisplayOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeImgDisplayOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in filterOpt.
function filterOpt_Callback(hObject, eventdata, handles)
% hObject    handle to filterOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filterOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filterOpt

FV_updateStateVar(handles);
FV_replot(handles, 'slow');


% --- Executes during object creation, after setting all properties.
function filterOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function saveDefault_Callback(hObject, eventdata, handles)
% hObject    handle to saveDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_saveSettings(handles, 1);


% --------------------------------------------------------------------
function saveSettings2_Callback(hObject, eventdata, handles)
% hObject    handle to saveSettings2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_saveSettings(handles, 2);


% --------------------------------------------------------------------
function saveSettings3_Callback(hObject, eventdata, handles)
% hObject    handle to saveSettings3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_saveSettings(handles, 3);


% --------------------------------------------------------------------
function loadDefault_Callback(hObject, eventdata, handles)
% hObject    handle to loadDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_loadSettings(handles, 1);
FV_replot(handles, 'slow');%Note: put getCurrentImg into replot


% --------------------------------------------------------------------
function loadSettings2_Callback(hObject, eventdata, handles)
% hObject    handle to loadSettings2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_loadSettings(handles, 2);
FV_replot(handles, 'slow');%Note: put getCurrentImg into replot


% --------------------------------------------------------------------
function loadSettings3_Callback(hObject, eventdata, handles)
% hObject    handle to loadSettings3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_loadSettings(handles, 3);
FV_replot(handles, 'slow');%Note: put getCurrentImg into replot


% --------------------------------------------------------------------
function OpenImg2_Callback(hObject, eventdata, handles)
% hObject    handle to OpenImg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fname,pname] = uigetfile('*.tif','Select an imaging file to open');
if ~(pname == 0)
    FV_openFile(handles,fullfile(pname,fname));
end


% --- Executes on selection change in higherMenuOpt.
function higherMenuOpt_Callback(hObject, eventdata, handles)
% hObject    handle to higherMenuOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns higherMenuOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from higherMenuOpt

FV_setupMenu(handles, 'upper');


% --- Executes during object creation, after setting all properties.
function higherMenuOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to higherMenuOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lowerMenuOpt.
function lowerMenuOpt_Callback(hObject, eventdata, handles)
% hObject    handle to lowerMenuOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lowerMenuOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lowerMenuOpt

FV_setupMenu(handles, 'lower');

% --- Executes during object creation, after setting all properties.
function lowerMenuOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowerMenuOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function FLIMview_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to FLIMview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global FV_img;

try
    currentInd = FV_getCurrendInst(handles);
    FV_img = rmfield(FV_img, ['Inst', num2str(currentInd)]);
    
    remainingFieldNames = fieldnames(FV_img);
    
    flag = 1;
    for i = 1:length(remainingFieldNames)
        if strfind(remainingFieldNames{i}, 'Inst')
            flag = 0;
            break;
        end
    end
    
    if flag
        clear global FV_img;
    end
end


% --- Executes on selection change in t0Setting.
function t0Setting_Callback(hObject, eventdata, handles)
% hObject    handle to t0Setting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns t0Setting contents as cell array
%        contents{get(hObject,'Value')} returns selected item from t0Setting

% FV_genericSettingCallback(hObject, handles); % this is no need. It will be updated in FV_settingQuality (via FV_updateStateVar)

FV_settingQuality(handles); % this combines former zStackQuality, intensityQuality and lifetimeQuality, and spcSetRange.
FV_calcMPETMap(handles);
FV_replot(handles, 'slow');%Note: put getCurrentImg into replot


% --- Executes during object creation, after setting all properties.
function t0Setting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t0Setting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function zPosSlider_Callback(hObject, eventdata, handles)
% hObject    handle to zPosSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

FV_resetZPos(handles)

% --- Executes during object creation, after setting all properties.
function zPosSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zPosSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function lifetimeFixedRangeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to lifetimeFixedRangeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

FV_resetLifetimeRange(handles);


% --- Executes during object creation, after setting all properties.
function lifetimeFixedRangeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetimeFixedRangeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in copyIntensityImg.
function copyIntensityImg_Callback(hObject, eventdata, handles)
% hObject    handle to copyIntensityImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);
h = figure('position',[100 100 600 600]);
c = copyobj(handles.intensityImgAxes,h);
set(c,'unit','normalized','position',[0 0 1 1]);

imgObj = findobj(c, 'type', 'image');
if ~isempty(imgObj)
    img = get(imgObj, 'cdata');
    siz = size(img);
    xlim = get(c, 'xlim');
    ylim = get(c, 'ylim');
    if diff(xlim) > siz(2) || diff(ylim) > siz(1)
        set(h, 'position', [100 100 600 siz(1)/siz(2)*600]);
        axis image
    end
end

% to adjust ROI line thickness and text size (the copied image is larger than on
% FLIMview)
% try to make lines thicker adn fonts larger if any
textObj = findobj(c, 'type', 'text');
set(textObj, 'FontSize', 30);
lineObj = findobj(c, 'Type', 'line');
set(lineObj, 'LineWidth', 2);
% 
% ROIObj = findobj(c,'Tag','FV_ROI');
% ROEObj = findobj(c, 'tag', 'FV_ROE');
% bgROIObj = findobj(c,'Tag','FV_BGROI');
% combinedROIObj = findobj(c,'Tag','combinedFVROI');
% 
% allROIObj = vertcat(ROIObj, ROEObj, bgROIObj, combinedROIObj);
% 
% set(allROIObj, 'Selected','off', 'SelectionHighlight','off','linewidth',2);
% 
% textHandles = findobj(c, 'Type', 'Text');
% set(textHandles, 'FontSize', 30);
% to adjust ROI line thickness and text size (the copied image is larger than on
% FLIMview)   

map = get(handles.FLIMview, 'colormap');
colormap(map);

print('-dbitmap','-noui',h);

delete(h);

% --- Executes on button press in copyLTImg.
function copyLTImg_Callback(hObject, eventdata, handles)
% hObject    handle to copyLTImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);
h = figure('position',[100 100 600 600]);
c = copyobj(handles.lifetimeImgAxes,h);
set(c,'unit','normalized','position',[0 0 1 1]);

imgObj = findobj(c, 'type', 'image');
if ~isempty(imgObj)
    img = get(imgObj, 'cdata');
    siz = size(img);
    xlim = get(c, 'xlim');
    ylim = get(c, 'ylim');
    if diff(xlim) > siz(2) || diff(ylim) > siz(1)
        set(h, 'position', [100 100 600 siz(1)/siz(2)*600]);
        axis image
    end    
end

% try to make lines thicker adn fonts larger if any
textObj = findobj(c, 'type', 'text');
set(textObj, 'FontSize', 30);
lineObj = findobj(c, 'Type', 'line');
set(lineObj, 'LineWidth', 2);

    
% map = get(handles.FLIMview, 'colormap');
% colormap(map);

print('-dbitmap','-noui',h);

delete(h);


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
    FV_addToCurrentGroup(handles, currentFilename);
    FV_updateInfo(handles);
end

% --- Executes on button press in makeNewGrp.
function makeNewGrp_Callback(hObject, eventdata, handles)
% hObject    handle to makeNewGrp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_newGroup(handles);

% --- Executes on button press in removeFromCurrentGrp.
function removeFromCurrentGrp_Callback(hObject, eventdata, handles)
% hObject    handle to removeFromCurrentGrp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentFilename = get(handles.currentFileName,'String');
FV_removeFromCurrentGroup(handles,currentFilename);
FV_updateInfo(handles);

% --- Executes on button press in lockROI.
function lockROI_Callback(hObject, eventdata, handles)
% hObject    handle to lockROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lockROI

FV_genericSettingCallback(hObject, handles);
% ptyName = get(hObject, 'Tag');
% currentValue = get(hObject,'Value');
% handles = guihandles(hObject);
% if currentValue
%     set(handles.(ptyName),'Value',currentValue,'BackgroundColor',[0.8 0.8 0.8]);
% else
%     set(handles.(ptyName),'Value',currentValue,'BackgroundColor',[ 0.9255    0.9137    0.8471]);
% end
% 
% global FV_img;  
% [currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);
% FV_img.(currentStructName).state.(ptyName).value = get(hObject,'Value');
% FV_img.(currentStructName).state.(ptyName).BackgroundColor = get(hObject,'BackgroundColor');%this is necessary for all toggle bottons.
% FV_setParaAccordingToState(handles);%this need to be add if there are multiple fields. 
% % h_updateInfo3(handles);


% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_makeBGROI(handles);


% --- Executes on button press in calcROI.
function calcROI_Callback(hObject, eventdata, handles)
% hObject    handle to calcROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global FV_img;
[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);
calcFVROI = FV_executeCalcROI(handles)
FV_img.(currentStructName).lastAnalysis.calcFVROI = calcFVROI;


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

% --- Executes on button press in batchAdd.
function batchAdd_Callback(hObject, eventdata, handles)
% hObject    handle to batchAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fname, pname] = uigetfile({'*.tif'}, 'MultiSelect', 'on');

if ischar(pname) %not cancel
    fname = cellstr(fname);
    for i = 1:length(fname)
        FV_addToCurrentGroup(handles, fullfile(pname, fname{i}));
    end
    FV_updateInfo(handles);
end



function spcRangeLow_Callback(hObject, eventdata, handles)
% hObject    handle to spcRangeLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spcRangeLow as text
%        str2double(get(hObject,'String')) returns contents of spcRangeLow as a double

FV_settingQuality(handles); % this combines former zStackQuality, intensityQuality and lifetimeQuality, and spcSetRange.
FV_calcMPETMap(handles);
FV_replot(handles, 'slow');%Note: put getCurrentImg into replot
    

% --- Executes during object creation, after setting all properties.
function spcRangeLow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spcRangeLow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function spcRangeHigh_Callback(hObject, eventdata, handles)
% hObject    handle to spcRangeHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spcRangeHigh as text
%        str2double(get(hObject,'String')) returns contents of spcRangeHigh as a double

FV_settingQuality(handles); % this combines former zStackQuality, intensityQuality and lifetimeQuality, and spcSetRange.
FV_calcMPETMap(handles);
FV_replot(handles, 'slow');%Note: put getCurrentImg into replot

% --- Executes during object creation, after setting all properties.
function spcRangeHigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spcRangeHigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in intensityImgOpt.
function intensityImgOpt_Callback(hObject, eventdata, handles)
% hObject    handle to intensityImgOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of intensityImgOpt

FV_updateStateVar(handles);
FV_replot(handles, 'slow');



function FV_openAnotherFile(handles, step)

fname = get(handles.currentFileName,'String');
[pname, fname] = h_analyzeFilename(fname);
if isempty(strfind(fname,'_max.tif'))
    number = str2num(fname(end-6:end-4));
    basename = fname(1:end-7);
    str1 = '000';
    str2 = num2str(number+step);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'.tif'];
else
    number = str2num(fname(end-10:end-8));
    basename = fname(1:end-11);
    str1 = '000';
    str2 = num2str(number+step);
    str1(end-length(str2)+1:end) = str2;
    fname = [basename,str1,'_max.tif'];
end
FV_openFile(handles, fullfile(pname, fname));



function LT0Input_Callback(hObject, eventdata, handles)
% hObject    handle to LT0Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LT0Input as text
%        str2double(get(hObject,'String')) returns contents of LT0Input as a double

FV_updateStateVar(handles);
FV_updateDispSettingVar(handles);
FV_replot(handles, 'slow');


% --- Executes during object creation, after setting all properties.
function LT0Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LT0Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in printT0Notes.
function printT0Notes_Callback(hObject, eventdata, handles)
% hObject    handle to printT0Notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = 'FV_parameterNotes.txt';
str = fileread(filename);
str2 = regexp(str, '\n', 'split');
fprintf('\n************ FLIM parameter notes (FV_parameterNotes.txt) ************\n');
for i = 1:length(str2)
    fprintf(str2{i});
end
fprintf('**************************** end of notes ****************************\n\n');


% --------------------------------------------------------------------
function saveSettings4_Callback(hObject, eventdata, handles)
% hObject    handle to saveSettings4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_saveSettings(handles, 4);


% --------------------------------------------------------------------
function saveSettings5_Callback(hObject, eventdata, handles)
% hObject    handle to saveSettings5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_saveSettings(handles, 5);


% --------------------------------------------------------------------
function saveSettings6_Callback(hObject, eventdata, handles)
% hObject    handle to saveSettings6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_saveSettings(handles, 6);


% --------------------------------------------------------------------
function loadSettings4_Callback(hObject, eventdata, handles)
% hObject    handle to loadSettings4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_loadSettings(handles, 4);
FV_replot(handles, 'slow');%Note: put getCurrentImg into replot


% --------------------------------------------------------------------
function loadSettings5_Callback(hObject, eventdata, handles)
% hObject    handle to loadSettings5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_loadSettings(handles, 5);
FV_replot(handles, 'slow');%Note: put getCurrentImg into replot


% --------------------------------------------------------------------
function loadSettings6_Callback(hObject, eventdata, handles)
% hObject    handle to loadSettings6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_loadSettings(handles, 6);
FV_replot(handles, 'slow');%Note: put getCurrentImg into replot
