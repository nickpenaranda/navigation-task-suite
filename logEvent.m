function logEvent( entry )
    global exp;
    
    record = sprintf('%f,%s\n',GetSecs() - exp.startTime,entry);
    if(exp.logFile == -1)
        disp('Warning: No active log file. Could not write event:');
        disp(['  ' record]);
    else
        fprintf(exp.logFile, record);
    end
end

