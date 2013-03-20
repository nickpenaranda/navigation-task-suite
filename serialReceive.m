function serialReceive(obj, event)
% serialReceive( obj, event )
%
% (Part of the Navigation Task Suite package)
% Serial interface callback function.  This function defines the imperative
% commands that the navigation task suite can respond to.  See
% ExpListener.m for serial port setup defaults
%
% (c) 2013 Nick Penaranda, GMU Arch Lab (ARG -- Dr. Carryl Baldwin)
    global exp;
    persistent mode cmdbuffer;
    
    CMD = 1;
    DATA = 2;
    
    if(isempty(mode))
        mode = CMD;
    end
    
    if(isempty(cmdbuffer))
        cmdbuffer = '';
    end
    
    if(mode == CMD) 
        cmd = fscanf(obj, '%s\n');
        if(strcmp(cmd,'STRT'))
            disp('STRT received');
            logEvent('SerialReceive,START');
        elseif(strcmp(cmd,'WARN'))
            disp('WARN received');
            exp.triggerAlert = true;
            logEvent('AlertTriggered');
        elseif(strcmp(cmd,'RESP'))
            disp('RESP received');
            exp.alertResponded = true;
            logEvent('AlertResponse');
        elseif(strcmp(cmd,'RING'))
            disp('RING received');
            cmdbuffer = 'RING';
            mode = DATA;
        elseif(strcmp(cmd,'PREP'))
            disp('PREP received');
            cmdbuffer = 'PREP';
            mode = DATA;
        else
            disp(['UNKNOWN received (' cmd ')']);
        end
    elseif(mode == DATA)
        data = fscanf(obj, '%s\n');
        flushinput(obj);
        if(strcmp(cmdbuffer,'RING'))
            schedulePhoneRing(str2double(data))
        elseif(strcmp(cmdbuffer,'PREP'))
            prepareAlert(str2double(data));
        end
        mode = CMD;
    end
end