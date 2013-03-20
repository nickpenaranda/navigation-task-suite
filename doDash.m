function doDash()
% doDash()
%
% (Part of the Navigation Task Suite package)
% Alarm subscreen?  This will be refactored in future versions.
%
% (c) 2013 Nick Penaranda, GMU Arch Lab (ARG -- Dr. Carryl Baldwin)
    global exp;
    
    % Process alert requests
    if(exp.triggerAlert)
        PsychPortAudio('Start',exp.alertSlave);
        exp.dashTex = exp.alertTex;
        exp.redrawDash = true;
        exp.triggerAlert = false;
        logEvent('AlertOnset');
    elseif(exp.alertResponded)
        PsychPortAudio('Stop',exp.alertSlave);
        exp.dashTex = exp.blankTex;
        exp.redrawDash = true;
        exp.alertResponded = false;
        logEvent('AlertDismissed');
    end
    if(exp.redrawDash)
        Screen('DrawTexture',exp.dashScr,exp.dashTex);
        Screen('Flip', exp.dashScr);
        exp.redrawDash = false;
    end
end