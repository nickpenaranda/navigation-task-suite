function doNav()
    global exp;
    
    if(exp.redraw)
        %disp('Rendering navigation!');
        
%     exp.navButtonColor = [172 186 191];
%     exp.navBackButtonRect = [ ...
%         exp.scrRect(3) - areaPadding - 128, ...
%         areaPadding, ...
%         exp.scrRect(3) - areaPadding, ...
%         areaPadding + 32];
%     exp.navBackButtonText = 'Back';
%     
%     exp.SymButtonWidth = exp.scrRect(4) / 4;
%     exp.SymButtonHeight = areaPadding;
%     
%     exp.navButtonSym1Color = [120 158 204];
%     exp.navButtonSym1Rect = [ ...
%         exp.mx - (exp.symButtonWidth * 3) - areaPadding, ...
%         exp.scrRect(4) - areaPadding - exp.SymButtonHeight, ...
%         exp.mx - (exp.symButtonWidth * 1.5) - areaPadding, ...
%         exp.scrRect(4) - areaPadding];
% 
%     exp.navButtonSym2Color = [178 111 105];
%     exp.navButtonSym2Rect = [ ...
%         exp.mx - (exp.symButtonWidth * 0.5), ...
%         exp.scrRect(4) - areaPadding - exp.SymButtonHeight, ...
%         exp.mx + (exp.symButtonWidth * 0.5), ...
%         exp.scrRect(4) - areaPadding];
% 
%     exp.navButtonSym3Color = [242 255 179];
%     exp.navButtonSym3Rect = [ ...
%         exp.mx + (exp.symButtonWidth * 1.5) + areaPadding, ...
%         exp.scrRect(4) - areaPadding - exp.SymButtonHeight, ...
%         exp.mx + (exp.symButtonWidth * 3) + areaPadding, ...
%         exp.scrRect(4) - areaPadding];
% 
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
end