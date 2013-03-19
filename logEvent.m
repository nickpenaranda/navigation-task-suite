function logEvent( entry )
    global exp;
    
    if(exp.logFile == -1)
        % Init logfile
        logName = sprintf('data\\Log_%s_%s.csv', ...
            exp.ParticipantNumber, ...
            datestr(now,'yy.mm.dd_HH.MM.SS'));
        exp.logFile = fopen(logName,'at');
    end

    record = sprintf('%f,%s\n',GetSecs() - exp.startTime,entry);
    if(exp.logFile == -1)
        disp('Warning: No active log file. Could not write event:');
        disp(['  ' record]);
    else
        fprintf(exp.logFile, record);
    end
end

