function doClick()
    global exp;
    exp.clicked = true;
    status = PsychPortAudio('GetStatus',exp.audio);
    if(~status.Active)
        PsychPortAudio('Stop',exp.audio);
        PsychPortAudio('FillBuffer',exp.audio,exp.click);
        PsychPortAudio('Start',exp.audio);
    end
end

