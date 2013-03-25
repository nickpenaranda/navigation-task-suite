function createNav()
% createNav()
%
% (Part of the Navigation Task Suite package)
% Standalone program to design paths for the navigation task.
% 
% Left-click        places nodes
% Shift+Left-click  delete last node
% Right-click       change type of last node
%
% Click the Save button when finished.  This will bring up a save
% dialog to name your path.  Paths should be placed in the path sub-
% directory.
%
% (c) 2013 Nick Penaranda, GMU Arch Lab (ARG -- Dr. Carryl Baldwin)
    Screen('Preference', 'SuppressAllWarnings', true);
    Screen('Preference', 'SkipSyncTests', 2);

    AssertOpenGL;

    winSize = 800;
    [win, rect] = Screen('OpenWindow',0,[0, 0, 0],[32 32 winSize winSize]);
    
    Screen('TextFont',win,'Arial');
    
    [mx,my] = RectCenter(rect);
    
%     exp.navButtonSym1Color = [120 158 204];
%     exp.navButtonSym2Color = [178 111 105];
%     exp.navButtonSym3Color = [242 255 179];

    symColor = { [120 158 204] [178 111 105] [242 255 179] };
    
    saveButtonRect = [ ...
        0, 0, ...
        64, 32];
    saveButtonText = 'Done';
    
    path = {};
    lastType = 1;
    
    KbName('UnifyKeyNames');
    
    nodeSize = 4;
    while(true)
        Screen('FillRect',win,128,saveButtonRect);
        Screen('FrameRect',win,255,saveButtonRect,1);
        Screen('DrawText',win,saveButtonText,4,0,255);
        
        for i=1:length(path)
            node = path{i};
            if(i < length(path))
                nextNode = path{i+1};
                Screen('DrawLine',win, 128, ...
                    node(1), node(2), ...
                    nextNode(1), nextNode(2), ...
                    1);
            end
            Screen('FillOval',win,symColor{node(3)}, ...
                [node(1) - nodeSize, node(2) - nodeSize, ...
                node(1) + nodeSize, node(2) + nodeSize]);
        end
        Screen('Flip',win);
        
        [clicks,x,y,whichButton] = GetClicks(win, 0);
        [a,b,keyCode] = KbCheck();
        if(IsInRect(x,y,saveButtonRect))
            break; % Continue to saving
        else
            %disp(sprintf('%d @ (%f,%f)',whichButton,x,y));
            if(whichButton == 1) % Left click
                if(keyCode(KbName('shift'))) % Shift, delete node
                    if(~isempty(path))
                        path(end) = [];
                    end
                else % No shift, add node
                    newNode = [x,y,lastType];
                    path = vertcat(path,newNode);
                end
            elseif(whichButton == 3) % Right click
                lastType = mod(lastType,3) + 1;
                path{end}(3) = lastType;
            end
        end
    end
    
    Screen('CloseAll');
    
    path = cell2mat(path);
    path(:,1:2) = path(:,1:2) ./ winSize;
    
    [filename,pathname] = uiputfile( ...
        {'*.path', 'Navigation Path Files (*.path)'}, 'Save As');
    
    if(isequal(filename,0) || isequal(pathname,0))
        disp('File not saved.');
    else
        save([pathname filename], 'path');
    end
end