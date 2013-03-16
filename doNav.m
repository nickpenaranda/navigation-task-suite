function doNav()
    global exp;
    
    if(exp.redraw)
        disp('Rendering navigation!');
        Screen('Flip', exp.scr);
        clearRedraw();
    end
end