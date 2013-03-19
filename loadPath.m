function path = loadPath( name )
% path = loadPath( name )
%
% (Part of the Navigation Task Suite package)
% Loads a premade path into the exp global variable.  Optionally returns
% the path as well.
%
% name              Non-qualified, pathless, extensionless name of path
%                   to load (e.g., 'test')
%
% (c) 2013 Nick Penaranda, GMU Arch Lab (ARG -- Dr. Carryl Baldwin)
    global exp;
    
    pathIn = load(['path\\' name '.path'],'-MAT');
    exp.path = pathIn.path;
    if(~isfield(exp,'pathScale'))
        exp.pathScale = 4000;
    end
    
    exp.path(:,1:2) = exp.path(:,1:2) * exp.pathScale;
    exp.path(:,4) = 0;
    
    exp.pathComplete = false;
    exp.navPosX = exp.path(1,1);
    exp.navPosY = exp.path(1,2);
    exp.nodeIndex = 1;
    exp.navDragging = false;
    exp.navDragLastX = 0;
    exp.navDragLastY = 0;
    
    path = exp.path;
    
    logEvent(sprintf('PathLoaded,%s,%d',name,size(exp.path,1)));
end