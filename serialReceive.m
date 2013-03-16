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
        elseif(strcmp(cmd,'WARN'))
            disp('WARN received');
        elseif(strcmp(cmd,'RESP'))
            disp('RESP received');
        elseif(strcmp(cmd,'DATA')) % Generic data
            disp('DATA received');
            mode = LENGTH;
        else
            disp(['UNKNOWN received (' cmd ')']);
        end 
    elseif(mode == LENGTH)
        datalen = fscanf(obj, '%d\n');
        disp(['Expecting ' num2str(datalen) ' bytes']);
        mode = DATA;
    elseif(mode == DATA)
        exp.serialdata = fread(obj,datalen);
        flushinput(obj);
        disp('Received:');
        disp(exp.serialdata);
        mode = CMD;
    end
end