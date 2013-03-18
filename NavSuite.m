function results = NavSuite()
    global exp;
    results = {};
    
    maxTPS = 100;
    loopDelay = 1 / maxTPS;
    lastLoop = GetSecs();
    
    Screen('Preference', 'SuppressAllWarnings', true);

    % PTB init stuff
    AssertOpenGL;
    if(exp.DEBUG)
        [exp.scr,exp.scrRect] = Screen('OpenWindow',exp.SCREEN_NUM,[0, 0, 0],[32 32 800 480]);
    else
        [exp.scr,exp.scrRect] = Screen('OpenWindow',exp.SCREEN_NUM,[0, 0, 0],[]);
    end
    
    Screen('TextFont',exp.scr,'Arial');

    if(exp.DEBUG)
        ShowCursor('Hand',0);
    else
        HideCursor(exp.scr);
    end
    
    [exp.mx, exp.my] = RectCenter(exp.scrRect);
    
    % Load alarm/task data

    % One-time position calculations
    
    areaPadding = 32;
    exp.areaPadding = areaPadding;

    % Standby mode
    
    exp.phoneColor = [93 138 102];
    exp.phoneText = 'Dismiss Call';
    exp.phoneRect = [areaPadding, areaPadding, ...
        exp.mx - areaPadding, ...
        exp.scrRect(4) - areaPadding];
    phoneTextRect = Screen('TextBounds', exp.scr, exp.phoneText);
    phoneTextSize = [phoneTextRect(3) phoneTextRect(4)];
    exp.phoneTextCoords = [exp.mx / 2 - (phoneTextSize(1) / 2), exp.my - (phoneTextSize(2) / 2)];

    exp.navColor = [33 68 91];
    exp.navText = 'Navigation';
    exp.navRect = [exp.mx + areaPadding, areaPadding, ...
        exp.scrRect(3) - areaPadding, ...
        exp.scrRect(4) - areaPadding];
    navTextRect = Screen('TextBounds', exp.scr, exp.navText);
    navTextSize = [navTextRect(3) navTextRect(4)];
    exp.navTextCoords = [exp.mx + (exp.mx / 2 - (navTextSize(1) / 2)), exp.my - (navTextSize(2) / 2)];
    
    stopSize = 24;
    exp.stopRect = [exp.scrRect(3) - stopSize, exp.scrRect(4) - stopSize, ...
                    exp.scrRect(3), exp.scrRect(4)];
    
    exp.navButtonColor = [172 186 191];
    exp.navBackButtonRect = [ ...
        exp.scrRect(3) - areaPadding - 128, ...
        areaPadding, ...
        exp.scrRect(3) - areaPadding, ...
        areaPadding + 48];
    exp.navBackButtonText = 'Back';
    
    exp.symButtonWidth = exp.scrRect(4) / 4;
    exp.symButtonHeight = 48;
    
    exp.navButtonSym1Color = [120 158 204];
    exp.navButtonSym1Rect = [ ...
        exp.mx - (exp.symButtonWidth * 1.5) - areaPadding, ...
        exp.scrRect(4) - areaPadding - exp.symButtonHeight, ...
        exp.mx - (exp.symButtonWidth * 0.5) - areaPadding, ...
        exp.scrRect(4) - areaPadding];

    exp.navButtonSym2Color = [178 111 105];
    exp.navButtonSym2Rect = [ ...
        exp.mx - (exp.symButtonWidth * 0.5), ...
        exp.scrRect(4) - areaPadding - exp.symButtonHeight, ...
        exp.mx + (exp.symButtonWidth * 0.5), ...
        exp.scrRect(4) - areaPadding];

    exp.navButtonSym3Color = [242 255 179];
    exp.navButtonSym3Rect = [ ...
        exp.mx + (exp.symButtonWidth * 0.5) + areaPadding, ...
        exp.scrRect(4) - areaPadding - exp.symButtonHeight, ...
        exp.mx + (exp.symButtonWidth * 1.5) + areaPadding, ...
        exp.scrRect(4) - areaPadding];

    logEvent('StartExperiment');
    
    while(exp.state ~= exp.STOP)
        lastLoop = GetSecs();
        switch(exp.state)
            case exp.STANDBY
                doStandby();
            case exp.PHONE
                doPhone();
            case exp.NAV
                doNav();
            case exp.ALARM
                doAlarm();
        end
        
        WaitSecs('UntilTime',lastLoop + loopDelay);
        if(exp.phoneRinging && exp.ringDismiss)
            PsychPortAudio('Stop',exp.audio);
        elseif(exp.ringScheduled && GetSecs() > exp.ringAt)
            PsychPortAudio('Start',exp.audio);
            exp.ringScheduled = false;
            exp.phoneRinging = true;
            logEvent('PhoneRingStart');
        elseif(exp.phoneRinging && ~exp.ringDismiss)
            status = PsychPortAudio('GetStatus',exp.audio);
            if(~status.Active)
                disp('phoneRinging = false');
                exp.phoneRinging = false;
                logEvent('PhoneRingExpired');
            end
        end
        
        drawnow; % Don't forget this or else program locks MATLAB!!!
    end
    
    logEvent('StopExperiment');
    disp('Stopping.');
    Screen('Close',exp.scr);
    ShowCursor();
    
    % Flush and close data files, if needed.
    
    fclose(exp.logFile);
    Screen('Preference', 'SuppressAllWarnings', false);

end