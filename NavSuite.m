function results = NavSuite()
    global exp;
    results = {};
    
    maxTPS = 100;
    loopDelay = 1 / maxTPS;
    lastLoop = GetSecs();

    % PTB init stuff
    AssertOpenGL;
    if(exp.DEBUG)
        [exp.scr,exp.scrRect] = Screen('OpenWindow',exp.SCREEN_NUM,[0, 0, 0],[32 32 640 480]);
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
    exp.phoneText = 'Phone';
    exp.phoneRect = [areaPadding, areaPadding, ...
        exp.mx - areaPadding, ...
        exp.scrRect(4) - areaPadding];
    phoneTextRect = Screen('TextBounds', exp.scr, 'Phone');
    phoneTextSize = [phoneTextRect(3) phoneTextRect(4)];
    exp.phoneTextCoords = [exp.mx / 2 - (phoneTextSize(1) / 2), exp.my - (phoneTextSize(2) / 2)];

    exp.navColor = [33 68 91];
    exp.navText = 'Navigation';
    exp.navRect = [exp.mx + areaPadding, areaPadding, ...
        exp.scrRect(3) - areaPadding, ...
        exp.scrRect(4) - areaPadding];
    navTextRect = Screen('TextBounds', exp.scr, 'Navigation');
    navTextSize = [navTextRect(3) navTextRect(4)];
    exp.navTextCoords = [exp.mx + (exp.mx / 2 - (navTextSize(1) / 2)), exp.my - (navTextSize(2) / 2)];

    % Nav mode
    
    while(exp.state ~= exp.STOP)
        WaitSecs('UntilTime',lastLoop + loopDelay);
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
        
        drawnow; % Don't forget this or else program locks MATLAB!!!
    end
    
    disp('Stopping.');
    Screen('Close',exp.scr);
    ShowCursor();
    
    % Flush and close data files, if needed.
    
    clear exp; % Reclaim
end