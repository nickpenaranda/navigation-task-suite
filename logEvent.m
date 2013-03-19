function logEvent( entry )
    global exp;
    
    if(exp.logFile == -1)
        % Init logfile
        logName = sprintf('data\\Log_%s_%s.csv', ...
            exp.ParticipantNumber, ...
            datestr(now,'yy.mm.dd_HH.MM.SS'));
        exp.logFile = fopen(logName,'at');
        fprintf(exp.logFile,'time (s),message type,data1,data2,data3,data4,data5,data6,data7,data8\n');
    end

    record = sprintf('%f,%s\n',GetSecs() - exp.startTime,entry);
    if(exp.logFile == -1)
        disp('Warning: No active log file. Could not write event:');
        disp(['  ' record]);
    else
        fprintf(exp.logFile, record);
    end
end

