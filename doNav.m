function doNav()
% doNav()
%
% (Part of the Navigation Task Suite package)
% Navigation Task subscreen
%
% Presents the perceptual navigation task to the participant.
%
% (c) 2013 Nick Penaranda, GMU Arch Lab (ARG -- Dr. Carryl Baldwin)
    global exp;
    
    if(exp.redraw)
        visRect = [ ...
            exp.navPosX - exp.mx, exp.navPosY - exp.my, ...
            exp.navPosX + exp.mx, exp.navPosY + exp.my];
        for i=exp.nodeIndex:length(exp.path)
            if(IsInRect(exp.path(i,1),exp.path(i,2),visRect) && ~exp.path(i,4))
                exp.path(i,4) = 1;
                logEvent(sprintf('NavNodeFound,%d,%d',i,exp.path(i,3)));
                %disp(['Node ' num2str(i) ' seen.']);
            end
        end
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
        Screen('DrawText', exp.scr, exp.navBackButtonText, ...
            exp.navBackButtonTextCoords(1), exp.navBackButtonTextCoords(2), ...
            255);
        
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
            logEvent(sprintf('NavDragEnd,%d,%d',exp.navPosX,exp.navPosY));
        end
        exp.clicked = false;
        
    elseif(~exp.clicked && IsInRect(x,y,exp.navBackButtonRect) && ~exp.navDragging)
        exp.state = exp.STANDBY;
        expRedraw();
        doClick();
        logEvent('ReturnToStandby');
        
    elseif(~exp.clicked && IsInRect(x,y,exp.navButtonSym1Rect) && ~exp.navDragging)
        if(exp.path(exp.nodeIndex,3) == 1 && exp.path(exp.nodeIndex,4))
            exp.path(exp.nodeIndex,3) = 4;
            exp.nodeIndex = exp.nodeIndex + 1;
            logEvent('NavReportSymbol,1,Correct');
        else
            logEvent('NavReportSymbol,1,Incorrect');
        end
        doClick();
        expRedraw();

    elseif(~exp.clicked && IsInRect(x,y,exp.navButtonSym2Rect) && ~exp.navDragging)
        if(exp.path(exp.nodeIndex,3) == 2 && exp.path(exp.nodeIndex,4))
            exp.path(exp.nodeIndex,3) = 4;
            exp.nodeIndex = exp.nodeIndex + 1;
            logEvent('NavReportSymbol,2,Correct');
        else
            logEvent('NavReportSymbol,2,Incorrect');
        end
        doClick();
        expRedraw();

    elseif(~exp.clicked && IsInRect(x,y,exp.navButtonSym3Rect) && ~exp.navDragging)
        if(exp.path(exp.nodeIndex,3) == 3 && exp.path(exp.nodeIndex,4))
            exp.path(exp.nodeIndex,3) = 4;
            exp.nodeIndex = exp.nodeIndex + 1;
            logEvent('NavReportSymbol,3,Correct');
        else
            logEvent('NavReportSymbol,3,Incorrect');
        end
        doClick();
        expRedraw();

    elseif(~exp.navDragging && ~exp.clicked)
        exp.navDragging = true;
        exp.navDragLastX = x;
        exp.navDragLastY = y;
        logEvent(sprintf('NavDragStart,%d,%d',exp.navPosX,exp.navPosY));
        
    elseif(~exp.clicked)
        deltaX = x - exp.navDragLastX;
        deltaY = y - exp.navDragLastY;
        exp.navPosX = exp.navPosX - deltaX;
        exp.navPosY = exp.navPosY - deltaY;
        exp.navDragLastX = x;
        exp.navDragLastY = y;
        expRedraw();
    end
    
    if(exp.nodeIndex > length(exp.path) && ~exp.pathComplete) % Complete
        logEvent('NavPathComplete');
        exp.pathComplete = true;
    end
end