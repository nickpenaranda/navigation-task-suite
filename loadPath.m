function path = loadPath(name)
    global exp;
    
    pathIn = load(['path\\' name '.path'],'-MAT');
    exp.path = pathIn.path;
    if(~isfield(exp,'pathScale'))
        exp.pathScale = 4000;
    end
    
    exp.path(:,1:2) = exp.path(:,1:2) * exp.pathScale;
    exp.path(:,4) = 0;
    path = exp.path;
end