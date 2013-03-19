function varargout = ExpListener(varargin)
% EXPLISTENER M-file for ExpListener.fig
%      EXPLISTENER, by itself, creates a new EXPLISTENER or raises the existing
%      singleton*.
%
%      H = EXPLISTENER returns the handle to a new EXPLISTENER or the handle to
%      the existing singleton*.
%
%      EXPLISTENER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPLISTENER.M with the given input arguments.
%
%      EXPLISTENER('Property','Value',...) creates a new EXPLISTENER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ExpListener_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ExpListener_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ExpListener

% Last Modified by GUIDE v2.5 03-Mar-2013 21:20:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ExpListener_OpeningFcn, ...
                   'gui_OutputFcn',  @ExpListener_OutputFcn, ...
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

function ExpListener_OpeningFcn(hObject, eventdata, handles, varargin)
    global exp;
    
    % ---------- Program parameters ----------
    exp.DEBUG = true;
    PORT = 'COM2';
    exp.SCREEN_NUM = 1;
    % ---------- Program parameters ----------
    
    % Global state stuff (exp.state)
    exp.STANDBY = 0;
    exp.NAV = 1;
    exp.PHONE = 2;
    exp.ALARM = 3;
    exp.STOP = 4;
    
    % Serial port init stuff
    exp.serial = serial(PORT);
    set(exp.serial,'BytesAvailableFcnMode','terminator');
    set(exp.serial,'BytesAvailableFcn',@serialReceive);
    
    % Audio stuff
    InitializePsychSound;
    exp.audio = PsychPortAudio('Open',[],[],[],44100,2);
    
    exp.ringTone = wavread('ringtone.wav','double')';
    exp.click = wavread('blip_click.wav','double')';

    PsychPortAudio('FillBuffer',exp.audio,exp.ringTone);

    exp.ParticipantNumber = '0';
    exp.logFile = -1;
    exp.startTime = GetSecs();
    
    exp.ringAt = GetSecs();
    exp.ringScheduled = false;
    exp.ringDismiss = false;
    exp.phoneRinging = false;
    
    handles.output = hObject;
    guidata(hObject, handles);

function varargout = ExpListener_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

function checkListen_Callback(hObject, eventdata, handles)
    global exp;
    state = get(hObject,'Value') == 1;
    if(state) % Listening turned on
        disp(['Opening ' get(exp.serial,'Port') '...']);
        fopen(exp.serial);
    else
        disp(['Closing ' get(exp.serial,'Port') '...']);
        fclose(exp.serial);
    end
    
function btnStartTask_Callback(hObject, eventdata, handles)
    global exp;

    fprintf(exp.logFile,'time (s),message type,data1,data2,data3,data4,data5,data6,data7,data8\n');
    
    exp.state = exp.STANDBY;
    exp.stateExpireTime = GetSecs();
    expRedraw();
    
    schedulePhoneRing(5);
    % Run the task front-end
    NavSuite();
    
function editParticipantNum_Callback(hObject, eventdata, handles)
    global exp;
    exp.participantNumber = get(hObject,'String');
    
function editParticipantNum_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function btnDebug_Callback(hObject, eventdata, handles)
    global exp;
    keyboard;


function figure1_CloseRequestFcn(hObject, eventdata, handles)
    global exp;
    exp.state = exp.STOP;
    fclose(exp.serial);
    if(exp.logFile ~= -1)
        fclose(exp.logFile);
    end
    PsychPortAudio('Close');
    % Hint: delete(hObject) closes the figure
    delete(hObject);
