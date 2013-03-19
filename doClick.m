function doClick()
    global exp;
    exp.clicked = true;
    PsychPortAudio('Stop',exp.clickSlave);
    PsychPortAudio('Start',exp.clickSlave);
end

