function varargout = project_gui(varargin)
%PROJECT_GUI M-file for project_gui.fig
%      PROJECT_GUI, by itself, creates a new PROJECT_GUI or raises the existing
%      singleton*.
%
%      H = PROJECT_GUI returns the handle to a new PROJECT_GUI or the handle to
%      the existing singleton*.
%
%      PROJECT_GUI('Property','Value',...) creates a new PROJECT_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to project_gui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      PROJECT_GUI('CALLBACK') and PROJECT_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in PROJECT_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project_gui

% Last Modified by GUIDE v2.5 30-Jul-2015 20:03:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @project_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before project_gui is made visible.
function project_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for project_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in training_algo.
function training_algo_Callback(hObject, eventdata, handles)
% hObject    handle to training_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns training_algo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from training_algo


% --- Executes during object creation, after setting all properties.
function training_algo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to training_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in scheduling_algo.
function scheduling_algo_Callback(hObject, eventdata, handles)
% hObject    handle to scheduling_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns scheduling_algo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from scheduling_algo


% --- Executes during object creation, after setting all properties.
function scheduling_algo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scheduling_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function mass_Callback(hObject, eventdata, handles)
% hObject    handle to mass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mass as text
%        str2double(get(hObject,'String')) returns contents of mass as a double


% --- Executes during object creation, after setting all properties.
function mass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_activities_Callback(hObject, eventdata, handles)
% hObject    handle to num_activities (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_activities as text
%        str2double(get(hObject,'String')) returns contents of num_activities as a double


% --- Executes during object creation, after setting all properties.
function num_activities_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_activities (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pcn_short_Callback(hObject, eventdata, handles)
% hObject    handle to pcn_short (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pcn_short as text
%        str2double(get(hObject,'String')) returns contents of pcn_short as a double


% --- Executes during object creation, after setting all properties.
function pcn_short_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pcn_short (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pcn_medium_Callback(hObject, eventdata, handles)
% hObject    handle to pcn_medium (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pcn_medium as text
%        str2double(get(hObject,'String')) returns contents of pcn_medium as a double


% --- Executes during object creation, after setting all properties.
function pcn_medium_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pcn_medium (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pcn_long_Callback(hObject, eventdata, handles)
% hObject    handle to pcn_long (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pcn_long as text
%        str2double(get(hObject,'String')) returns contents of pcn_long as a double


% --- Executes during object creation, after setting all properties.
function pcn_long_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pcn_long (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_Callback(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height as text
%        str2double(get(hObject,'String')) returns contents of height as a double


% --- Executes during object creation, after setting all properties.
function height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_distance_Callback(hObject, eventdata, handles)
% hObject    handle to max_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_distance as text
%        str2double(get(hObject,'String')) returns contents of max_distance as a double


% --- Executes during object creation, after setting all properties.
function max_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_climb_Callback(hObject, eventdata, handles)
% hObject    handle to max_climb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_climb as text
%        str2double(get(hObject,'String')) returns contents of max_climb as a double


% --- Executes during object creation, after setting all properties.
function max_climb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_climb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fitness_level_Callback(hObject, eventdata, handles)
% hObject    handle to fitness_level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fitness_level as text
%        str2double(get(hObject,'String')) returns contents of fitness_level as a double


% --- Executes during object creation, after setting all properties.
function fitness_level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fitness_level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
