function results = NavSuite()
% results = NavSuite()
%
% (Part of the Navigation Task Suite package)
% The main loop function.  Handles all one-time calculations and pop-
% ulates much of the exp global variable.
%
% (c) 2013 Nick Penaranda, GMU Arch Lab (ARG -- Dr. Carryl Baldwin)
    global exp;
    results = {};
    
    maxTPS = 100;
    loopDelay = 1 / maxTPS;
    
    Screen('Preference', 'SuppressAllWarnings', true);

    % PTB init stuff
    AssertOpenGL;
    if(exp.DEBUG)
        [exp.scr,exp.scrRect] = Screen('OpenWindow', ...
            exp.SCREEN_NUM,[0, 0, 0],[32 32 32+800 32+480]);
        [exp.dashScr,exp.alertScrRect] = Screen('OpenWindow', ...
            exp.ALERT_SCREEN_NUM,[0, 0, 0], [848 32 848+640 32+480]);
    else
        [exp.scr,exp.scrRect] = Screen('OpenWindow',exp.SCREEN_NUM,[0, 0, 0],[]);
        [exp.dashScr,exp.alertScrRect] = Screen('OpenWindow',exp.ALERT_SCREEN_NUM,[0, 0, 0], []);
    end
    
    Screen('TextFont',exp.scr,'Arial');

    if(exp.DEBUG)
        ShowCursor('Hand',0);
    else
        HideCursor(exp.scr);
    end
    
    [exp.mx, exp.my] = RectCenter(exp.scrRect);
    
    % Load alarm/task data
    img = imread([exp.alertLocation 'No Vis.jpg']);
    exp.blankTex = Screen('MakeTexture',exp.dashScr,img);
    
    exp.dashTex = exp.blankTex;

    % One-time position calculations
    
    areaPadding = 32;
    exp.areaPadding = areaPadding;

    exp.clicked = false;
    
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
    backTextRect = Screen('TextBounds', exp.scr, exp.navBackButtonText);
    [rmx,rmy] = RectCenter(exp.navBackButtonRect);
    exp.navBackButtonTextCoords = ...
        [rmx - backTextRect(3)/2, rmy - backTextRect(4)/2 ];
    
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
    
    exp.pathColors = {[120 158 204] [178 111 105] [242 255 179] [64]};
    exp.pathNodeSize = 8;
    exp.pathWeight = 2;
    exp.pathScale = 4000;
    
    loadPath('test');
    
    logEvent('StartExperiment');
    
    while(exp.state ~= exp.STOP)
        lastLoop = GetSecs();
        doDash();
        switch(exp.state)
            case exp.STANDBY
                doStandby();
            case exp.PHONE
                doPhone();
            case exp.NAV
                doNav();
        end
        
        WaitSecs('UntilTime',lastLoop + loopDelay);
        
        if(exp.phoneRinging && exp.ringDismiss)
            PsychPortAudio('Stop',exp.ringSlave);
            doClick(); % This needs to be here so that the click itself is not cancelled
        elseif(exp.ringScheduled && GetSecs() > exp.ringAt)
            disp('Starting ringtone');
            exp.ringScheduled = false;
            exp.ringDismiss = false;
            exp.phoneRinging = true;
            PsychPortAudio('Stop',exp.ringSlave);
            PsychPortAudio('Start',exp.ringSlave);
            logEvent('PhoneRingStart');
        elseif(exp.phoneRinging && ~exp.ringDismiss)
            status = PsychPortAudio('GetStatus',exp.ringSlave);
            if(~status.Active)
                exp.phoneRinging = false;
                logEvent('PhoneRingExpired');
            end
        end
        
        drawnow; % Don't forget this or else program locks MATLAB!!!
    end
    
    logEvent('StopExperiment');
    disp('Stopping.');
    Screen('CloseAll');
    ShowCursor();
    
    % Flush and close data files, if needed.
    
    Screen('Preference', 'SuppressAllWarnings', false);

end