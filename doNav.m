function doNav()
    global exp;
    
    if(exp.redraw)
        workingPath = exp.path;
        workingPath(:,1) = workingPath(:,1) - exp.navPosX;
        workingPath(:,2) = workingPath(:,2) - exp.navPosY;
        for(i=1:length(workingPath))
            node = workingPath(i,:);
            if(i < length(workingPath))
                nextNode = workingPath(i+1,:);
                Screen('DrawLine',exp.scr, 128, ...
                    node(1) + exp.mx, node(2) + exp.my, ...
                    nextNode(1) + exp.mx, nextNode(2) + exp.my, ...
                    exp.pathWeight);
            end
            Screen('FillOval',exp.scr,exp.pathColors{node(3)}, ...
                [node(1) - exp.pathNodeSize + exp.mx, node(2) - exp.pathNodeSize + exp.my, ...
                node(1) + exp.pathNodeSize + exp.mx, node(2) + exp.pathNodeSize + exp.my]);
        end
        Screen('FillRect', exp.scr, exp.navButtonColor, exp.navBackButtonRect);
        Screen('FrameRect', exp.scr, 255, exp.navBackButtonRect, 1);
        
        Screen('FillRect', exp.scr, exp.navButtonSym1Color, exp.navButtonSym1Rect);
        Screen('FrameRect', exp.scr, 255, exp.navButtonSym1Rect, 1);
        
        Screen('FillRect', exp.scr, exp.navButtonSym2Color, exp.navButtonSym2Rect);
        Screen('FrameRect', exp.scr, 255, exp.navButtonSym2Rect, 1);
        
        Screen('FillRect', exp.scr, exp.navButtonSym3Color, exp.navButtonSym3Rect);
        Screen('FrameRect', exp.scr, 255, exp.navButtonSym3Rect, 1);

        Screen('Flip', exp.scr);
        clearRedraw();
    end
    
    [x,y,buttons] = GetMouse(exp.scr);
    if(~any(buttons))
        if(exp.navDragging)
            exp.navDragging = false;
            logEvent(sprintf('DraggedNav,%d,%d',exp.navPosX,exp.navPosY));
        end
        exp.clicked = false;
        
    elseif(~exp.clicked && IsInRect(x,y,exp.navBackButtonRect) && ~exp.navDragging)
        exp.state = exp.STANDBY;
        expRedraw();
        doClick();
        logEvent('ReturnToStandby');
        
    elseif(~exp.clicked && IsInRect(x,y,exp.navButtonSym1Rect) && ~exp.navDragging)
        if(exp.path(exp.nodeIndex,3) == 1)
            exp.path(exp.nodeIndex,3) = 4;
            exp.nodeIndex = exp.nodeIndex + 1;
            logEvent('NavReportSymbol,1,Correct');
        else
            logEvent('NavReportSymbol,1,Incorrect');
        end
        doClick();
        expRedraw();

    elseif(~exp.clicked && IsInRect(x,y,exp.navButtonSym2Rect) && ~exp.navDragging)
        if(exp.path(exp.nodeIndex,3) == 2)
            exp.path(exp.nodeIndex,3) = 4;
            exp.nodeIndex = exp.nodeIndex + 1;
            logEvent('NavReportSymbol,2,Correct');
        else
            logEvent('NavReportSymbol,2,Incorrect');
        end
        doClick();
        expRedraw();

    elseif(~exp.clicked && IsInRect(x,y,exp.navButtonSym3Rect) && ~exp.navDragging)
        if(exp.path(exp.nodeIndex,3) == 3)
            exp.path(exp.nodeIndex,3) = 4;
            exp.nodeIndex = exp.nodeIndex + 1;
            logEvent('NavReportSymbol,3,Correct');
        else
            logEvent('NavReportSymbol,3,Incorrect');
        end
        doClick();
        expRedraw();

    elseif(~exp.navDragging)
        exp.navDragging = true;
        exp.navDragLastX = x;
        exp.navDragLastY = y;
    else
        deltaX = x - exp.navDragLastX;
        deltaY = y - exp.navDragLastY;
        exp.navPosX = exp.navPosX - deltaX;
        exp.navPosY = exp.navPosY - deltaY;
        exp.navDragLastX = x;
        exp.navDragLastY = y;
        expRedraw();
    end
end