function varargout = FV_saveSettingNotesGUI(varargin)
%
%   Syntax: FV_saveSettingNotesGUI(FV_Handles, settingNumber, exclusionList);
%   settingNumber default = 1
%
% FV_SAVESETTINGNOTESGUI MATLAB code for FV_saveSettingNotesGUI.fig
%      FV_SAVESETTINGNOTESGUI, by itself, creates a new FV_SAVESETTINGNOTESGUI or raises the existing
%      singleton*.
%
%      H = FV_SAVESETTINGNOTESGUI returns the handle to a new FV_SAVESETTINGNOTESGUI or the handle to
%      the existing singleton*.
%
%      FV_SAVESETTINGNOTESGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FV_SAVESETTINGNOTESGUI.M with the given input arguments.
%
%      FV_SAVESETTINGNOTESGUI('Property','Value',...) creates a new FV_SAVESETTINGNOTESGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FV_saveSettingNotesGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FV_saveSettingNotesGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FV_saveSettingNotesGUI

% Last Modified by GUIDE v2.5 24-Oct-2020 11:49:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FV_saveSettingNotesGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FV_saveSettingNotesGUI_OutputFcn, ...
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


% --- Executes just before FV_saveSettingNotesGUI is made visible.
function FV_saveSettingNotesGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FV_saveSettingNotesGUI (see VARARGIN)

% Choose default command line output for FV_saveSettingNotesGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global input

if length(varargin)<2 || isempty(varargin{2})
    varargin{2} = 1;
end

if length(varargin)<3 || isempty(varargin{3})
    varargin{3} = {};
end

input.FV_Handles = varargin{1};
input.settingNumber = varargin{2};
input.exclusionList = varargin{3};

% UIWAIT makes FV_saveSettingNotesGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FV_saveSettingNotesGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in saveNote.
function saveNote_Callback(hObject, eventdata, handles)
% hObject    handle to saveNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global FV_img input

[currentInd, FV_handles, currentStruct, currentStructName] = FV_getCurrendInst(input.FV_Handles);


str = get(handles.note, 'string');
if length(str)>100
    str = str(1:100); % only take the first 100 characters.
end

if input.settingNumber==1
    handleName = 'loadDefault';
    baseStr = 'Load Default';
else
    handleName = strcat('loadSettings',num2str(input.settingNumber));
    baseStr = strcat('Load Setting ',num2str(input.settingNumber)); 
end

if ~isempty(str)
    finalStr = strcat(baseStr,' (', str,')');
else
    finalStr = baseStr;
end

set(FV_handles.(handleName), 'label', finalStr)
currentStruct.state.(handleName).label = finalStr;

% save
pname = h_findFilePath('FLIMview.m');
fileName = fullfile(pname, 'FV_settings.mat');

if exist(fileName, 'file')
    temp = load(fileName); %this should load a variable called "settings".
    settings = temp.settings;
end

settings(input.settingNumber).state = currentStruct.state;
for i = 1:length(settings) % the menu names need to be updated for all settings.
    settings(i).state.(handleName).label = finalStr;
end

FV_img.(currentStructName).state = currentStruct.state;

% exclusionList = getExclusionList; % there are certain state settings should not be saved. Such as filenames.

settingNames = fieldnames(settings(input.settingNumber).state);
exclusionList = input.exclusionList(ismember(input.exclusionList, settingNames));%if not doing this way, there can be error if the field does not exist.
settings(input.settingNumber).state = rmfield(settings(input.settingNumber).state, exclusionList);

save(fileName, 'settings');

delete(handles.figure1);
clear global input


% --- Executes on button press in cancelNote.
function cancelNote_Callback(hObject, eventdata, handles)
% hObject    handle to cancelNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1);
clear global input


function note_Callback(hObject, eventdata, handles)
% hObject    handle to note (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of note as text
%        str2double(get(hObject,'String')) returns contents of note as a double


% --- Executes during object creation, after setting all properties.
function note_CreateFcn(hObject, eventdata, handles)
% hObject    handle to note (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
