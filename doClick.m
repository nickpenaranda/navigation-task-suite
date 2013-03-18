function doClick()
    global exp;
    exp.clicked = true;
    PsychPortAudio('Stop',exp.audio);
    PsychPortAudio('FillBuffer',exp.audio,exp.click);
    PsychPortAudio('Start',exp.audio);
end

