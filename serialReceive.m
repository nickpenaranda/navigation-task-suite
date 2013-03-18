function serialReceive(obj, event)
    global exp;
    persistent mode datalen;
    
    CMD = 1;
    LENGTH = 2;
    DATA = 3;
    
    if(isempty(mode))
        mode = CMD;
    end
    
    if(mode == CMD) 
        cmd = fscanf(obj, '%s\n');
        if(strcmp(cmd,'STRT'))
            disp('STRT received');
            logEvent('SerialReceive,START');
        elseif(strcmp(cmd,'WARN'))
            disp('WARN received');
            logEvent('SerialReceive,WARNING');
        elseif(strcmp(cmd,'RESP'))
            disp('RESP received');
            logEvent('SerialReceive,RESPONSE');
        elseif(strcmp(cmd,'RING'))
            disp('RING received');
            logEvent('SerialReceive,SCHEDULE_RING');
            schedulePhoneRing(rand() * 5);
        elseif(strcmp(cmd,'DATA')) % Generic data
            disp('DATA received');
            logEvent('SerialReceive,DATA_INIT');
            mode = LENGTH;
        else
            disp(['UNKNOWN received (' cmd ')']);
        end 
    elseif(mode == LENGTH)
        datalen = fscanf(obj, '%d\n');
        disp(['Expecting ' num2str(datalen) ' bytes']);
        mode = DATA;
        logEvent(['SerialReceive,DATA_LENGTH,' num2str(datalen)]);
    elseif(mode == DATA)
        exp.serialdata = fread(obj,datalen);
        flushinput(obj);
        disp('Received:');
        disp(exp.serialdata);
        mode = CMD;
        logEvent(['SerialReceive,DATA_RECEIVED,' num2str(datalen)]);
    end
end