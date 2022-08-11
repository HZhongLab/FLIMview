function varargout = FV_movieMakerGUI(varargin)
% FV_MOVIEMAKERGUI MATLAB code for FV_movieMakerGUI.fig
%      FV_MOVIEMAKERGUI, by itself, creates a new FV_MOVIEMAKERGUI or raises the existing
%      singleton*.
%
%      H = FV_MOVIEMAKERGUI returns the handle to a new FV_MOVIEMAKERGUI or the handle to
%      the existing singleton*.
%
%      FV_MOVIEMAKERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FV_MOVIEMAKERGUI.M with the given input arguments.
%
%      FV_MOVIEMAKERGUI('Property','Value',...) creates a new FV_MOVIEMAKERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FV_movieMakerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FV_movieMakerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FV_movieMakerGUI

% Last Modified by GUIDE v2.5 05-Apr-2018 19:18:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FV_movieMakerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FV_movieMakerGUI_OutputFcn, ...
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


% --- Executes just before FV_movieMakerGUI is made visible.
function FV_movieMakerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FV_movieMakerGUI (see VARARGIN)

% Choose default command line output for FV_movieMakerGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FV_movieMakerGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FV_movieMakerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in movieContentOpt.
function movieContentOpt_Callback(hObject, eventdata, handles)
% hObject    handle to movieContentOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns movieContentOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from movieContentOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function movieContentOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movieContentOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frameRate_Callback(hObject, eventdata, handles)
% hObject    handle to frameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameRate as text
%        str2double(get(hObject,'String')) returns contents of frameRate as a double

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frameRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in autoMakeMovie.
function autoMakeMovie_Callback(hObject, eventdata, handles)
% hObject    handle to autoMakeMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FV_autoMakeMovie(handles);


% --- Executes on selection change in ROIOpt.
function ROIOpt_Callback(hObject, eventdata, handles)
% hObject    handle to ROIOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ROIOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ROIOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ROIOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROIOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveMovie.
function saveMovie_Callback(hObject, eventdata, handles)
% hObject    handle to saveMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

if isfield(currentStruct.state, 'frameRate')
    frameRate = str2double(currentStruct.state.frameRate.string);
else
    frameRate = str2double(get(handles.frameRate, 'string'));
end

% save for future
[filename, pathname] = uiputfile('*.avi', 'Save Movie as');
obj = VideoWriter(fullfile(pathname, filename));
obj.FrameRate = frameRate;
open(obj);
writeVideo(obj, currentStruct.movie.mov);
close(obj);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in newMovie.
function newMovie_Callback(hObject, eventdata, handles)
% hObject    handle to newMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in imageOpt.
function imageOpt_Callback(hObject, eventdata, handles)
% hObject    handle to imageOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imageOpt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imageOpt

FV_genericSettingCallback(hObject, handles);


% --- Executes during object creation, after setting all properties.
function imageOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
