function doStandby()
    global exp;
    
    if(exp.redraw)
        Screen('FillRect', exp.scr, exp.phoneColor, exp.phoneRect);
        Screen('FrameRect', exp.scr, 255, exp.phoneRect, 1);
        Screen('DrawText', exp.scr, exp.phoneText, exp.phoneTextCoords(1),exp.phoneTextCoords(2), 255);

        Screen('FillRect', exp.scr, exp.navColor, exp.navRect);
        Screen('FrameRect', exp.scr, 255, exp.navRect, 1);
        Screen('DrawText', exp.scr, exp.navText, exp.navTextCoords(1), exp.navTextCoords(2), 255);

        Screen('Flip', exp.scr);
        clearRedraw();
    end
    
    [x,y,buttons] = GetMouse(exp.scr);
    if(any(buttons))
        if(IsInRect(x,y,exp.phoneRect)) % Clicked in phone rect
            exp.state = exp.PHONE;
            expRedraw();
        elseif(IsInRect(x,y,exp.navRect)) % Clicked in nav rect
            exp.state = exp.NAV;
            expRedraw();
        end
    end
    
end