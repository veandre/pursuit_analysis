function varargout = all_in_one_tool(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @all_in_one_tool_OpeningFcn, ...
    'gui_OutputFcn',  @all_in_one_tool_OutputFcn, ...
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

function all_in_one_tool_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
beep off
addpath('C:\Users\leand\Desktop\chasing_2019\codes\dlt\DigitizingTools_20180828\DigitizingTools\dltdv')
addpath('C:\Users\leand\Desktop\chasing_2019\codes\ARBO_MATLAB\functions')
addpath('C:\Users\leand\Desktop\chasing_2019\codes\ARBO_MATLAB')

function varargout = all_in_one_tool_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function LOAD_button_Callback(hObject, eventdata, handles)
%chases_without_events;

function cut_vid_button_Callback(hObject, eventdata, handles)
couper_video;

function cut_yes_Callback(hObject, eventdata, handles)
set(handles.uibuttongroup5,'Visible','off')
set(handles.cut_vid_button,'Enable','off')

function cut_no_Callback(hObject, eventdata, handles)
set(handles.uibuttongroup5,'Visible','on')
set(handles.cut_vid_button,'Enable','on')

function frame_limit_button_Callback(hObject, eventdata, handles)
Crash_2019;
Crash_2019;
Crash_2019;

function SandSknown_yes_Callback(hObject, eventdata, handles)
set(handles.frame_limit_button,'Enable','off')
set(handles.cut_vid_button,'Enable','on')

function SandSknown_no_Callback(hObject, eventdata, handles)
set(handles.frame_limit_button,'Enable','on')
set(handles.cut_vid_button,'Enable','off')

function calib_DLTdv5_Callback(hObject, eventdata, handles)
DLTcal5;

function calib_yes_Callback(hObject, eventdata, handles)
set(handles.calib_DLTdv5,'Enable','off')

function calib_no_Callback(hObject, eventdata, handles)
set(handles.calib_DLTdv5,'Enable','on')

function DLTdv5_button_Callback(hObject, eventdata, handles)
DLTdv5;

function dlt_yes_Callback(hObject, eventdata, handles)
set(handles.DLTdv5_button,'Enable','off')
% set(handles.body_track_zone,'Visible','on')

function dlt_no_Callback(hObject, eventdata, handles)
set(handles.DLTdv5_button,'Enable','on')
% set(handles.body_track_zone,'Visible','off')


function unrot_button_Callback(hObject, eventdata, handles)
unrotate_CAM_2019;
function unrot_yes_Callback(hObject, eventdata, handles)
set(handles.unrot_button,'Enable','off')
function unrot_no_Callback(hObject, eventdata, handles)
set(handles.unrot_button,'Enable','on')


function body_track_button_Callback(hObject, eventdata, handles)
orientation_LandR
LV_DLT_RECONSTRUCT
DLTdv5

function body_tracked_yes_Callback(hObject, eventdata, handles)
set(handles.body_track_button,'Enable','off')
set(handles.uibuttongroup9,'Visible','on')

function body_tracked_no_Callback(hObject, eventdata, handles)
set(handles.body_track_button,'Enable','on')
set(handles.uibuttongroup9,'Visible','off')

function prep_button_Callback(hObject, eventdata, handles)
auto_chases_2019;

function BT_prep_yes_Callback(hObject, eventdata, handles)
% set(handles.body_track_button,'Enable','off')
set(handles.prep_button,'Enable','off')

function BT_prep_no_Callback(hObject, eventdata, handles)
% set(handles.body_track_button,'Enable','off')
set(handles.prep_button,'Enable','on')


function LOAD_Callback(hObject, eventdata, handles)
folder_name = uigetdir;
cd(folder_name)
% textLabel = sprintf('PURSUIT FOLDER folder_name = %f', folder_name);
A = exist('chases&orientations.mat','file');
if A == 2
    cd(folder_name)
    code_figures_angles2;
    code_figures_chase_orientations;
    
    
else
    %     B = exist('unrot.avi','file');
    %     if B == 2
    C = exist('mouche_xyzFilt.csv','file');
    if C == 2
        D = exist('DLTdv5_data_xyzFilt.csv','file');
        if D == 2
            set(handles.text2, 'String', 'DOIT ETRE CONTINUE');
            
        else
            set(handles.text2, 'String', 'ATTENTIOTN FLY AND TARGET HAVE NOT BEEN TRACKED, PLEASE USE DLTdv5');
            set(handles.dlt_no,'Value',1)
            set(handles.DLTdv5_button,'Enable','on')
        end
    else
        set(handles.text2, 'String', 'ATTENTIOTN THE BODY TRACKINK HAS NOT BEEN EFFECTUATED');
        set(handles.body_tracked_no,'Value',1)
        set(handles.body_track_button,'Enable','on')
    end
    %     else
    %         set(handles.text2, 'String', 'ATTENTIOTN UNROT THE CAMERA MOVIE HAS NOT BEEN EFFECTUATED');
    %         set(handles.unrot_no,'Value',1)
    %         set(handles.unrot_button,'Enable','on')
    %     end
    
end
% set(handles.text2, 'String', folder_name);
