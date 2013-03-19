function doPhone()
% doPhone()
%
% (Part of the Navigation Task Suite package)
% Incoming phone call dismissal subscreen
%
% Provides feedback when user elects to dismiss a call
%
% (c) 2013 Nick Penaranda, GMU Arch Lab (ARG -- Dr. Carryl Baldwin)
    global exp;
    
    if(exp.redraw)
        %disp('Rendering phone screen!');
        if(exp.phoneRinging)
            DrawFormattedText(exp.scr, 'Call dismissed', 'center', 'center');
            exp.phoneRinging = false;
            logEvent('PhoneRingDismissed,Hit');
        else
            DrawFormattedText(exp.scr, 'No call to dismiss', 'center', 'center');
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