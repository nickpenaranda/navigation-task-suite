function doPhone()
    global exp;
    
    if(exp.redraw)
        %disp('Rendering phone screen!');
        if(exp.phoneRinging)
            DrawFormattedText(exp.scr, 'Call dismissed', 'center', 'center');
            exp.phoneRinging = false;
            logEvent('PhoneRingDismissed,Hit');
        else
            DrawFormattedText(exp.scr, 'There is no call to dismiss.', 'center', 'center');
            logEvent('PhoneRingDismissed,FalseAlarm');
        end
        Screen('Flip', exp.scr);
        clearRedraw();
    end
    
    if(GetSecs() > exp.stateExpireTime)
        exp.state = exp.STANDBY;
        expRedraw();
        logEvent('ReturnToStandby');
    end
end