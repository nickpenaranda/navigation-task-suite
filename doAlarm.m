function doAlarm()
    global exp;
    
    if(exp.redraw)
% EMPTY
        Screen('Flip', exp.scr);
        clearRedraw();
    end
end