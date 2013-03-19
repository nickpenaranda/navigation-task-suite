function doAlarm()
% doAlarm()
%
% (Part of the Navigation Task Suite package)
% Alarm subscreen?  This will be refactored in future versions.
%
% (c) 2013 Nick Penaranda, GMU Arch Lab (ARG -- Dr. Carryl Baldwin)
    global exp;
    
    if(exp.redraw)
% EMPTY
        Screen('Flip', exp.scr);
        clearRedraw();
    end
end