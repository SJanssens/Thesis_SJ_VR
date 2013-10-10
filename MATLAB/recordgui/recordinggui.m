function varargout = recordinggui(varargin)
% RECORDINGGUI M-file for recordinggui.fig
%      RECORDINGGUI, by itself, creates a new RECORDINGGUI or raises the existing
%      singleton*.
%
%      H = RECORDINGGUI returns the handle to a new RECORDINGGUI or the handle to
%      the existing singleton*.
%
%      RECORDINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECORDINGGUI.M with the given input arguments.
%
%      RECORDINGGUI('Property','Value',...) creates a new RECORDINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before recordinggui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to recordinggui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help recordinggui

% Last Modified by GUIDE v2.5 09-Oct-2013 16:00:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @recordinggui_OpeningFcn, ...
                   'gui_OutputFcn',  @recordinggui_OutputFcn, ...
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


% --- Executes just before recordinggui is made visible.
function recordinggui_OpeningFcn(hObject, eventdata, handles, varargin)

global inputlist_moverel_direction;
global inputlist_moverel_distance;
global inputlist_moveabs_location;
global inputlist_movetoobj_object;
global inputlist_movetime_direction;
global inputlist_movetime_duration;
global inputlist_turnabs_direction;
global inputlist_turnrel_angle;
global inputlist_turnrel_direction;
global inputlist_turntime_direction;
global inputlist_turntime_duration;
global inputlist_grabobj_object;
global inputlist_moveobj_object;
global inputlist_moveobj_location;
global opnamenummer;
global actionnumber;
global actionlist;
global active_action;
global recording;
global recorder;
global audiodir;
global actiondir;
global transdir;
global actionformat;
global Fs;
global nbits;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recordinggui (see VARARGIN)

% Choose default command line output for recordinggui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes recordinggui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%opname nummer laden
load opnamenummer;
load persoonnummer;

%sampling frequency
Fs = 8000;

%number of bits per sample
nbits = 8;

%masterframe
inputlist_moverel_direction = ['f '; 'dr'; 'r '; 'b '; 'l '; 'dl'];
inputlist_moverel_distance = ['5  '; '10 '; '25 '; '50 '; '100'];
inputlist_moveabs_location = ['N '; 'NE'; 'E '; 'SE'; 'S '; 'SW'; 'W '; 'NW'; 'C '];
inputlist_movetoobj_object = ['can '; 'ball'];
inputlist_movetime_direction = ['f'; 'b'];
inputlist_movetime_duration = ['1  '; '2  '; '5  '; '10 '; 'inf'];
inputlist_turnabs_direction = ['N '; 'NE'; 'E '; 'SE'; 'S '; 'SW'; 'W '; 'NW'];
inputlist_turnrel_angle = ['45 '; '90 '; '180'];
inputlist_turnrel_direction = ['l'; 'r'];
inputlist_turntime_direction = ['l'; 'r'];
inputlist_turntime_duration = ['1  '; '2  '; '5  '; '10 '; 'inf'];
inputlist_grabobj_object = ['can '; 'ball'];
inputlist_moveobj_object = ['can '; 'ball'];
inputlist_moveobj_location = ['N '; 'NE'; 'E '; 'SE'; 'S '; 'SW'; 'W '; 'NW'; 'C '];
%gui
actionlist = ['move_rel   '; 'move_abs   '; 'move_to_obj'; 'move_time  '; 'turn_abs   '; 'turn_rel   '; 'turn_time  '; 'grab       '; 'release    '; 'grab_obj   '; 'move_obj   '; 'stop       '];
active_action = 'move_rel';
recording = 0;
actionnumber = 1;

set(handles.inputlist1, 'String', inputlist_moverel_direction);
set(handles.inputlist2, 'String', inputlist_moverel_distance);
set(handles.recording, 'String', 'not recording');
set(handles.action_select, 'String', actionlist);
set(handles.recnr,'String',num2str(actionnumber));

%recording
recorder = audiorecorder(Fs, nbits,1);

%make the directories
audiodir = ['data/spchdatadir/pp',num2str(persoonnummer), '/opname', num2str(opnamenummer)];
actiondir = ['data/actiondir/pp',num2str(persoonnummer), '/opname', num2str(opnamenummer)];
transdir = ['data/transcriptiondir/pp',num2str(persoonnummer), '/opname', num2str(opnamenummer)];
mkdir(audiodir);
mkdir(actiondir);
mkdir(transdir);

%format in wich to save the actiondescription input: (date, time,
%actionnumber, action, input1, input2
actionformat = '<?xml version="1.0" ?>\n<framedesc>\n<info>\n<date>\n%s\n</date>\n<time>\n%s\n</time>\n<move>\n%s\n</move>\n</info>\n<thisframe>\n%s\n</thisframe>\n<data>\n<input1>\n%s\n</input1>\n<input2>\n%s\n</input2>\n</data>\n</framedesc>';


% --- Outputs from this function are returned to the command line.
function varargout = recordinggui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on selection change in inputlist1.
function inputlist1_Callback(hObject, eventdata, handles)
% hObject    handle to inputlist1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns inputlist1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inputlist1


% --- Executes during object creation, after setting all properties.
function inputlist1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputlist1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in inputlist2.
function inputlist2_Callback(hObject, eventdata, handles)
% hObject    handle to inputlist2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns inputlist2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inputlist2


% --- Executes during object creation, after setting all properties.
function inputlist2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputlist2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in recording.
function recording_Callback(hObject, eventdata, handles)
% hObject    handle to recording (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of recording
global active_action;
global recording;
global recorder;
global actionnumber;
global audiodir;
global actiondir;
global transdir;
global actionformat;
global Fs;
global nbits;

recording = get(handles.recording,'value');

switch recording
    case 0 %recording is dissabled
        % enble the inputlists
        set(handles.recording, 'String', 'not recording')
        set(handles.recording, 'ForeGroundColor', [0,0,0])
        set(handles.action_select, 'Enable', 'on');
        set(handles.inputlist1, 'Enable', 'on');
        set(handles.inputlist2, 'Enable', 'on');
        
        % stop the recording and retrieve the data
        stop(recorder);
        audio = getaudiodata(recorder);
        
        % save the audio data
        filename_audio = [audiodir,'/actie', num2str(actionnumber), '.wav'];
        wavwrite(audio, Fs, nbits, filename_audio);
        
        % create and save the action data
        filename_action = [actiondir,'/actie', num2str(actionnumber), '.xml'];
        inputlist1 = get(handles.inputlist1, 'String');
        inputlist2 = get(handles.inputlist2, 'String');
        input1 = inputlist1(get(handles.inputlist1, 'Value'),:);
        input2 = inputlist2(get(handles.inputlist2, 'Value'),:);
        fileId = fopen(filename_action, 'w');
        fprintf(fileId, actionformat, datestr(now,'YYYY_mm_DD'), datestr(now,'HH_MM_SS'), num2str(actionnumber), active_action, input1, input2);
        fclose(fileId);
        
        %save the transcription data
        filename_trans = [transdir,'/actie', num2str(actionnumber), '.txt'];
        fileId = fopen(filename_trans, 'w');
        if get(handles.transcription,'Value') == 1
            transgui;
            uiwait(transgui)
            load transcription;
            fprintf(fileId, '%s', transcription);
        end        
        fclose(fileId);
        
        actionnumber = actionnumber + 1;
        set(handles.recnr,'String',num2str(actionnumber));
        
    case 1 %recording enabled
        set(handles.recording, 'String', 'recording')
        set(handles.recording, 'ForeGroundColor', [1,0,0])
        set(handles.action_select, 'Enable', 'off');
        set(handles.inputlist1, 'Enable', 'off');
        set(handles.inputlist2, 'Enable', 'off');
        
        record(recorder);
end


% --- Executes on selection change in action_select.
function action_select_Callback(hObject, eventdata, handles)
% hObject    handle to action_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns action_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from action_select
global inputlist_moverel_direction;
global inputlist_moverel_distance;
global inputlist_moveabs_location;
global inputlist_movetoobj_object;
global inputlist_movetime_direction;
global inputlist_movetime_duration;
global inputlist_turnabs_direction;
global inputlist_turnrel_angle;
global inputlist_turnrel_direction;
global inputlist_turntime_direction;
global inputlist_turntime_duration;
global inputlist_grabobj_object;
global inputlist_moveobj_object;
global inputlist_moveobj_location;
global actionlist;
global active_action;

active_action = actionlist(get(handles.action_select, 'Value'),:);
set(handles.inputlist1, 'Value', 1);
set(handles.inputlist2, 'Value', 1);

switch active_action
    case 'move_rel   '
        set(handles.inputlist1, 'String', inputlist_moverel_direction);
        set(handles.inputlist2, 'String', inputlist_moverel_distance);
    case 'move_abs   '
        set(handles.inputlist1, 'String', inputlist_moveabs_location);
        set(handles.inputlist2, 'String', ' ');
    case 'move_to_obj'
        set(handles.inputlist1, 'String', inputlist_movetoobj_object);
        set(handles.inputlist2, 'String', ' ');
    case 'move_time  '
        set(handles.inputlist1, 'String', inputlist_movetime_direction);
        set(handles.inputlist2, 'String', inputlist_movetime_duration);
    case 'turn_abs   '
        set(handles.inputlist1, 'String', inputlist_turnabs_direction);
        set(handles.inputlist2, 'String', ' ');
    case 'turn_rel   '
        set(handles.inputlist1, 'String', inputlist_turnrel_direction);
        set(handles.inputlist2, 'String', inputlist_turnrel_angle);
    case 'turn_time  '
        set(handles.inputlist1, 'String', inputlist_turntime_direction);
        set(handles.inputlist2, 'String', inputlist_turntime_duration);
    case 'grab       '
        set(handles.inputlist1, 'String', ' ');
        set(handles.inputlist2, 'String', ' ');
    case 'release    '
        set(handles.inputlist1, 'String', ' ');
        set(handles.inputlist2, 'String', ' ');
    case 'grab_obj   '
        set(handles.inputlist1, 'String', inputlist_grabobj_object);
        set(handles.inputlist2, 'String', ' ');
    case 'move_obj   '
        set(handles.inputlist1, 'String', inputlist_moveobj_object);
        set(handles.inputlist2, 'String', inputlist_moveobj_location);
    case 'stop       '
        set(handles.inputlist1, 'String', ' ');
        set(handles.inputlist2, 'String', ' ');
end


% --- Executes during object creation, after setting all properties.
function action_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to action_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in new.
function new_Callback(hObject, eventdata, handles)
% hObject    handle to new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all

startgui;


% --- Executes on button press in delete.
function delete_Callback(hObject, eventdata, handles)
% hObject    handle to delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global actionnumber;
global audiodir;
global actiondir;
global transdir;

actionnumber = actionnumber - 1;

%delete the files
delete([audiodir, '/actie', num2str(actionnumber), '.wav']);
delete([actiondir, '/actie', num2str(actionnumber), '.xml']);
delete([transdir, '/actie', num2str(actionnumber), '.txt']);

set(handles.recnr,'String',num2str(actionnumber));





% --- Executes on button press in transcription.
function transcription_Callback(hObject, eventdata, handles)
% hObject    handle to transcription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of transcription
