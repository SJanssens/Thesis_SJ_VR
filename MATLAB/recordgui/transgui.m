function varargout = transgui(varargin)
% TRANSGUI M-file for transgui.fig
%      TRANSGUI, by itself, creates a new TRANSGUI or raises the existing
%      singleton*.
%
%      H = TRANSGUI returns the handle to a new TRANSGUI or the handle to
%      the existing singleton*.
%
%      TRANSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRANSGUI.M with the given input arguments.
%
%      TRANSGUI('Property','Value',...) creates a new TRANSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before transgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to transgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help transgui

% Last Modified by GUIDE v2.5 09-Oct-2013 16:32:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @transgui_OpeningFcn, ...
                   'gui_OutputFcn',  @transgui_OutputFcn, ...
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


% --- Executes just before transgui is made visible.
function transgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to transgui (see VARARGIN)

% Choose default command line output for transgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes transgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = transgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function transcription_Callback(hObject, eventdata, handles)
% hObject    handle to transcription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of transcription as text
%        str2double(get(hObject,'String')) returns contents of transcription as a double


% --- Executes during object creation, after setting all properties.
function transcription_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transcription (see GCBO)
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
transcription = get(handles.transcription, 'String');
save 'transcription' transcription

close transgui
