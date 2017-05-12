function varargout = Phi_view(varargin)
% PHI_VIEW MATLAB code for Phi_view.fig
%      Usage: Phi_view(fe, Phi)
%      PHI_VIEW, by itself, creates a new PHI_VIEW or raises the existing
%      singleton*.
%
%      H = PHI_VIEW returns the handle to a new PHI_VIEW or the handle to
%      the existing singleton*.
%
%      PHI_VIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHI_VIEW.M with the given input arguments.
%
%      PHI_VIEW('Property','Value',...) creates a new PHI_VIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Phi_view_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Phi_view_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Phi_view

% Last Modified by GUIDE v2.5 11-Nov-2016 18:38:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Phi_view_OpeningFcn, ...
                   'gui_OutputFcn',  @Phi_view_OutputFcn, ...
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

% --- Executes just before Phi_view is made visible.
function Phi_view_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Phi_view (see VARARGIN)

% Choose default command line output for Phi_view
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

addpath ../code/tensor_toolbox
addpath ../data/
varargout{1} = handles.output;


% load ../data/subsets/Phi_all_500_1.mat
% load ../data/fe_struct_with_predicted_signal_from_Arcuate_FP_PROB_lmax10_connNUM01.mat
fe = varargin{1};
Phi_sp = varargin{2};
Phi_sp2 = varargin{3};
Nf = size(Phi_sp, 3);

data.fe = fe;
data.Phi_sp = Phi_sp;
data.Phi_sp2 = Phi_sp2;

% Object settings
slider1 = handles.slider1;
slider1.Min = 1;
slider1.Max = Nf;
slider1.SliderStep = [1, 10] / slider1.Max;

slider2 = handles.slider2;
slider2.Min = 1;
slider2.Max = Nf;
slider2.SliderStep = [1, 10] / slider2.Max;

startf = slider1.Value;
numf = slider2.Value;

data.startf = startf;
data.numf = numf;

text2 = handles.text2;
text2.String = ['Start index of fascicles: ', int2str(startf)];
text3 = handles.text3;
text3.String = ['Display number of fascicles: ', int2str(numf)];

Phi1 = Phi_sp(:,:,:);
Phi2 = Phi_sp2(:,:,:);

% pars.n = 697;
pars.f = startf : startf+numf-1;
pars.axes = handles.axes1;
visualize_Phi_len(fe,Phi1,pars);
pars.axes = handles.axes2;
visualize_Phi_len(fe,Phi2,pars);

% UIWAIT makes Phi_view wait for user response (see UIRESUME)
% uiwait(handles.figure1);

handles.privdata = data;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Phi_view_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% varargout{1} = hObject;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

data = handles.privdata;

slider1 = hObject;
startf = round(slider1.Value);
data.startf = startf;

numf = data.numf;

text2 = handles.text2;
text2.String = ['Start index of fascicles: ', int2str(startf)];
% text3 = handles.text3;
% text3.String = ['Display number of fascicles: ', int2str(numf)];
cla(handles.axes1);
cla(handles.axes2);
fe = data.fe;
Phi_sp = data.Phi_sp;
Phi1 = Phi_sp;
Phi_sp2 = data.Phi_sp2;
Phi2 = Phi_sp2;
pars.f = startf : startf+numf-1;
pars.axes = handles.axes1;
visualize_Phi_len(fe,Phi1,pars);
pars.axes = handles.axes2;
visualize_Phi_len(fe,Phi2,pars);

handles.privdata = data;
guidata(hObject, handles);



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

data = handles.privdata;

slider2 = hObject;
numf = round(slider2.Value);
data.numf = numf;

startf = data.startf;

text3 = handles.text3;
text3.String = ['Display number of fascicles: ', int2str(numf)];
% text3 = handles.text3;
% text3.String = ['Display number of fascicles: ', int2str(numf)];
cla(handles.axes1);
cla(handles.axes2);
fe = data.fe;
Phi_sp = data.Phi_sp;
Phi1 = Phi_sp;
Phi_sp2 = data.Phi_sp2;
Phi2 = Phi_sp2;
pars.f = startf : startf+numf-1;
pars.axes = handles.axes1;
visualize_Phi_len(fe,Phi1,pars);
pars.axes = handles.axes2;
visualize_Phi_len(fe,Phi2,pars);

handles.privdata = data;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
