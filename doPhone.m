function doPhone()
    global exp;
    
    if(exp.redraw)
        disp('Rendering phone screen!');
        Screen('Flip', exp.scr);
        clearRedraw();
    end
end